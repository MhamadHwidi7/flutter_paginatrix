import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/contracts/meta_parser.dart';
import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../../core/entities/request_context.dart';
import '../../core/enums/paginatrix_load_type.dart';
import '../../core/models/pagination_options.dart';
import '../../core/typedefs/typedefs.dart';
import '../../core/utils/generation_guard.dart';

/// Cubit-based controller for managing paginated data
///
/// This is the recommended way to use flutter_paginatrix with flutter_bloc.
/// It provides automatic state management, stream handling, and lifecycle management.
///
/// **Advantages over PaginatedController:**
/// - ✅ No manual StreamController management
/// - ✅ Automatic disposal and cleanup
/// - ✅ Built-in safety checks (no isClosed checks needed)
/// - ✅ Better testability with blocTest
/// - ✅ Consistent with flutter_bloc patterns
///
/// ## Usage
///
/// ```dart
/// final cubit = PaginatedCubit<Pokemon>(
///   loader: repository.loadPokemonPage,
///   itemDecoder: Pokemon.fromJson,
///   metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
/// );
///
/// // In widget:
/// BlocBuilder<PaginatedCubit<Pokemon>, PaginationState<Pokemon>>(
///   bloc: cubit,
///   builder: (context, state) {
///     // Use state directly
///   },
/// )
/// ```
class PaginatedCubit<T> extends Cubit<PaginationState<T>> {
  /// Creates a new PaginatedCubit
  ///
  /// [loader] - Single function that loads a page of data. Called for both
  ///            initial load (page 1) and pagination (page 2, 3, etc.).
  /// [itemDecoder] - Function to decode individual items from raw data
  /// [metaParser] - Parser to extract pagination metadata
  /// [options] - Optional pagination options
  PaginatedCubit({
    required LoaderFn<T> loader,
    required ItemDecoder<T> itemDecoder,
    required MetaParser metaParser,
    PaginationOptions? options,
  })  : _loader = loader,
        _itemDecoder = itemDecoder,
        _metaParser = metaParser,
        _options = options ?? PaginationOptions.defaultOptions,
        super(PaginationState.initial());

  final LoaderFn<T> _loader;
  final ItemDecoder<T> _itemDecoder;
  final MetaParser _metaParser;
  final PaginationOptions _options;
  final GenerationGuard _generationGuard = GenerationGuard();

  CancelToken? _currentCancelToken;
  Timer? _scrollDebounceTimer;

  /// Whether more data can be loaded
  bool get canLoadMore => state.canLoadMore;

  /// Whether the cubit is currently loading
  bool get isLoading => state.isLoading;

  /// Whether the cubit has data
  bool get hasData => state.hasData;

  /// Whether the cubit has an error
  bool get hasError => state.hasError;

  /// Checks if scroll position is near the end and triggers load if needed
  ///
  /// This method uses debouncing to prevent excessive load triggers during
  /// rapid scroll events, improving performance and reducing unnecessary API calls.
  ///
  /// [metrics] - Scroll metrics from ScrollNotification
  /// [prefetchThreshold] - Optional threshold override (number of items from end)
  /// [reverse] - Whether scrolling is reversed (default: false)
  /// [debounceDuration] - Duration to wait before triggering load (default: 100ms)
  ///
  /// Returns true if scroll position is near end, false otherwise
  bool checkAndLoadIfNearEnd({
    required ScrollMetrics metrics,
    int? prefetchThreshold,
    bool reverse = false,
    Duration debounceDuration = const Duration(milliseconds: 100),
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
      // Cancel any pending debounce timer
      _scrollDebounceTimer?.cancel();
      
      // Create new debounce timer
      _scrollDebounceTimer = Timer(debounceDuration, () {
        if (!isClosed && canLoadMore && !isLoading) {
          loadNextPage();
        }
      });
      
      return true;
    }

    return false;
  }

  /// Loads the first page of data (resets the list and starts fresh)
  ///
  /// Calls the loader function with page 1 and replaces all existing items
  /// with the new data. This is used for initial load or when resetting the list.
  Future<void> loadFirstPage() async {
    await _loadData(PaginatrixLoadType.first);
  }

