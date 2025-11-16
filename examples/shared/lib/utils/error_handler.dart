import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Shared error handling utility for Dio-based repositories
///
/// This utility provides consistent error handling across all examples,
/// converting DioException and other errors into PaginationError instances.
///
/// **Best Practices:**
/// - Centralizes error handling logic
/// - Ensures consistent error messages
/// - Reduces code duplication
/// - Makes error handling testable
class RepositoryErrorHandler {
  RepositoryErrorHandler._(); // Private constructor

  /// Handles DioException and converts it to PaginationError
  ///
  /// [exception] - The DioException to handle
  /// [context] - Optional context string for debug logging (e.g., "API Call", "Details Fetch")
  ///
  /// Returns a PaginationError appropriate for the exception type
  static PaginationError handleDioException(
    DioException exception, {
    String? context,
  }) {
    final contextPrefix = context != null ? '[$context] ' : '';
    debugPrint('   ❌ ${contextPrefix}API Error: ${exception.type} - ${exception.message}');

    // Handle cancellation
    if (exception.type == DioExceptionType.cancel) {
      debugPrint('   🚫 ${contextPrefix}Request was cancelled');
      return const PaginationError.cancelled(
        message: 'Request was cancelled',
      );
    }

    // Handle timeouts
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const PaginationError.network(
        message: 'Connection timeout. Please check your internet connection.',
        statusCode: null,
      );
    }

    // Handle other network errors
    return PaginationError.network(
      message: exception.message ?? 'Network error occurred',
      statusCode: exception.response?.statusCode,
      originalError: exception.toString(),
    );
  }

  /// Handles generic exceptions and converts them to PaginationError
  ///
  /// [error] - The error to handle
  /// [context] - Optional context string for debug logging
  ///
  /// Returns a PaginationError appropriate for the error
  static PaginationError handleGenericError(
    Object error, {
    String? context,
  }) {
    final contextPrefix = context != null ? '[$context] ' : '';
    debugPrint('   ❌ ${contextPrefix}Unexpected error: $error');

    // If it's already a PaginationError, rethrow it
    if (error is PaginationError) {
      return error;
    }

    // Convert to unknown error
    return PaginationError.unknown(
      message: 'An unexpected error occurred: ${error.toString()}',
      originalError: error.toString(),
    );
  }

  /// Wraps a repository method with consistent error handling
  ///
  /// This is a convenience method that wraps async repository operations
  /// with try-catch blocks that handle both DioException and generic errors.
  ///
  /// **Example:**
  /// ```dart
  /// return RepositoryErrorHandler.wrapErrorHandling(
  ///   () async {
  ///     final response = await _dio.get('/endpoint');
  ///     return processResponse(response);
  ///   },
  ///   context: 'Load Data',
  /// );
  /// ```
  static Future<T> wrapErrorHandling<T>(
    Future<T> Function() operation, {
    String? context,
  }) async {
    try {
      return await operation();
    } on DioException catch (e) {
      throw handleDioException(e, context: context);
    } catch (e) {
      throw handleGenericError(e, context: context);
    }
  }
}

