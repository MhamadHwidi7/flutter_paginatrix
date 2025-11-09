import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_options.freezed.dart';
part 'pagination_options.g.dart';

/// Main configuration for pagination
@freezed
class PaginationOptions with _$PaginationOptions {
  const factory PaginationOptions({
    /// Default page size
    @Default(20) int defaultPageSize,

    /// Maximum page size
    @Default(100) int maxPageSize,

    /// Request timeout
    @Default(Duration(seconds: 30)) Duration requestTimeout,

    /// Whether to enable debug logging
    @Default(false) bool enableDebugLogging,

    /// Default prefetch threshold (number of items from end to trigger load)
    @Default(3) int defaultPrefetchThreshold,

    /// Default prefetch threshold in pixels (if threshold is not set)
    @Default(300.0) double defaultPrefetchThresholdPixels,

    /// Maximum number of retry attempts
    @Default(5) int maxRetries,

    /// Initial backoff duration for retry attempts
    @Default(Duration(milliseconds: 500)) Duration initialBackoff,

    /// Retry reset timeout (resets retry count after this duration)
    @Default(Duration(seconds: 60)) Duration retryResetTimeout,

    /// Debounce duration for refresh calls to prevent rapid successive refreshes
    @Default(Duration(milliseconds: 300)) Duration refreshDebounceDuration,
  }) = _PaginationOptions;

  factory PaginationOptions.fromJson(Map<String, dynamic> json) =>
      _$PaginationOptionsFromJson(json);

  /// Default pagination options
  static const PaginationOptions defaultOptions = PaginationOptions();
}
