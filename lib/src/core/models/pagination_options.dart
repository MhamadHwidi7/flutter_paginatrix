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
  }) = _PaginationOptions;

  factory PaginationOptions.fromJson(Map<String, dynamic> json) =>
      _$PaginationOptionsFromJson(json);

  /// Default pagination options
  static const PaginationOptions defaultOptions = PaginationOptions();
}
