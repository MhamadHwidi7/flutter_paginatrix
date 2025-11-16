import 'package:flutter/foundation.dart';

/// Standardized logging utility for Flutter Paginatrix examples
///
/// Provides consistent, professional logging format across all examples.
/// Logs are only printed when debug mode is enabled.
class PaginatrixLogger {
  PaginatrixLogger._();

  /// Whether logging is enabled
  static bool get isEnabled => kDebugMode;

  /// Logs an API call with parameters
  static void logApiCall({
    required String endpoint,
    String? method,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) {
    if (!isEnabled) return;

    final methodStr = method ?? 'GET';
    debugPrint('┌─ Paginatrix API Call ──────────────────────────────────────');
    debugPrint('│ Method: $methodStr');
    debugPrint('│ Endpoint: $endpoint');

    if (queryParams != null && queryParams.isNotEmpty) {
      debugPrint('│ Query Parameters:');
      queryParams.forEach((key, value) {
        debugPrint('│   • $key: $value');
      });
    }

    if (body != null && body.isNotEmpty) {
      debugPrint('│ Body:');
      body.forEach((key, value) {
        debugPrint('│   • $key: $value');
      });
    }

    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs API response
  static void logApiResponse({
    required int statusCode,
    required Duration duration,
    int? itemCount,
    Map<String, dynamic>? metadata,
  }) {
    if (!isEnabled) return;

    debugPrint(
        '┌─ Paginatrix API Response ───────────────────────────────────');
    debugPrint('│ Status: $statusCode');
    debugPrint('│ Duration: ${duration.inMilliseconds}ms');

    if (itemCount != null) {
      debugPrint('│ Items: $itemCount');
    }

    if (metadata != null && metadata.isNotEmpty) {
      debugPrint('│ Metadata:');
      metadata.forEach((key, value) {
        debugPrint('│   • $key: $value');
      });
    }

    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs pagination operation
  static void logPaginationOperation({
    required String operation,
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
  }) {
    if (!isEnabled) return;

    debugPrint(
        '┌─ Paginatrix Operation ──────────────────────────────────────');
    debugPrint('│ Operation: $operation');

    if (page != null) {
      debugPrint('│ Page: $page');
    }
    if (perPage != null) {
      debugPrint('│ Per Page: $perPage');
    }
    if (offset != null) {
      debugPrint('│ Offset: $offset');
    }
    if (limit != null) {
      debugPrint('│ Limit: $limit');
    }
    if (cursor != null) {
      debugPrint('│ Cursor: $cursor');
    }

    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs query criteria (search, filters, sorting)
  static void logQueryCriteria({
    String? searchTerm,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool? sortDesc,
  }) {
    if (!isEnabled) return;

    final hasSearch = searchTerm != null && searchTerm.isNotEmpty;
    final hasFilters = filters != null && filters.isNotEmpty;
    final hasSorting = sortBy != null;

    if (!hasSearch && !hasFilters && !hasSorting) {
      return; // Don't log if no query criteria
    }

    debugPrint('┌─ Paginatrix Query Criteria ────────────────────────────────');

    if (hasSearch) {
      debugPrint('│ Search: "$searchTerm"');
    }

    if (hasFilters) {
      debugPrint('│ Filters:');
      filters!.forEach((key, value) {
        debugPrint('│   • $key: $value');
      });
    }

    if (hasSorting) {
      debugPrint('│ Sort: $sortBy (${sortDesc == true ? 'desc' : 'asc'})');
    }

    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs state transition
  static void logStateTransition({
    required String from,
    required String to,
    int? itemCount,
  }) {
    if (!isEnabled) return;

    debugPrint(
        '┌─ Paginatrix State Transition ───────────────────────────────');
    debugPrint('│ From: $from');
    debugPrint('│ To: $to');
    if (itemCount != null) {
      debugPrint('│ Items: $itemCount');
    }
    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs error
  static void logError({
    required String message,
    String? type,
    int? statusCode,
    Object? error,
  }) {
    if (!isEnabled) return;

    debugPrint(
        '┌─ Paginatrix Error ──────────────────────────────────────────');
    if (type != null) {
      debugPrint('│ Type: $type');
    }
    debugPrint('│ Message: $message');
    if (statusCode != null) {
      debugPrint('│ Status Code: $statusCode');
    }
    if (error != null) {
      debugPrint('│ Error: $error');
    }
    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }

  /// Logs a simple info message
  static void logInfo(String message) {
    if (!isEnabled) return;
    debugPrint('Paginatrix: $message');
  }

  /// Logs a warning message
  static void logWarning(String message) {
    if (!isEnabled) return;
    debugPrint('Paginatrix Warning: $message');
  }

  /// Logs performance metrics
  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? additionalMetrics,
  }) {
    if (!isEnabled) return;

    debugPrint(
        '┌─ Paginatrix Performance ────────────────────────────────────');
    debugPrint('│ Operation: $operation');
    debugPrint('│ Duration: ${duration.inMilliseconds}ms');

    if (additionalMetrics != null && additionalMetrics.isNotEmpty) {
      debugPrint('│ Metrics:');
      additionalMetrics.forEach((key, value) {
        debugPrint('│   • $key: $value');
      });
    }

    debugPrint(
        '└─────────────────────────────────────────────────────────────');
  }
}
