import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/repositories/home_repository.dart';

/// Service layer that handles business logic for the home feature.
///
/// This class implements the **Service Layer Pattern**, separating business logic
/// from data access logic. It coordinates multiple repository calls and handles
/// cross-cutting concerns like connectivity checking.
///
/// **Responsibilities:**
/// - Coordinate multiple repository operations
/// - Check connectivity before network operations
/// - Implement business rules and workflows
/// - Handle error scenarios with fallback logic
///
/// **Architecture:**
/// ```
/// Controller -> HomeService -> HomeRepository -> ApiService
///                            -> ConnectivityService
/// ```
///
/// **Usage:**
/// ```dart
/// final homeService = Get.find<HomeService>();
/// try {
///   await homeService.fetchAllHomeData(0, 10);
/// } on NoInternetException {
///   // Show offline UI
/// }
/// ```
class HomeService {
  final HomeRepository _repository;
  final ConnectivityService _connectivityService;

  /// Creates a [HomeService] with required dependencies.
  ///
  /// Dependencies are typically injected via [DependencyInjection.init()].
  HomeService({
    required HomeRepository repository,
    required ConnectivityService connectivityService,
  })  : _repository = repository,
        _connectivityService = connectivityService;

  /// Fetches all home screen data in parallel.
  ///
  /// This method performs the following operations concurrently:
  /// 1. Fetch banners
  /// 2. Fetch categories
  /// 3. Fetch popular foods
  /// 4. Fetch food campaigns
  /// 5. Fetch restaurants (paginated)
  ///
  /// **Parameters:**
  /// - [currentPage]: The page number for restaurant pagination (0-based)
  /// - [limit]: Number of restaurants to fetch per page
  ///
  /// **Throws:**
  /// - [NoInternetException]: If the device is offline
  /// - [AppException]: If all requests fail and no cache is available
  ///
  /// **Behavior:**
  /// - Checks connectivity before making requests
  /// - Fetches all data in parallel for optimal performance
  /// - Falls back to cache if requests fail but cache exists
  /// - All successful responses are automatically cached
  ///
  /// **Example:**
  /// ```dart
  /// try {
  ///   await homeService.fetchAllHomeData(0, 10);
  ///   // Data is now cached and available
  /// } on NoInternetException {
  ///   // Load from cache or show offline message
  ///   final cachedData = await homeService.getCachedHomeData();
  /// }
  /// ```
  Future<void> fetchAllHomeData(int currentPage, int limit) async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      throw NoInternetException();
    }

    try {
      await Future.wait([
        _repository.getBanners(),
        _repository.getCategories(),
        _repository.getPopularFoods(),
        _repository.getFoodCampaigns(),
        _repository.getRestaurants(currentPage, limit),
      ]);
    } on AppException {
      // If any request fails but we have cached data, we're still ok
      if (!_repository.hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Fetches additional restaurants for pagination.
  ///
  /// This method loads more restaurants and automatically appends them to the cache.
  ///
  /// **Parameters:**
  /// - [offset]: The starting index for the next page
  /// - [limit]: Number of restaurants to fetch
  ///
  /// **Returns:**
  /// A list of [RestaurantModel] objects for the requested page.
  ///
  /// **Throws:**
  /// - [AppException]: If the request fails (network or server error)
  ///
  /// **Behavior:**
  /// - Fetches from API
  /// - Appends results to existing cached restaurants
  /// - Updates total size in cache
  ///
  /// **Example:**
  /// ```dart
  /// // Load first page
  /// await homeService.fetchAllHomeData(0, 10);
  ///
  /// // Load next page
  /// final moreRestaurants = await homeService.fetchMoreRestaurants(10, 10);
  /// print('Loaded ${moreRestaurants.length} more restaurants');
  /// ```
  Future<List<RestaurantModel>> fetchMoreRestaurants(
    int offset,
    int limit,
  ) async {
    return await _repository.fetchMoreRestaurants(offset, limit);
  }

  /// Checks if cached data is available for offline use.
  ///
  /// Returns `true` if at least banner data exists in cache.
  /// This is used to determine if the app can work offline.
  ///
  /// **Example:**
  /// ```dart
  /// if (homeService.hasOfflineData()) {
  ///   print('Can work offline');
  /// } else {
  ///   print('Need internet connection');
  /// }
  /// ```
  bool hasOfflineData() {
    return _repository.hasCache();
  }

  /// Retrieves all cached home screen data.
  ///
  /// This method loads data from the local cache without making network requests.
  /// Useful for offline mode or showing stale data while fetching fresh data.
  ///
  /// **Returns:**
  /// A [HomeData] object containing all cached lists.
  ///
  /// **Behavior:**
  /// - Returns empty lists if no cache exists
  /// - Does not throw exceptions
  /// - Synchronous operation (wrapped in Future for API consistency)
  ///
  /// **Example:**
  /// ```dart
  /// final data = await homeService.getCachedHomeData();
  /// print('Cached banners: ${data.banners.length}');
  /// print('Cached restaurants: ${data.restaurants.length}');
  /// ```
  Future<HomeData> getCachedHomeData() async {
    return HomeData(
      banners: _repository.getCachedBanners(),
      categories: _repository.getCachedCategories(),
      popularFoods: _repository.getCachedPopularFoods(),
      foodCampaigns: _repository.getCachedFoodCampaigns(),
      restaurants: _repository.getCachedRestaurants(),
      totalRestaurants: _repository.getCachedRestaurantsTotalSize(),
    );
  }
}

/// Data transfer object that holds all home screen data.
///
/// This class aggregates all the data needed for the home screen in a single object,
/// making it easier to pass around and reducing the number of parameters needed.
///
/// **Usage:**
/// ```dart
/// final homeData = await homeService.getCachedHomeData();
///
/// // Access individual lists
/// for (var banner in homeData.banners) {
///   print(banner.title);
/// }
///
/// // Check pagination status
/// if (homeData.restaurants.length < homeData.totalRestaurants) {
///   print('More restaurants available');
/// }
/// ```
class HomeData {
  /// List of promotional banners
  final List<BannerModel> banners;

  /// List of food categories
  final List<CategoryModel> categories;

  /// List of popular food items nearby
  final List<ProductModel> popularFoods;

  /// List of ongoing food campaigns/deals
  final List<ProductModel> foodCampaigns;

  /// List of restaurants (paginated)
  final List<RestaurantModel> restaurants;

  /// Total number of restaurants available (for pagination)
  final int totalRestaurants;

  /// Creates a [HomeData] object with all home screen data.
  HomeData({
    required this.banners,
    required this.categories,
    required this.popularFoods,
    required this.foodCampaigns,
    required this.restaurants,
    required this.totalRestaurants,
  });
}
