import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/contracts/meta_parser.dart';
import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../../core/entities/request_context.dart';
import '../../core/models/pagination_options.dart';
import '../../core/typedefs/typedefs.dart';
import '../../core/utils/generation_guard.dart';

/// Internal enum to distinguish between different load types
enum _LoadType {
  first,
  next,
  refresh,
}

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

  /// Checks if scroll position is near the end and triggers load if needed
  ///
  /// This method encapsulates the scroll detection logic, moving it from UI
  /// widgets to the controller for better separation of concerns and performance.
  ///
  /// [metrics] - Scroll metrics from ScrollNotification
  /// [prefetchThreshold] - Optional threshold override (number of items from end)
  /// [reverse] - Whether scrolling is reversed (default: false)
  ///
  /// Returns true if load was triggered, false otherwise
  bool checkAndLoadIfNearEnd({
    required ScrollMetrics metrics,
    int? prefetchThreshold,
    bool reverse = false,
  }) {
    // Don't trigger if already loading or no more items available
    if (!canLoadMore || isLoading) return false;

    // Only check if we have valid scroll dimensions
    if (!metrics.hasContentDimensions || metrics.maxScrollExtent == 0) {
      return false;
    }

    // Use provided threshold or default from options
    final threshold = prefetchThreshold ?? _options.defaultPrefetchThreshold;
    final thresholdPixels = threshold * 100.0;

    // Calculate remaining scroll distance
    final remainingScroll = metrics.maxScrollExtent - metrics.pixels;

    // Check if we're near the end (within threshold pixels from bottom)
    // For reverse scrolling, check distance from top
    final isNearEnd = reverse
        ? metrics.pixels <= metrics.minScrollExtent + thresholdPixels
        : remainingScroll <= thresholdPixels;

    if (isNearEnd) {
      loadNextPage();
      return true;
    }

    return false;
  }

  /// Loads the first page of data (resets the list and starts fresh)
  ///
  /// Calls the loader function with page 1 and replaces all existing items
  /// with the new data. This is used for initial load or when resetting the list.
  Future<void> loadFirstPage() async {
    await _loadData(_LoadType.first);
  }

  /// Loads the next page of data (appends new data to existing list)
  ///
  /// Calls the same loader function with the next page number and appends
  /// the returned data to the existing list. This is used for pagination.
  Future<void> loadNextPage() async {
    await _loadData(_LoadType.next);
  }

  /// Refreshes the current data (reloads first page and replaces all items)
  ///
  /// Calls the loader function with page 1 to refresh the data,
  /// replacing all existing items with fresh data from the server.
  Future<void> refresh() async {
    await _loadData(_LoadType.refresh);
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

  /// Unified data loading method that handles all load types
  ///
  /// This method consolidates the common logic for loading data,
  /// reducing code duplication across loadFirstPage, loadNextPage, and refresh.
  Future<void> _loadData(_LoadType type) async {
    // 1. Guard Checks
    if (_currentState.isLoading) return;
    if (type == _LoadType.next && !canLoadMore) return;

    // 2. Request Setup
    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
      isAppend: type == _LoadType.next,
      isRefresh: type == _LoadType.refresh,
    );

    _currentCancelToken = cancelToken;

    // 3. Set Initial State
    switch (type) {
      case _LoadType.first:
        _updateState(PaginationState.loading(
          requestContext: requestContext,
        ));
        break;

      case _LoadType.next:
        _updateState(PaginationState.appending(
          requestContext: requestContext,
          currentItems: _currentState.items,
          currentMeta: _currentState.meta!,
        ));
        break;

      case _LoadType.refresh:
        _updateState(PaginationState.refreshing(
          requestContext: requestContext,
          currentItems: _currentState.items,
          currentMeta: _currentState.meta!,
        ));
        break;
    }

    // 4. Execution Block
    try {
      // Determine page to fetch
      final page = (type == _LoadType.next) ? _getNextPageNumber() : 1;
      final data = await _loader(
        page: page,
        perPage: _options.defaultPageSize,
        cancelToken: cancelToken,
      );

      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final items = _metaParser.extractItems(data);
      final decodedItems = items.map(_itemDecoder).toList();
      final meta = _metaParser.parseMeta(data);

      // Determine final list of items (append vs. replace)
      final newItems = (type == _LoadType.next)
          ? [..._currentState.items, ...decodedItems]
          : decodedItems;

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

      // 5. Set Error State
      switch (type) {
        case _LoadType.first:
          _updateState(PaginationState.error(
            error: error,
            requestContext: requestContext,
          ));
          break;

        case _LoadType.next:
          _updateState(PaginationState.appendError(
            appendError: error,
            requestContext: requestContext,
            currentItems: _currentState.items,
            currentMeta: _currentState.meta!,
          ));
          break;

        case _LoadType.refresh:
          _updateState(PaginationState.error(
            error: error,
            requestContext: requestContext,
            previousItems: _currentState.items,
            previousMeta: _currentState.meta,
          ));
          break;
      }
    } finally {
      _currentCancelToken = null;
    }
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
