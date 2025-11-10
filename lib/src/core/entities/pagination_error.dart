import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_error.freezed.dart';

/// Represents pagination errors
@freezed
class PaginationError with _$PaginationError {
  /// Network error (connection, timeout, etc.)
  const factory PaginationError.network({
    required String message,
    int? statusCode,
    String? originalError,
  }) = _NetworkError;

  /// Parse error (invalid response format, missing keys, etc.)
  const factory PaginationError.parse({
    required String message,
    String? expectedFormat,
    String? actualData,
  }) = _ParseError;

  /// Cancellation error (request was cancelled)
  const factory PaginationError.cancelled({
    required String message,
  }) = _CancelledError;

  /// Rate limit error (too many requests)
  const factory PaginationError.rateLimited({
    required String message,
    Duration? retryAfter,
  }) = _RateLimitedError;

  /// Circuit breaker error (service unavailable)
  const factory PaginationError.circuitBreaker({
    required String message,
    Duration? retryAfter,
  }) = _CircuitBreakerError;

  /// Unknown error
  const factory PaginationError.unknown({
    required String message,
    String? originalError,
  }) = _UnknownError;
}

extension PaginationErrorExtension on PaginationError {
  /// Whether this error is retryable
  bool get isRetryable {
    return when(
      network: (_, __, ___) => true,
      parse: (_, __, ___) => false,
      cancelled: (_) => false,
      rateLimited: (_, __) => true,
      circuitBreaker: (_, __) => true,
      unknown: (_, __) => false,
    );
  }

  /// Whether this error should be shown to the user
  bool get isUserVisible {
    return when(
      network: (_, __, ___) => true,
      parse: (_, __, ___) => false,
      cancelled: (_) => false,
      rateLimited: (_, __) => true,
      circuitBreaker: (_, __) => true,
      unknown: (_, __) => true,
    );
  }

  /// User-friendly error message
  String get userMessage {
    return when(
      network: (message, _, __) => message,
      parse: (message, _, __) => 'Invalid response format',
      cancelled: (message) => message,
      rateLimited: (message, _) => message,
      circuitBreaker: (message, _) => message,
      unknown: (message, _) => message,
    );
  }
}
