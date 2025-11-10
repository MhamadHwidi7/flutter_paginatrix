import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Test helper: Creates mock paginated data
List<Map<String, dynamic>> createMockData({
  required int totalItems,
  String idKey = 'id',
  String nameKey = 'name',
}) {
  return List.generate(
      totalItems,
      (index) => {
            idKey: index + 1,
            nameKey: 'Item ${index + 1}',
          });
}

/// Test helper: Creates a mock loader function
LoaderFn<T> createMockLoader<T>({
  required List<Map<String, dynamic>> mockData,
  int itemsPerPage = 20,
  Duration delay = Duration.zero,
  bool Function(int page)? shouldFail,
  String Function(int page)? errorMessage,
}) {
  return ({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    if (cancelToken?.isCancelled ?? false) {
      throw const PaginationError.cancelled(
        message: 'Request was cancelled',
      );
    }

    final currentPage = page ?? 1;
    final pageSize = perPage ?? itemsPerPage;

    if (shouldFail != null && shouldFail(currentPage)) {
      throw PaginationError.network(
        message: errorMessage?.call(currentPage) ??
            'Network error on page $currentPage',
      );
    }

    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    final pageItems = mockData.skip(startIndex).take(pageSize).toList();
    final totalPages = (mockData.length / pageSize).ceil();

    return {
      'data': pageItems,
      'meta': {
        'current_page': currentPage,
        'per_page': pageSize,
        'total': mockData.length,
        'last_page': totalPages,
        'has_more': currentPage < totalPages,
      },
    };
  };
}

/// Test helper: Creates a slow loader for cancellation tests
LoaderFn<T> createSlowLoader<T>({
  required List<Map<String, dynamic>> mockData,
  Duration delay = const Duration(seconds: 5),
  int itemsPerPage = 20,
}) {
  return createMockLoader<T>(
    mockData: mockData,
    itemsPerPage: itemsPerPage,
    delay: delay,
  );
}

/// Test helper: Creates a loader that always fails
LoaderFn<T> createFailingLoader<T>({
  String message = 'Network error',
  PaginationError Function()? errorFactory,
}) {
  return ({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    if (errorFactory != null) {
      throw errorFactory();
    }
    throw PaginationError.network(message: message);
  };
}

/// Test helper: Creates a controller with mock data
PaginatrixCubit<T> createTestController<T>({
  required List<Map<String, dynamic>> mockData,
  ItemDecoder<T>? itemDecoder,
  MetaParser? metaParser,
  int itemsPerPage = 20,
  Duration loaderDelay = Duration.zero,
  PaginationOptions? options,
}) {
  return PaginatrixCubit<T>(
    loader: createMockLoader<T>(
      mockData: mockData,
      itemsPerPage: itemsPerPage,
      delay: loaderDelay,
    ),
    itemDecoder: itemDecoder ?? ((json) => json as T),
    metaParser: metaParser ?? ConfigMetaParser(MetaConfig.nestedMeta),
    options: options,
  );
}

/// Test helper: Creates a controller with zero refresh debounce (for refresh tests)
PaginatrixCubit<T> createTestControllerWithZeroDebounce<T>({
  required List<Map<String, dynamic>> mockData,
  ItemDecoder<T>? itemDecoder,
  MetaParser? metaParser,
  int itemsPerPage = 20,
  Duration loaderDelay = Duration.zero,
}) {
  return createTestController<T>(
    mockData: mockData,
    itemDecoder: itemDecoder,
    metaParser: metaParser,
    itemsPerPage: itemsPerPage,
    loaderDelay: loaderDelay,
    options: const PaginationOptions(refreshDebounceDuration: Duration.zero),
  );
}

/// Test helper: Waits for a specific state condition
Future<void> waitForState<T>(
  PaginatrixCubit<T> controller,
  bool Function(PaginationState<T>) condition, {
  Duration timeout = const Duration(seconds: 5),
  Duration pollInterval = const Duration(milliseconds: 50),
}) async {
  final startTime = DateTime.now();

  while (DateTime.now().difference(startTime) < timeout) {
    if (condition(controller.state)) {
      return;
    }
    await Future.delayed(pollInterval);
  }

  throw TimeoutException(
    'State condition not met within ${timeout.inSeconds} seconds',
    timeout,
  );
}

/// Test helper: Collects all states from stream
Future<List<PaginationState<T>>> collectStates<T>(
  PaginatrixCubit<T> controller,
  Duration duration,
) async {
  final states = <PaginationState<T>>[];
  final subscription = controller.stream.listen(states.add);

  await Future.delayed(duration);
  await subscription.cancel();

  return states;
}
