import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/contracts/meta_parser.dart';
import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../../core/entities/request_context.dart';
import '../../core/models/pagination_options.dart';
import '../../core/typedefs/typedefs.dart';
import '../../core/utils/generation_guard.dart';

/// Controller for managing paginated data
///
/// This controller uses a single loader function that handles both initial load
/// and pagination. The loader function is called with the appropriate page number,
/// and the returned data is either set (first page) or appended (next page) to the list.
class PaginatedController<T> {
  /// Creates a new PaginatedController
  ///
  /// [loader] - Single function that loads a page of data. Called for both
  ///            initial load (page 1) and pagination (page 2, 3, etc.).
  ///            The returned data will be added to the list.
  /// [itemDecoder] - Function to decode individual items from raw data
  /// [metaParser] - Parser to extract pagination metadata
  /// [options] - Optional pagination options
  PaginatedController({
    required LoaderFn<T> loader,
    required ItemDecoder<T> itemDecoder,
    required MetaParser metaParser,
    PaginationOptions? options,
  })  : _loader = loader,
        _itemDecoder = itemDecoder,
        _metaParser = metaParser,
        _options = options ?? PaginationOptions.defaultOptions;
  final LoaderFn<T> _loader;
  final ItemDecoder<T> _itemDecoder;
  final MetaParser _metaParser;
  final PaginationOptions _options;

  final StreamController<PaginationState<T>> _stateController =
      StreamController.broadcast();
  final GenerationGuard _generationGuard = GenerationGuard();

  PaginationState<T> _currentState = PaginationState.initial();
  CancelToken? _currentCancelToken;

  /// Stream of pagination states
  Stream<PaginationState<T>> get stream => _stateController.stream;

  /// Current pagination state
  PaginationState<T> get state => _currentState;

  /// Whether more data can be loaded
  bool get canLoadMore => _currentState.canLoadMore;

  /// Whether the controller is currently loading
  bool get isLoading => _currentState.isLoading;

  /// Whether the controller has data
  bool get hasData => _currentState.hasData;

  /// Whether the controller has an error
  bool get hasError => _currentState.hasError;

  /// Loads the first page of data (resets the list and starts fresh)
  ///
  /// Calls the loader function with page 1 and replaces all existing items
  /// with the new data. This is used for initial load or when resetting the list.
  Future<void> loadFirstPage() async {
    if (_currentState.isLoading) return;

    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
    );

    _currentCancelToken = cancelToken;

    _updateState(PaginationState.loading(
      requestContext: requestContext,
    ));

    try {
      // Call the single loader function with page 1
      final data = await _loader(
        page: 1,
        perPage: _options.defaultPageSize,
        cancelToken: cancelToken,
      );

      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final items = _metaParser.extractItems(data);
      final decodedItems = items.map(_itemDecoder).toList();
      final meta = _metaParser.parseMeta(data);

      // Replace all items with the new data (first page)
      final newState = PaginationState.success(
        items: decodedItems,
        meta: meta,
        requestContext: requestContext,
      );

      _updateState(newState);
    } catch (e) {
      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final error = _convertToPaginationError(e);
      _updateState(PaginationState.error(
        error: error,
        requestContext: requestContext,
      ));
    } finally {
      _currentCancelToken = null;
    }
  }

  /// Loads the next page of data (appends new data to existing list)
  ///
  /// Calls the same loader function with the next page number and appends
  /// the returned data to the existing list. This is used for pagination.
  Future<void> loadNextPage() async {
    if (!canLoadMore || isLoading) return;

    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
      isAppend: true,
    );

    _currentCancelToken = cancelToken;

    _updateState(PaginationState.appending(
      requestContext: requestContext,
      currentItems: _currentState.items,
      currentMeta: _currentState.meta!,
    ));

    try {
      // Call the same loader function with the next page number
      final nextPage = _getNextPageNumber();
      final data = await _loader(
        page: nextPage,
        perPage: _options.defaultPageSize,
        cancelToken: cancelToken,
      );

      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final items = _metaParser.extractItems(data);
      final decodedItems = items.map(_itemDecoder).toList();
      final meta = _metaParser.parseMeta(data);

      // Append new items to the existing list
      final newItems = [..._currentState.items, ...decodedItems];
      final newState = PaginationState.success(
        items: newItems,
        meta: meta,
        requestContext: requestContext,
      );

      _updateState(newState);
    } catch (e) {
      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final error = _convertToPaginationError(e);
      _updateState(PaginationState.appendError(
        appendError: error,
        requestContext: requestContext,
        currentItems: _currentState.items,
        currentMeta: _currentState.meta!,
      ));
    } finally {
      _currentCancelToken = null;
    }
  }

  /// Refreshes the current data (reloads first page and replaces all items)
  ///
  /// Calls the loader function with page 1 to refresh the data,
  /// replacing all existing items with fresh data from the server.
  Future<void> refresh() async {
    if (_currentState.isLoading) return;

    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
      isRefresh: true,
    );

    _currentCancelToken = cancelToken;

    _updateState(PaginationState.refreshing(
      requestContext: requestContext,
      currentItems: _currentState.items,
      currentMeta: _currentState.meta!,
    ));

    try {
      // Call the loader function with page 1 to refresh
      final data = await _loader(
        page: 1,
        perPage: _options.defaultPageSize,
        cancelToken: cancelToken,
      );

      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final items = _metaParser.extractItems(data);
      final decodedItems = items.map(_itemDecoder).toList();
      final meta = _metaParser.parseMeta(data);

      // Replace all items with refreshed data
      final newState = PaginationState.success(
        items: decodedItems,
        meta: meta,
        requestContext: requestContext,
      );

      _updateState(newState);
    } catch (e) {
      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final error = _convertToPaginationError(e);
      _updateState(PaginationState.error(
        error: error,
        requestContext: requestContext,
        previousItems: _currentState.items,
        previousMeta: _currentState.meta,
      ));
    } finally {
      _currentCancelToken = null;
    }
  }

  /// Retries the last failed operation
  Future<void> retry() async {
    if (_currentState.hasError) {
      await loadFirstPage();
    } else if (_currentState.hasAppendError) {
      await loadNextPage();
    }
  }

  /// Cancels the current request
  void cancel() {
    _currentCancelToken?.cancel();
    _currentCancelToken = null;
  }

  /// Clears all data and resets to initial state
  void clear() {
    cancel();
    _updateState(PaginationState.initial());
  }

  /// Disposes the controller
  void dispose() {
    cancel();
    _stateController.close();
  }

  void _updateState(PaginationState<T> newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  int _getNextPageNumber() {
    final meta = _currentState.meta;
    if (meta?.page != null) {
      return meta!.page! + 1;
    }
    return 2; // Default fallback
  }

  PaginationError _convertToPaginationError(dynamic error) {
    if (error is PaginationError) return error;
    if (error is DioException) {
      return PaginationError.network(
        message: error.message ?? 'Network error',
        statusCode: error.response?.statusCode,
        originalError: error.toString(),
      );
    }
    return PaginationError.unknown(
      message: error.toString(),
      originalError: error.toString(),
    );
  }
}
