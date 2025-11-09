import 'package:flutter/material.dart';

/// Application color palette for consistent theming.
///
/// This class centralizes all color values used throughout the app, ensuring:
/// - **Consistency:** All UI elements use the same color values
/// - **Maintainability:** Change colors app-wide from a single location
/// - **Design system:** Enforces the app's visual identity
/// - **Accessibility:** Easy to update colors for contrast/accessibility
///
/// **Color Categories:**
/// - Primary colors: Brand colors and main theme
/// - Text colors: Typography colors for different contexts
/// - Background colors: Surface and container colors
/// - Utility colors: Shadows, overlays, and special effects
///
/// **Usage:**
/// ```dart
/// Container(
///   color: AppColors.primary,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: AppColors.textDark),
///   ),
/// )
/// ```
///
/// **Naming Convention:**
/// - Use semantic names (e.g., `textDark`) not hex values
/// - Group related colors with comments
/// - Use `const` for static colors
/// - Use non-const for colors with dynamic alpha values
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);

  // Green accents (from design)
  static const Color greenAccent = Color(0xFF00E676);
  static const Color greenAccentLight = Color(0xFF69F0AE);

  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Custom text colors from design
  static const Color textDark = Color(0xFF000743); // Dark navy text
  static const Color textGray = Color(0xFF868686); // Gray text
  static const Color textLightGray = Color(0xFF9f9f9f); // Light gray
  static const Color textMediumGray = Color(0xFF9b9b9b); // Medium gray
  static const Color textDarkGray = Color(0xFFb4b4b4); // Dark gray

  // Shadow and overlay colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.08);
  static Color shadowDark = Colors.black.withValues(alpha: 0.25);
  static const Color textBlack87 = Colors.black87;

  // Shimmer colors
  static Color shimmerBase = Colors.grey[300]!;
  static Color shimmerHighlight = Colors.grey[100]!;
  static Color? shimmerContainer = Colors.grey[200];

  // Banner background colors
  static const Color bannerPeach = Color(0xFFF8CCAD);

  // Rating and accent colors
  static const Color rating = Colors.amber;
  static const Color ratingInactive = Color(0xFFE0E0E0);

  // Other colors
  static const Color error = Color(0xFFD32F2F);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color transparent = Colors.transparent;
  static const Color red = Colors.red;

  // Utility colors
  static Color grey400 = Colors.grey[400]!;
  static Color grey600 = Colors.grey[600]!;
  static Color grey700 = Colors.grey[700]!;
}
