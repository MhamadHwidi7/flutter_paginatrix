import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_status.freezed.dart';

/// Represents the current status of pagination
@freezed
sealed class PaginationStatus with _$PaginationStatus {
  /// Initial state - no data loaded yet
  const factory PaginationStatus.initial() = _Initial;

  /// Loading first page
  const factory PaginationStatus.loading() = _Loading;

  /// Successfully loaded data
  const factory PaginationStatus.success() = _Success;

  /// No data available (empty result)
  const factory PaginationStatus.empty() = _Empty;

  /// Refreshing current data
  const factory PaginationStatus.refreshing() = _Refreshing;

  /// Appending more data
  const factory PaginationStatus.appending() = _Appending;

  /// Error occurred during first load
  const factory PaginationStatus.error() = _Error;

  /// Error occurred during append (non-blocking)
  const factory PaginationStatus.appendError() = _AppendError;
}
