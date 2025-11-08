import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('PaginationError', () {
    group('network error', () {
      test('should create network error with message', () {
        const error = PaginationError.network(message: 'Connection failed');

        expect(error.message, equals('Connection failed'));
        error.when(
          network: (message, statusCode, originalError) {
            expect(statusCode, isNull);
            expect(originalError, isNull);
          },
          parse: (_, __, ___) => fail('Should be network error'),
          cancelled: (_) => fail('Should be network error'),
          rateLimited: (_, __) => fail('Should be network error'),
          circuitBreaker: (_, __) => fail('Should be network error'),
          unknown: (_, __) => fail('Should be network error'),
        );
      });

      test('should create network error with status code', () {
        const error = PaginationError.network(
          message: 'Not found',
          statusCode: 404,
        );

        error.when(
          network: (message, statusCode, originalError) {
            expect(statusCode, equals(404));
          },
          parse: (_, __, ___) => fail('Should be network error'),
          cancelled: (_) => fail('Should be network error'),
          rateLimited: (_, __) => fail('Should be network error'),
          circuitBreaker: (_, __) => fail('Should be network error'),
          unknown: (_, __) => fail('Should be network error'),
        );
      });

      test('should be retryable', () {
        const error = PaginationError.network(message: 'Network error');
        expect(error.isRetryable, isTrue);
      });
    });

    group('parse error', () {
      test('should create parse error with message', () {
        const error = PaginationError.parse(
          message: 'Invalid JSON format',
          expectedFormat: 'JSON object',
          actualData: 'null',
        );

        expect(error.message, equals('Invalid JSON format'));
        error.when(
          network: (_, __, ___) => fail('Should be parse error'),
          parse: (message, expectedFormat, actualData) {
            expect(expectedFormat, equals('JSON object'));
            expect(actualData, equals('null'));
          },
          cancelled: (_) => fail('Should be parse error'),
          rateLimited: (_, __) => fail('Should be parse error'),
          circuitBreaker: (_, __) => fail('Should be parse error'),
          unknown: (_, __) => fail('Should be parse error'),
        );
      });

      test('should not be retryable', () {
        const error = PaginationError.parse(message: 'Parse error');
        expect(error.isRetryable, isFalse);
      });
    });

    group('cancelled error', () {
      test('should create cancelled error', () {
        const error = PaginationError.cancelled(
          message: 'Request was cancelled',
        );

        expect(error.message, equals('Request was cancelled'));
      });

      test('should not be retryable', () {
        const error = PaginationError.cancelled(
          message: 'Cancelled',
        );
        expect(error.isRetryable, isFalse);
      });
    });

    group('rate limited error', () {
      test('should create rate limited error', () {
        const error = PaginationError.rateLimited(
          message: 'Too many requests',
          retryAfter: Duration(seconds: 60),
        );

        expect(error.message, equals('Too many requests'));
        error.when(
          network: (_, __, ___) => fail('Should be rate limited error'),
          parse: (_, __, ___) => fail('Should be rate limited error'),
          cancelled: (_) => fail('Should be rate limited error'),
          rateLimited: (message, retryAfter) {
            expect(retryAfter, equals(const Duration(seconds: 60)));
          },
          circuitBreaker: (_, __) => fail('Should be rate limited error'),
          unknown: (_, __) => fail('Should be rate limited error'),
        );
      });

      test('should be retryable', () {
        const error = PaginationError.rateLimited(
          message: 'Rate limited',
        );
        expect(error.isRetryable, isTrue);
      });
    });

    group('circuit breaker error', () {
      test('should create circuit breaker error', () {
        const error = PaginationError.circuitBreaker(
          message: 'Service unavailable',
          retryAfter: Duration(seconds: 30),
        );

        expect(error.message, equals('Service unavailable'));
        error.when(
          network: (_, __, ___) => fail('Should be circuit breaker error'),
          parse: (_, __, ___) => fail('Should be circuit breaker error'),
          cancelled: (_) => fail('Should be circuit breaker error'),
          rateLimited: (_, __) => fail('Should be circuit breaker error'),
          circuitBreaker: (message, retryAfter) {
            expect(retryAfter, equals(const Duration(seconds: 30)));
          },
          unknown: (_, __) => fail('Should be circuit breaker error'),
        );
      });

      test('should be retryable', () {
        const error = PaginationError.circuitBreaker(
          message: 'Circuit breaker',
        );
        expect(error.isRetryable, isTrue);
      });
    });

    group('unknown error', () {
      test('should create unknown error', () {
        const error = PaginationError.unknown(
          message: 'Unexpected error',
          originalError: 'Exception: Something went wrong',
        );

        expect(error.message, equals('Unexpected error'));
        error.when(
          network: (_, __, ___) => fail('Should be unknown error'),
          parse: (_, __, ___) => fail('Should be unknown error'),
          cancelled: (_) => fail('Should be unknown error'),
          rateLimited: (_, __) => fail('Should be unknown error'),
          circuitBreaker: (_, __) => fail('Should be unknown error'),
          unknown: (message, originalError) {
            expect(originalError, equals('Exception: Something went wrong'));
          },
        );
      });

      test('should not be retryable', () {
        const error = PaginationError.unknown(message: 'Unknown error');
        expect(error.isRetryable, isFalse);
      });
    });

    group('equality', () {
      test('network errors with same values should be equal', () {
        const error1 = PaginationError.network(
          message: 'Error',
          statusCode: 500,
        );
        const error2 = PaginationError.network(
          message: 'Error',
          statusCode: 500,
        );

        expect(error1, equals(error2));
      });

      test('network errors with different values should not be equal', () {
        const error1 = PaginationError.network(
          message: 'Error 1',
          statusCode: 500,
        );
        const error2 = PaginationError.network(
          message: 'Error 2',
          statusCode: 500,
        );

        expect(error1, isNot(equals(error2)));
      });
    });
  });
}

