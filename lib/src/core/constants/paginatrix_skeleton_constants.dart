/// Constants for skeleton loading states throughout the package.
///
/// This class provides standardized skeleton count values to eliminate magic numbers
/// and ensure consistent skeleton loading behavior across all widgets.
///
/// ## Usage
///
/// ```dart
/// PaginatrixSkeletonizer(
///   itemCount: PaginatrixSkeletonConstants.defaultItemCount,
/// )
/// ```
class PaginatrixSkeletonConstants {
  PaginatrixSkeletonConstants._(); // Private constructor to prevent instantiation

  /// Default number of skeleton items to display during loading (default: 10)
  ///
  /// Used for:
  /// - Initial skeleton loading states
  /// - Default skeleton item count in PaginatrixSkeletonizer
  /// - List and grid view skeleton placeholders
  static const int defaultItemCount = 10;
}