  /// Loads the next page of data (appends new data to existing list)
  ///
  /// Calls the same loader function with the next page number and appends
  /// the returned data to the existing list. This is used for pagination.
  Future<void> loadNextPage() async {
    await _loadData(PaginatrixLoadType.next);
  }

  /// Refreshes the current data (reloads first page and replaces all items)
  ///
  /// Calls the loader function with page 1 to refresh the data,
  /// replacing all existing items with fresh data from the server.
  Future<void> refresh() async {
    await _loadData(PaginatrixLoadType.refresh);
  }

  /// Retries the last failed operation
  Future<void> retry() async {
    if (state.hasError) {
      await loadFirstPage();
    } else if (state.hasAppendError) {
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
    emit(PaginationState.initial());
  }

  /// Unified data loading method that handles all load types
  ///
  /// This method consolidates the common logic for loading data,
  /// reducing code duplication across loadFirstPage, loadNextPage, and refresh.
  Future<void> _loadData(PaginatrixLoadType type) async {
    // 1. Guard Checks
    if (state.isLoading) return;
    if (type == PaginatrixLoadType.next && !canLoadMore) return;

    // Meta validation for operations requiring existing data
    // This prevents null pointer exceptions when trying to append or refresh
    final currentMeta = state.meta;
    if ((type == PaginatrixLoadType.next || type == PaginatrixLoadType.refresh)) {
      if (currentMeta == null) {
        debugPrint(
          'PaginatedCubit: Cannot ${type == PaginatrixLoadType.next ? "append" : "refresh"} '
          'without existing metadata. Load first page first.',
        );
        return;
      }
    }

    // 2. Request Setup
    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
      isAppend: type == PaginatrixLoadType.next,
      isRefresh: type == PaginatrixLoadType.refresh,
    );

    _currentCancelToken = cancelToken;

    // 3. Set Initial State
    switch (type) {
      case PaginatrixLoadType.first:
        emit(PaginationState.loading(
          requestContext: requestContext,
        ));
        break;

      case PaginatrixLoadType.next:
        // Safe to use currentMeta here because of the guard check above
        emit(PaginationState.appending(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: currentMeta!,
        ));
        break;

      case PaginatrixLoadType.refresh:
        // Safe to use currentMeta here because of the guard check above
        emit(PaginationState.refreshing(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: currentMeta!,
        ));
        break;
    }

    // 4. Execution Block
    try {
      // Determine page to fetch
      final page = (type == PaginatrixLoadType.next) ? _getNextPageNumber() : 1;
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
      // Using List.from + addAll is more efficient than spread operator for large lists
      final newItems = type == PaginatrixLoadType.next
          ? (List<T>.from(state.items)..addAll(decodedItems))
          : decodedItems;

      final newState = PaginationState.success(
        items: newItems,
        meta: meta,
        requestContext: requestContext,
      );

      emit(newState);
    } catch (e) {
      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final error = _convertToPaginationError(e);

      // 5. Set Error State
      switch (type) {
        case PaginatrixLoadType.first:
          emit(PaginationState.error(
            error: error,
            requestContext: requestContext,
          ));
          break;

        case PaginatrixLoadType.next:
          // Safe to use currentMeta here because of the guard check above
          emit(PaginationState.appendError(
            appendError: error,
            requestContext: requestContext,
            currentItems: state.items,
            currentMeta: currentMeta!,
          ));
          break;

        case PaginatrixLoadType.refresh:
          emit(PaginationState.error(
            error: error,
            requestContext: requestContext,
            previousItems: state.items,
            previousMeta: currentMeta,
          ));
          break;
      }
    } finally {
      _currentCancelToken = null;
    }
  }

  int _getNextPageNumber() {
    final meta = state.meta;
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

  @override
  Future<void> close() {
    _scrollDebounceTimer?.cancel();
    cancel();
    return super.close();
  }
}

