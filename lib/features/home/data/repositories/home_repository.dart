import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/restaurant_model.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();
  final ConnectivityService _connectivityService = ConnectivityService();

  // Fetch banners with cache-first strategy
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _apiService.get(ApiConstants.banners);
      final banners = (response.data['banners'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();

      // Cache successful response
      await _cacheService.put(
        ApiConstants.cacheBanners,
        banners.map((e) => e.toJson()).toList(),
      );

      return banners;
    } catch (e) {
      // Return cached data on error
      return getCachedBanners();
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categories);
      final categories = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      await _cacheService.put(
        ApiConstants.cacheCategories,
        categories.map((e) => e.toJson()).toList(),
      );

      return categories;
    } catch (e) {
      return getCachedCategories();
    }
  }

  Future<List<ProductModel>> getPopularFoods() async {
    try {
      final response = await _apiService.get(ApiConstants.popularFoods);
      final products = (response.data['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      await _cacheService.put(
        ApiConstants.cachePopularFoods,
        products.map((e) => e.toJson()).toList(),
      );

      return products;
    } catch (e) {
      return getCachedPopularFoods();
    }
  }

  Future<List<ProductModel>> getFoodCampaigns() async {
    try {
      final response = await _apiService.get(ApiConstants.foodCampaigns);
      // API returns plain array, not {campaigns: []}
      final campaigns = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      await _cacheService.put(
        ApiConstants.cacheFoodCampaigns,
        campaigns.map((e) => e.toJson()).toList(),
      );

      return campaigns;
    } catch (e) {
      return getCachedFoodCampaigns();
    }
  }

  Future<RestaurantsResponse> getRestaurants(int offset, int limit) async {
    try {
      final response = await _apiService.get(
        ApiConstants.restaurants(offset, limit),
      );
      final restaurantsResponse = RestaurantsResponse.fromJson(
        response.data['restaurants'],
      );

      // For first page, replace cache; for pagination, append
      if (offset == 0) {
        await _cacheService.put(
          ApiConstants.cacheRestaurants,
          restaurantsResponse.data?.map((e) => e.toJson()).toList() ?? [],
        );
        await _cacheService.put(
          ApiConstants.cacheRestaurantsTotalSize,
          restaurantsResponse.totalSize,
        );
      }

      return restaurantsResponse;
    } catch (e) {
      if (offset == 0) {
        return RestaurantsResponse(
          data: getCachedRestaurants(),
          totalSize: getCachedRestaurantsTotalSize(),
        );
      }
      rethrow;
    }
  }

  // Fetch all data in parallel (non-blocking)
  Future<void> fetchAndCacheAll(int currentPage, int limit) async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }

    try {
      await Future.wait([
        getBanners(),
        getCategories(),
        getPopularFoods(),
        getFoodCampaigns(),
        getRestaurants(currentPage, limit),
      ]);
    } catch (e) {
      // If any request fails but we have cached data, we're still ok
      if (!hasCache()) {
        rethrow;
      }
    }
  }

  // Load more restaurants (for pagination)
  Future<List<RestaurantModel>> fetchMoreRestaurants(
    int offset,
    int limit,
  ) async {
    final response = await getRestaurants(offset, limit);

    // Append to cache
    if (response.data != null && response.data!.isNotEmpty) {
      final currentCached = getCachedRestaurants();
      final newList = [...currentCached, ...response.data!];

      await _cacheService.put(
        ApiConstants.cacheRestaurants,
        newList.map((e) => e.toJson()).toList(),
      );
      await _cacheService.put(
        ApiConstants.cacheRestaurantsTotalSize,
        response.totalSize,
      );
    }

    return response.data ?? [];
  }

  // Helper method to convert dynamic map to String map
  Map<String, dynamic> _convertMap(dynamic map) {
    if (map is Map<String, dynamic>) {
      return map;
    }
    return Map<String, dynamic>.from(map as Map);
  }

  // Cache getters
  List<BannerModel> getCachedBanners() {
    try {
      final jsonList =
          _cacheService.get<List>(
            ApiConstants.cacheBanners,
            defaultValue: [],
          ) ??
          [];

      assert(() {
        if (kDebugMode) {
          print('💾 getCachedBanners: Found ${jsonList.length} items');
        }
        return true;
      }());

      if (jsonList.isEmpty) return [];

      return jsonList
          .map((json) => BannerModel.fromJson(_convertMap(json)))
          .toList();
    } catch (e) {
      assert(() {
        if (kDebugMode) {
          print('❌ Error getting cached banners: $e');
        }
        return true;
      }());
      return [];
    }
  }

  List<CategoryModel> getCachedCategories() {
    try {
      final jsonList =
          _cacheService.get<List>(
            ApiConstants.cacheCategories,
            defaultValue: [],
          ) ??
          [];
      return jsonList
          .map((json) => CategoryModel.fromJson(_convertMap(json)))
          .toList();
    } catch (e) {
      assert(() {
        if (kDebugMode) {
          print('❌ Error getting cached categories: $e');
        }
        return true;
      }());
      return [];
    }
  }

  List<ProductModel> getCachedPopularFoods() {
    try {
      final jsonList =
          _cacheService.get<List>(
            ApiConstants.cachePopularFoods,
            defaultValue: [],
          ) ??
          [];
      return jsonList
          .map((json) => ProductModel.fromJson(_convertMap(json)))
          .toList();
    } catch (e) {
      assert(() {
        if (kDebugMode) {
          print('❌ Error getting cached popular foods: $e');
        }
        return true;
      }());
      return [];
    }
  }

  List<ProductModel> getCachedFoodCampaigns() {
    try {
      final jsonList =
          _cacheService.get<List>(
            ApiConstants.cacheFoodCampaigns,
            defaultValue: [],
          ) ??
          [];
      return jsonList
          .map((json) => ProductModel.fromJson(_convertMap(json)))
          .toList();
    } catch (e) {
      assert(() {
        if (kDebugMode) {
          print('❌ Error getting cached campaigns: $e');
        }
        return true;
      }());
      return [];
    }
  }

  List<RestaurantModel> getCachedRestaurants() {
    try {
      final jsonList =
          _cacheService.get<List>(
            ApiConstants.cacheRestaurants,
            defaultValue: [],
          ) ??
          [];
      return jsonList
          .map((json) => RestaurantModel.fromJson(_convertMap(json)))
          .toList();
    } catch (e) {
      assert(() {
        if (kDebugMode) {
          print('❌ Error getting cached restaurants: $e');
        }
        return true;
      }());
      return [];
    }
  }

  int getCachedRestaurantsTotalSize() {
    return _cacheService.get<int>(
          ApiConstants.cacheRestaurantsTotalSize,
          defaultValue: 0,
        ) ??
        0;
  }

  bool hasCache() {
    return _cacheService.containsKey(ApiConstants.cacheBanners);
  }

  void dispose() {
    _apiService.dispose();
  }
}
