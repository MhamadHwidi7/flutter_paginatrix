/// Constants for scroll and pagination threshold configuration.
///
/// This class provides standardized scroll-related values to eliminate magic numbers
/// and ensure consistent scroll behavior across all components.
///
/// ## Usage
///
/// ```dart
/// final thresholdPixels = threshold * PaginatrixScrollConstants.thresholdPixelMultiplier;
/// ```
class PaginatrixScrollConstants {
  PaginatrixScrollConstants._(); // Private constructor to prevent instantiation

  /// Multiplier for converting threshold items to pixels (default: 100.0)
  ///
  /// Used for:
  /// - Converting item-based prefetch threshold to pixel-based scroll distance
  /// - Calculating when to trigger next page load based on scroll position
  /// - Providing consistent scroll behavior across different screen sizes
  ///
  /// **Note:** This assumes approximately 100 pixels per item on average.
  /// The actual value may vary based on item height, but this provides
  /// a reasonable default for most use cases.
  static const double thresholdPixelMultiplier = 100;
}
