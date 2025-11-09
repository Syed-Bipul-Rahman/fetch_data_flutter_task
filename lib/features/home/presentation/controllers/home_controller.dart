import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/repositories/home_repository.dart';
import '../../domain/services/home_service.dart';

enum LoadingState { initial, loading, loaded, error, offline }

class HomeController extends GetxController {
  final HomeService _homeService;
  final HomeRepository _repository;
  final ConnectivityService _connectivityService;

  HomeController({
    required HomeService homeService,
    required HomeRepository repository,
    required ConnectivityService connectivityService,
  })  : _homeService = homeService,
        _repository = repository,
        _connectivityService = connectivityService;

  // State management
  final Rx<LoadingState> _loadingState = LoadingState.initial.obs;
  LoadingState get loadingState => _loadingState.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final RxBool _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  // Data
  final RxList<BannerModel> _banners = <BannerModel>[].obs;
  List<BannerModel> get banners => _banners;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;

  final RxList<ProductModel> _popularFoods = <ProductModel>[].obs;
  List<ProductModel> get popularFoods => _popularFoods;

  final RxList<ProductModel> _foodCampaigns = <ProductModel>[].obs;
  List<ProductModel> get foodCampaigns => _foodCampaigns;

  final RxList<RestaurantModel> _restaurants = <RestaurantModel>[].obs;
  List<RestaurantModel> get restaurants => _restaurants;

  // Pagination
  int _currentPage = 0;
  int _totalSize = 0;
  final int _limit = 10;
  final RxBool _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;

  bool get hasMoreRestaurants =>
      _restaurants.length < _totalSize && !_isLoadingMore.value;

  // Scroll controller and app bar visibility
  ScrollController? _scrollController;
  ScrollController? get scrollController => _scrollController;

