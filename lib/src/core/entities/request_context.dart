import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';

part 'request_context.freezed.dart';

/// Context for pagination requests
@freezed
class RequestContext with _$RequestContext {
  const factory RequestContext({
    /// Unique request ID for tracking
    required String requestId,

    /// Generation number to prevent stale responses
    required int generation,

    /// Cancel token for request cancellation
    required CancelToken cancelToken,

    /// Request timestamp
    required DateTime timestamp,

    /// Whether this is a refresh request
    @Default(false) bool isRefresh,

    /// Whether this is an append request
    @Default(false) bool isAppend,

    /// Additional metadata
    @Default({}) Map<String, dynamic> metadata,
  }) = _RequestContext;

  /// Creates a new request context with a unique ID and generation
  factory RequestContext.create({
    required int generation,
    required CancelToken cancelToken,
    bool isRefresh = false,
    bool isAppend = false,
    Map<String, dynamic> metadata = const {},
  }) {
    return RequestContext(
      requestId: _generateRequestId(),
      generation: generation,
      cancelToken: cancelToken,
      timestamp: DateTime.now(),
      isRefresh: isRefresh,
      isAppend: isAppend,
      metadata: metadata,
    );
  }
}

/// Generates a unique request ID
String _generateRequestId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = (timestamp % 100000).toString().padLeft(5, '0');
  return 'req_${timestamp}_$random';
}
