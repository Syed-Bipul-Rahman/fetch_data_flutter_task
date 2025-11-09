/// Application string constants for internationalization and maintainability.
///
/// This class centralizes all user-facing strings in the application, making it
/// easier to:
/// - Update text across the app from a single location
/// - Prepare for internationalization (i18n)
/// - Maintain consistent messaging
/// - Search and replace text efficiently
///
/// **Best Practices:**
/// - Use descriptive constant names that indicate context
/// - Group related strings together with comments
/// - Keep strings in alphabetical order within groups
/// - Use const for compile-time constants
///
/// **Usage:**
/// ```dart
/// Text(AppStrings.searchHint)  // Instead of: Text('Search food or restaurant here...')
/// ```
///
/// **Future i18n Support:**
/// When adding internationalization, this class can be replaced with:
/// ```dart
/// AppLocalizations.of(context).searchHint
/// ```
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // Search
  static const String searchHint = 'Search food or restaurant here...';

  // Section headers
  static const String categories = 'Categories';
  static const String popularFoodNearby = 'Popular Food Nearby';
  static const String foodCampaign = 'Food Campaign';
  static const String restaurants = 'Restaurants';
  static const String viewAll = 'View All';

  // Error messages
  static const String noInternetConnection = 'No Internet Connection';
  static const String noInternetMessage =
      'No internet connection. Please try again.';
  static const String oops = 'Oops!';
  static const String retry = 'Retry';
  static const String loadMoreFailed = 'Load More Failed';
  static const String requestTimeout = 'Request timeout. Please try again';
  static const String serverError = 'Server error';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String failedToLoadData = 'Failed to load data';

  // Placeholders
  static const String unknownProduct = 'Unknown Product';
  static const String unknownRestaurant = 'Unknown Restaurant';
  static const String unknownCategory = 'Unknown Category';

  // Address
  static const String defaultAddress = '76A eight avenue, New York, US';

  // Cache messages
  static const String cacheNotInitialized =
      'Cache service not initialized. Call init() first.';
}