  double _lastScrollOffset = 0.0;
  final RxBool _showAppBar = true.obs;
  bool get showAppBar => _showAppBar.value;

  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initScrollController();
    _listenToConnectivity();
    loadData();
  }

  void _initScrollController() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_onScroll);
  }

  void _listenToConnectivity() {
    bool isFirstEvent = true;

    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isConnected,
    ) {
      _isConnected.value = isConnected;

      // Skip the first event (initial state) to avoid duplicate calls
      if (isFirstEvent) {
        isFirstEvent = false;
        return;
      }

      // Auto-refresh when connection is restored (not on initial load)
      if (isConnected && _repository.hasCache()) {
        loadData(forceRefresh: true);
      }
    });
  }

  void _onScroll() {
    if (_scrollController == null) return;

    final position = _scrollController!.position;
    final currentOffset = position.pixels;

    // Handle app bar visibility based on scroll direction
    if (currentOffset <= 0) {
      // At the top - always show app bar
      _showAppBar.value = true;
    } else if (currentOffset > 1) {
      // Scrolled away from top
      final isScrollingDown = currentOffset < _lastScrollOffset;
      final isScrollingUp = currentOffset > _lastScrollOffset;

      if (isScrollingUp && _showAppBar.value) {
        // Scrolling up (content going up, revealing later content) - hide app bar
        _showAppBar.value = false;
      } else if (isScrollingDown && !_showAppBar.value) {
        // Scrolling down (content going down, going back to earlier content) - show app bar
        _showAppBar.value = true;
      }
    }

    _lastScrollOffset = currentOffset;

    // Pagination logic
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !_isLoadingMore.value &&
        hasMoreRestaurants &&
        _isConnected.value) {
      loadMoreRestaurants();
    }
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    assert(() {
      if (kDebugMode) {
        print('🔄 loadData called (forceRefresh: $forceRefresh)');
      }
      return true;
    }());

    try {
      _errorMessage.value = '';

      // Check connectivity
      final hasCache = _repository.hasCache();
      final isOnline = await _connectivityService.checkConnectivity();
      _isConnected.value = isOnline;

      assert(() {
        if (kDebugMode) {
          print('   Has cache: $hasCache, Online: $isOnline');
        }
        return true;
      }());

      // Determine initial state
      if (hasCache) {
        // Have cache - show it immediately
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        // No cache - show loading
        _loadingState.value = LoadingState.loading;
      }

      // Try to fetch fresh data if online
      if (isOnline) {
        try {
          await _homeService.fetchAllHomeData(_currentPage, _limit);
          _loadFromCache();
          _loadingState.value = LoadingState.loaded;
        } on NoInternetException catch (e) {
          if (!hasCache) {
            _loadingState.value = LoadingState.offline;
            _errorMessage.value = 'No internet connection. Please try again.';
          }
          assert(() {
            if (kDebugMode) {
              print('Internet connection error: $e');
            }
            return true;
          }());
        } on TimeoutException catch (e) {
          if (!hasCache) {
            _loadingState.value = LoadingState.error;
            _errorMessage.value = 'Request timeout. Please try again.';
          }
          assert(() {
            if (kDebugMode) {
              print('Timeout error: $e');
            }
            return true;
          }());
        } on ServerException catch (e) {
          if (!hasCache) {
            _loadingState.value = LoadingState.error;
            _errorMessage.value = 'Server error: ${e.message}';
          }
          assert(() {
            if (kDebugMode) {
              print('Server error: $e');
            }
            return true;
          }());
        } on AppException catch (e) {
          if (!hasCache) {
            _loadingState.value = LoadingState.error;
            _errorMessage.value = e.message;
          }
          assert(() {
            if (kDebugMode) {
              print('App exception: $e');
            }
            return true;
          }());
        } catch (e) {
          // If we have cache, silently fail the background update
          if (!hasCache) {
            _loadingState.value = LoadingState.error;
            _errorMessage.value = 'An unexpected error occurred';
          }
          assert(() {
            if (kDebugMode) {
              print('Background refresh failed: $e');
            }
            return true;
          }());
        }
      } else {
        // Offline
        if (hasCache) {
          // Already showing cache, just stay in loaded state
          _loadingState.value = LoadingState.loaded;
        } else {
          // First time offline with no cache
          _loadingState.value = LoadingState.offline;
          _errorMessage.value = 'No internet connection. Please try again.';
        }
      }
    } on NoInternetException {
      if (_repository.hasCache()) {
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.offline;
        _errorMessage.value = 'No internet connection. Please try again.';
      }
    } on TimeoutException {
      if (_repository.hasCache()) {
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = 'Request timeout. Please try again.';
      }
    } on ServerException catch (e) {
      if (_repository.hasCache()) {
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = 'Server error: ${e.message}';
      }
    } on AppException catch (e) {
      if (_repository.hasCache()) {
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.message;
      }
    } catch (e) {
      // Check if we have cache to fall back to
      if (_repository.hasCache()) {
        _loadFromCache();
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = 'An unexpected error occurred';
      }
      assert(() {
        if (kDebugMode) {
          print('Error loading data: $e');
        }
        return true;
      }());
    }
  }

  void _loadFromCache() {
    _banners.value = _repository.getCachedBanners();
    _categories.value = _repository.getCachedCategories();
    _popularFoods.value = _repository.getCachedPopularFoods();
    _foodCampaigns.value = _repository.getCachedFoodCampaigns();
    _restaurants.value = _repository.getCachedRestaurants();
    _totalSize = _repository.getCachedRestaurantsTotalSize();

    // Debug logging
    assert(() {
      if (kDebugMode) {
        print('📦 Loaded from cache:');
        print('   Banners: ${_banners.length}');
        print('   Categories: ${_categories.length}');
        print('   Popular Foods: ${_popularFoods.length}');
        print('   Campaigns: ${_foodCampaigns.length}');
        print('   Restaurants: ${_restaurants.length}');
      }

      return true;
    }());
  }

  Future<void> loadMoreRestaurants() async {
    if (_isLoadingMore.value || !hasMoreRestaurants) return;

    try {
      _isLoadingMore.value = true;
      _currentPage++;

      final newRestaurants = await _homeService.fetchMoreRestaurants(
        _currentPage * _limit,
        _limit,
      );

      if (newRestaurants.isNotEmpty) {
        _restaurants.addAll(newRestaurants);
      }
    } on NoInternetException {
      _currentPage--;
      Get.snackbar(
        'Load More Failed',
        'No internet connection',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } on TimeoutException {
      _currentPage--;
      Get.snackbar(
        'Load More Failed',
        'Request timeout. Please try again',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } on ServerException catch (e) {
      _currentPage--;
      Get.snackbar(
        'Load More Failed',
        'Server error: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } on AppException catch (e) {
      _currentPage--;
      Get.snackbar(
        'Load More Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _currentPage--;
      Get.snackbar(
        'Load More Failed',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<void> retry() async {
    await loadData(forceRefresh: true);
  }

  @override
  Future<void> refresh() async {
    _currentPage = 0;
    _restaurants.clear();
    await loadData(forceRefresh: true);
  }

  @override
  void onClose() {
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    _scrollController = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _repository.dispose();
    super.onClose();
  }
}
