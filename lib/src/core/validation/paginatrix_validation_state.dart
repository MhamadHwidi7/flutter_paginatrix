import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';

part 'paginatrix_validation_state.freezed.dart';

/// Validation state for pagination operations
///
/// Represents the result of validation operations with either
/// a valid result or validation errors.
@freezed
class PaginatrixValidationState with _$PaginatrixValidationState {
  /// Initial state - no validation performed yet
  const factory PaginatrixValidationState.initial() = _Initial;

  /// Validation is in progress
  const factory PaginatrixValidationState.validating() = _Validating;

  /// Validation passed successfully
  const factory PaginatrixValidationState.valid({
    /// Validated metadata (if applicable)
    PageMeta? meta,

    /// Validated page number (if applicable)
    int? pageNumber,

    /// Validated cursor (if applicable)
    String? cursor,

    /// Validated offset (if applicable)
    int? offset,

    /// Validated limit (if applicable)
    int? limit,
  }) = _Valid;

  /// Validation failed with errors
  const factory PaginatrixValidationState.invalid({
    /// List of validation error messages
    required List<String> errors,

    /// Validation error code for programmatic handling
    String? errorCode,

    /// Additional context about the validation failure
    Map<String, dynamic>? context,
  }) = _Invalid;
}


