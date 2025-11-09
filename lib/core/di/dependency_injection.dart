import 'package:get/get.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/domain/services/home_service.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';

/// Dependency Injection setup for the application.
///
/// This class manages all service and repository instances using the GetX
/// dependency injection framework. It follows the Dependency Inversion Principle
/// by ensuring that high-level modules don't depend on low-level modules.
///
/// **Architecture Layers:**
/// - Core Services: Low-level services (API, Cache, Connectivity)
/// - Repositories: Data access layer (handles API calls and caching)
/// - Domain Services: Business logic layer (coordinates repositories)
/// - Controllers: Presentation layer (manages UI state)
///
/// **Usage:**
/// Call [init] in main.dart before running the app:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await DependencyInjection.init();
///   runApp(MyApp());
/// }
/// ```
///
/// **Testing:**
/// Use [clear] to reset all dependencies between tests:
/// ```dart
/// setUp(() {
///   DependencyInjection.clear();
///   DependencyInjection.init();
/// });
/// ```
class DependencyInjection {
  // Private constructor to prevent instantiation
  DependencyInjection._();

  /// Initialize all application dependencies.
  ///
  /// This method sets up all services, repositories, and controllers using
  /// lazy initialization. Dependencies are only created when first accessed.
  ///
  /// **Initialization Order:**
  /// 1. Core Services (API, Cache, Connectivity)
  /// 2. Repositories (depends on Core Services)
  /// 3. Domain Services (depends on Repositories and Core Services)
  /// 4. Controllers (depends on Domain Services and Repositories)
  ///
  /// The `fenix: true` parameter ensures services are recreated if deleted.
  static Future<void> init() async {
    // Core Services (Singletons)
    Get.lazyPut<CacheService>(() => CacheService(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);

    // Repositories
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Domain Services
    Get.lazyPut<HomeService>(
      () => HomeService(
        repository: Get.find<HomeRepository>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<HomeController>(
      () => HomeController(
        homeService: Get.find<HomeService>(),
        repository: Get.find<HomeRepository>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
    );
  }

  /// Clear all dependencies from memory.
  ///
  /// This is useful for testing to ensure a clean state between tests.
  /// The `force: true` parameter ensures all instances are deleted even
  /// if they're marked as permanent.
  ///
  /// **Example:**
  /// ```dart
  /// tearDown(() {
  ///   DependencyInjection.clear();
  /// });
  /// ```
  static void clear() {
    Get.deleteAll(force: true);
  }
}