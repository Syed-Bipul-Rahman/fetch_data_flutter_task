# StackFood Flutter App

A production-grade Flutter application for food delivery with advanced features including offline support, caching, and optimal performance.

## Features

### Core Functionality
- **Offline-First Architecture**: Data cached locally for offline access
- **Smart Caching Strategy**:
  - First-time users with no internet see retry UI
  - Cached data shown immediately on subsequent launches
  - Background refresh when online
- **Optimal Performance**:
  - Non-blocking UI updates
  - Shimmer loading states
  - Lazy loading and pagination
  - Memory leak prevention
- **State Management**: GetX for reactive state management
- **Network Connectivity**: Real-time connectivity monitoring

### UI/UX Features
- **Shimmer Loading**: Beautiful skeleton screens during data fetch
- **Pull-to-Refresh**: Swipe down to refresh data
- **Infinite Scroll**: Automatic pagination for restaurants list
- **Error Handling**: User-friendly error messages and retry options
- **Responsive Design**: Adapts to different screen sizes using ScreenUtil

### Data Features
- **Banners**: Promotional banners carousel
- **Categories**: Food categories with images
- **Popular Foods**: Trending food items nearby
- **Food Campaigns**: Special campaign items
- **Restaurants**: Paginated list of restaurants with ratings

## Architecture

### Clean Architecture with Repository Pattern
```
lib/
├── core/
│   ├── constants/      # API endpoints and cache keys
│   ├── services/       # Singleton services (API, Cache, Connectivity)
│   └── utils/          # Colors and utilities
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/       # Data models with serialization
│       │   └── repositories/ # Data layer with caching logic
│       └── presentation/
│           ├── controllers/  # GetX controllers
│           ├── widgets/      # Reusable widgets
│           └── home_page.dart
```

### Key Design Patterns
- **Singleton Pattern**: Services (API, Cache, Connectivity)
- **Repository Pattern**: Centralized data management
- **Observer Pattern**: GetX reactive state management
- **Factory Pattern**: Model serialization

## Technical Implementation

### Offline Strategy
1. **First Launch (No Internet)**:
   - Shows retry UI with clear message
   - User can tap retry when connected

2. **Cached Data Available**:
   - Instantly shows cached data (non-blocking)
   - Fetches fresh data in background
   - Updates UI seamlessly

3. **Online Mode**:
   - Always fetches latest data
   - Updates cache automatically
   - No blocking operations

### Memory Management
- Proper stream subscription cancellation
- ScrollController disposal
- GetX controller cleanup in onClose()
- Efficient image caching with CachedNetworkImage
- No memory leaks

### Performance Optimizations
- Parallel API calls with Future.wait()
- Lazy loading for images
- Pagination for large lists
- Efficient cache reads
- Minimal rebuilds with GetX

## Dependencies

```yaml
dependencies:
  flutter_sdk: ^3.9.0

  # State Management
  get: ^4.6.6

  # Networking
  dio: ^5.7.0
  connectivity_plus: ^6.0.5

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.4

  # UI/UX
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  flutter_screenutil: ^5.9.3
```

## Setup & Installation

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart SDK
- Android Studio / Xcode

### Installation Steps

1. **Navigate to project directory**
   ```bash
   cd flutter_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For iOS
   flutter run -d ios

   # For Android
   flutter run -d android
   ```

## API Endpoints

Base URL: `https://stackfood-admin.6amtech.com`

- **Config**: `/api/v1/config`
- **Banners**: `/api/v1/banners`
- **Categories**: `/api/v1/categories`
- **Popular Foods**: `/api/v1/products/popular`
- **Food Campaigns**: `/api/v1/campaigns/item`
- **Restaurants**: `/api/v1/restaurants/get-restaurants/all?offset={offset}&limit={limit}`

### Required Headers
```
Content-Type: application/json; charset=UTF-8
zoneId: [1]
latitude: 23.735129
longitude: 90.425614
```

## Testing

### API Testing
All APIs have been tested with curl and verified to return correct data.

### Code Analysis
```bash
flutter analyze
```

