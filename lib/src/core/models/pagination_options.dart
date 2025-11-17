import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_options.freezed.dart';
part 'pagination_options.g.dart';

/// Constants for pagination default values
class PaginationDefaults {
  /// Default page size value
  static const int defaultPageSize = 20;

  /// Maximum page size value
  static const int maxPageSize = 100;

  /// Default prefetch threshold (number of items from end to trigger load)
  static const int defaultPrefetchThreshold = 3;

  /// Default prefetch threshold in pixels
  static const double defaultPrefetchThresholdPixels = 300;

  /// Maximum number of retry attempts
  static const int maxRetries = 5;

  /// Exponential backoff base (2^retryCount)
  static const int exponentialBackoffBase = 2;

  /// Default request timeout in seconds
  static const int defaultRequestTimeoutSeconds = 30;

  /// Default retry reset timeout in seconds
  static const int defaultRetryResetTimeoutSeconds = 60;

  /// Default refresh debounce duration in milliseconds
  static const int defaultRefreshDebounceMs = 300;

  /// Default search debounce duration in milliseconds
  static const int defaultSearchDebounceMs = 400;

  /// Default initial backoff duration in milliseconds
  static const int defaultInitialBackoffMs = 500;
}

/// Main configuration for pagination
@freezed
class PaginationOptions with _$PaginationOptions {
  const factory PaginationOptions({
    /// Default page size
    @Default(PaginationDefaults.defaultPageSize) int defaultPageSize,

    /// Maximum page size
    @Default(PaginationDefaults.maxPageSize) int maxPageSize,

    /// Request timeout
    @Default(Duration(seconds: PaginationDefaults.defaultRequestTimeoutSeconds))
    Duration requestTimeout,

    /// Whether to enable debug logging
    @Default(false) bool enableDebugLogging,

    /// Default prefetch threshold (number of items from end to trigger load)
    @Default(PaginationDefaults.defaultPrefetchThreshold)
    int defaultPrefetchThreshold,

    /// Default prefetch threshold in pixels (if threshold is not set)
    @Default(PaginationDefaults.defaultPrefetchThresholdPixels)
    double defaultPrefetchThresholdPixels,

    /// Maximum number of retry attempts
    @Default(PaginationDefaults.maxRetries) int maxRetries,

    /// Initial backoff duration for retry attempts
    @Default(Duration(milliseconds: PaginationDefaults.defaultInitialBackoffMs))
    Duration initialBackoff,

    /// Retry reset timeout (resets retry count after this duration)
    @Default(
        Duration(seconds: PaginationDefaults.defaultRetryResetTimeoutSeconds))
    Duration retryResetTimeout,

    /// Debounce duration for refresh calls to prevent rapid successive refreshes
    @Default(
        Duration(milliseconds: PaginationDefaults.defaultRefreshDebounceMs))
    Duration refreshDebounceDuration,

    /// Debounce duration for search term updates to prevent excessive API calls
    /// while user is typing
    @Default(Duration(milliseconds: PaginationDefaults.defaultSearchDebounceMs))
    Duration searchDebounceDuration,
  }) = _PaginationOptions;

  factory PaginationOptions.fromJson(Map<String, dynamic> json) =>
      _$PaginationOptionsFromJson(json);

  /// Default pagination options
  static const PaginationOptions defaultOptions = PaginationOptions();
}
