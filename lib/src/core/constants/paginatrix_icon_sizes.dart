/// Constants for consistent icon sizes throughout the package.
///
/// This class provides standardized icon size values to eliminate magic numbers
/// and ensure consistent icon sizing across all widgets.
///
/// ## Usage
///
/// ```dart
/// Icon(
///   Icons.error_outline,
///   size: PaginatrixIconSizes.large,
/// )
/// ```
class PaginatrixIconSizes {
  PaginatrixIconSizes._(); // Private constructor to prevent instantiation

  /// Large icon size for empty states and error views (default: 64.0)
  ///
  /// Used for:
  /// - Empty state icons
  /// - Error view icons
  /// - Main status icons
  static const double large = 64;

  /// Small icon size for inline indicators and compact views (default: 20.0)
  ///
  /// Used for:
  /// - Inline error indicators
  /// - Append error icons
  /// - Page selector icons
  /// - Compact UI elements
  static const double small = 20;
}
