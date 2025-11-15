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
}

