/// Constants for cache configuration throughout the package.
///
/// This class provides standardized cache size values to eliminate magic numbers
/// and ensure consistent cache behavior across all components.
///
/// ## Usage
///
/// ```dart
/// if (_metaCache.length >= PaginatrixCacheConstants.maxMetaCacheSize) {
///   _evictCacheIfNeeded();
/// }
/// ```
class PaginatrixCacheConstants {
  PaginatrixCacheConstants._(); // Private constructor to prevent instantiation

  /// Maximum size for metadata cache to prevent memory issues (default: 100)
  ///
  /// Used for:
  /// - Metadata parser cache eviction
  /// - Preventing unbounded memory growth
  /// - FIFO cache management
  static const int maxMetaCacheSize = 100;

  /// Maximum data structure size for caching (default: 50)
  ///
  /// Used for:
  /// - Determining if a data structure is small enough to cache
  /// - Preventing memory issues with large data structures
  /// - Only caching reasonably sized data to avoid memory bloat
  ///
  /// **Note:** This is the maximum number of top-level keys/items in a Map/List
  /// that will be considered for caching. Larger structures are not cached.
  static const int maxDataSizeForCaching = 50;
}

/// Constants for pagination value limits throughout the package.
///
/// This class provides standardized pagination limit values to eliminate magic numbers
/// and ensure consistent pagination behavior across all components.
class PaginatrixPaginationConstants {
  PaginatrixPaginationConstants._(); // Private constructor to prevent instantiation

  /// Maximum safe 32-bit signed integer value (2^31 - 1)
  ///
  /// This constant represents the maximum value that can be safely used for
  /// offset-based pagination without risking integer overflow in calculations.
  ///
  /// **Why this value:**
  /// - 32-bit signed integers have a range of -2^31 to 2^31 - 1
  /// - Maximum positive value is 2^31 - 1 = 2,147,483,647
  /// - Used to validate offset calculations before creating pagination parameters
  ///
  /// **Usage:**
  /// - Validates offset values in `_createOffsetBasedParams()` to prevent overflow
  /// - Used in `_createPaginationParamsFromMeta()` to check offset calculations
  ///
  /// **See Also:**
  /// - `_createOffsetBasedParams()` - Uses this for offset validation
  /// - `_createPaginationParamsFromMeta()` - Validates offset calculations
  static const int maxOffsetValue = 2147483647;
}
