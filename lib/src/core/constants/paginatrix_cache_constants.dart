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