All critical issues resolved. Only minor linting suggestions remain.

## Platform-Specific Configuration

### Android
Permissions added in `android/app/src/main/AndroidManifest.xml`:
- INTERNET
- ACCESS_NETWORK_STATE
- CHANGE_NETWORK_STATE

### iOS
Configuration in `ios/Runner/Info.plist`:
- NSAppTransportSecurity with NSAllowsArbitraryLoads

## Best Practices Implemented

✅ **No Hardcoded Values**: All constants in separate files
✅ **Decoupling**: Clear separation of concerns
✅ **Error Handling**: Try-catch blocks with user feedback
✅ **Memory Leaks Prevention**: Proper resource disposal
✅ **Null Safety**: Null-aware operators throughout
✅ **Code Quality**: Follows Flutter best practices
✅ **Performance**: Optimized for 60fps
✅ **Accessibility**: Semantic widgets and labels
✅ **Responsiveness**: ScreenUtil for consistent sizing

## Production Readiness

### Security
- No API keys hardcoded
- Secure HTTPS connections
- Input validation

### Performance
- Image caching
- Efficient state management
- Lazy loading
- Optimized builds

### Reliability
- Error boundaries
- Retry mechanisms
- Offline support
- Connection monitoring

### Maintainability
- Clean architecture
- Well-documented code
- Consistent naming
- Modular structure

## Project Structure

```
flutter_task/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # App configuration
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart        # API endpoints & cache keys
│   │   ├── services/
│   │   │   ├── api_service.dart          # Dio HTTP client
│   │   │   ├── cache_service.dart        # Hive cache manager
│   │   │   └── connectivity_service.dart # Network monitoring
│   │   └── utils/
│   │       └── app_colors.dart           # Color palette
│   └── features/
│       └── home/
│           ├── data/
│           │   ├── models/
│           │   │   ├── banner_model.dart
│           │   │   ├── category_model.dart
│           │   │   ├── product_model.dart
│           │   │   └── restaurant_model.dart
│           │   └── repositories/
│           │       └── home_repository.dart
│           └── presentation/
│               ├── controllers/
│               │   └── home_controller.dart
│               ├── widgets/
│               │   ├── category_item.dart
│               │   ├── food_card.dart
│               │   ├── restaurant_card.dart
│               │   ├── retry_widget.dart
│               │   └── shimmer_widgets.dart
│               └── home_page.dart
├── android/                              # Android-specific files
├── ios/                                  # iOS-specific files
└── pubspec.yaml                          # Dependencies
```

## Key Features Implementation

### 1. Offline Support
The app uses a sophisticated caching strategy:
- Data is cached using Hive local database
- On app launch, cached data is shown immediately
- Fresh data is fetched in the background if online
- First-time users without internet see a retry UI

### 2. State Management
Using GetX for reactive state management:
- Minimal boilerplate
- Efficient rebuilds
- Memory leak prevention
- Clean controller lifecycle

### 3. Network Monitoring
Real-time connectivity detection:
- Automatic refresh when connection restored
- User feedback for offline state
- Graceful degradation

### 4. Performance
- Parallel API calls reduce loading time
- Image caching prevents redundant downloads
- Pagination for efficient data loading
- Shimmer effects for better UX

## Troubleshooting

### Common Issues

**Issue**: App not fetching data
- Check internet connection
- Verify API endpoints are accessible
- Check console for errors

**Issue**: Images not loading
- Ensure internet connectivity
- Check if image URLs are valid
- Clear app cache and restart

**Issue**: Offline mode not working
- Ensure data was fetched at least once online
- Check Hive initialization
- Verify cache service is initialized

## Development Notes

### Code Quality
- All files follow Flutter style guide
- Proper error handling throughout
- Comprehensive null safety
- Clean architecture principles

### Performance Monitoring
- No blocking operations on main thread
- Efficient memory usage
- Smooth 60fps animations
- Fast app startup

## Future Enhancements

- Search functionality
- Filter and sort options
- User authentication
- Order placement
- Push notifications
- Multi-language support
- Dark mode
- Analytics integration

## License

This project is for demonstration purposes.
