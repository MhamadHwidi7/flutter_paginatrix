import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Cubit-based controller for managing paginated data
///
/// This is the internal implementation used by [PaginatrixController].
/// For most use cases, use [PaginatrixController] instead, which provides
/// a cleaner API without requiring flutter_bloc imports.
///
/// **Advantages:**
/// - ✅ No manual StreamController management
/// - ✅ Automatic disposal and cleanup
/// - ✅ Built-in safety checks (no isClosed checks needed)
/// - ✅ Better testability with blocTest
/// - ✅ Consistent with flutter_bloc patterns
///
/// ## Usage (Advanced - with BlocProvider)
///
/// ```dart
/// final cubit = PaginatrixCubit<Pokemon>(
///   loader: repository.loadPokemonPage,
///   itemDecoder: Pokemon.fromJson,
///   metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
/// );
///
/// // In widget:
/// BlocBuilder<PaginatrixCubit<Pokemon>, PaginationState<Pokemon>>(
///   bloc: cubit,
///   builder: (context, state) {
///     // Use state directly
///   },
/// )
/// ```
class PaginatrixCubit<T> extends Cubit<PaginationState<T>> {
  /// Creates a new PaginatrixCubit
  ///
  /// [loader] - Single function that loads a page of data. Called for both
  ///            initial load (page 1) and pagination (page 2, 3, etc.).
  /// [itemDecoder] - Function to decode individual items from raw data
  /// [metaParser] - Parser to extract pagination metadata
  /// [options] - Optional pagination options
  PaginatrixCubit({
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
  Timer? _refreshDebounceTimer;

  // Retry backoff tracking
  int _retryCount = 0;
  DateTime? _lastRetryTime;

  /// Whether more data can be loaded
  bool get canLoadMore => state.canLoadMore;

  /// Whether the cubit is currently loading
  bool get isLoading => state.isLoading;

  /// Whether the cubit has data
  bool get hasData => state.hasData;

  /// Whether the cubit has an error
  bool get hasError => state.hasError;

  /// Whether the cubit has an append error
  bool get hasAppendError => state.hasAppendError;

  /// Safely cancels the scroll debounce timer to prevent memory leaks
  void _cancelDebounceTimer() {
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = null;
  }

  /// Safely cancels the refresh debounce timer to prevent memory leaks
  void _cancelRefreshDebounceTimer() {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = null;
  }

  /// Logs a debug message if debug logging is enabled
  void _debugLog(String message) {
    if (_options.enableDebugLogging) {
      debugPrint('PaginatrixCubit: $message');
    }
  }

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
      _cancelDebounceTimer();

      // Emit appending state immediately to show loading footer
      // This provides immediate visual feedback while debouncing the actual API call
      final currentMeta = state.meta;
      if (currentMeta != null &&
          !state.status.maybeWhen(appending: () => true, orElse: () => false)) {
        // Create a temporary request context for immediate feedback
        final tempRequestContext = RequestContext.create(
          generation: _generationGuard.currentGeneration,
          cancelToken: CancelToken(),
          isAppend: true,
        );

        // Emit appending state immediately - footer will show right away
        emit(PaginationState.appending(
          requestContext: tempRequestContext,
          currentItems: state.items,
          currentMeta: currentMeta,
        ));
      }

      // Create new debounce timer for actual API call
      _scrollDebounceTimer = Timer(debounceDuration, () async {
        // Guard against race condition: check if cubit is closed first
        if (isClosed) return;

        // Only load if conditions are met (double-check after timer delay)
        // Note: We allow proceeding even if already in appending state (from immediate emit above)
        if (canLoadMore && !isClosed) {
          // Check if we're already loading from a previous call
          final isCurrentlyLoading = state.status.maybeWhen(
            loading: () => true,
            refreshing: () => true,
            orElse: () => false,
          );

          // Only proceed if not already loading (but allow if just appending from immediate emit)
          if (!isCurrentlyLoading) {
            // Call loadNextPage and handle only specific race condition errors
            try {
              await loadNextPage();
            } catch (e) {
              // Only catch StateError about emitting after close
              if (e is StateError &&
                  e.message
                      .contains('Cannot emit new states after calling close')) {
                // Silently ignore - cubit was closed during execution
                return;
              }
              // For other errors, log if cubit is still open
              if (!isClosed) {
                _debugLog('Unexpected error loading next page: $e');
              }
              // Don't rethrow - errors are already handled in _loadData
            }
          }
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
  ///
  /// Uses debouncing to prevent rapid successive refresh calls.
  /// If a refresh is already in progress or debounced, subsequent calls
  /// will be ignored or queued.
  Future<void> refresh() async {
    // If already loading, don't queue another refresh
    if (state.isLoading) {
      _debugLog('Refresh called but already loading, ignoring');
      return;
    }

    // Cancel any pending refresh debounce timer
    _cancelRefreshDebounceTimer();

    // If refresh debounce is disabled (duration is zero), refresh immediately
    if (_options.refreshDebounceDuration == Duration.zero) {
      await _loadData(PaginatrixLoadType.refresh);
      return;
    }

    // Create debounce timer for refresh
    _refreshDebounceTimer = Timer(_options.refreshDebounceDuration, () async {
      // Check if cubit is closed before proceeding
      if (isClosed) return;

      // Double-check loading state after debounce delay
      if (!state.isLoading && !isClosed) {
        // Wrap in try-catch to handle race condition if cubit closes during execution
        try {
          await _loadData(PaginatrixLoadType.refresh);
        } catch (e) {
          // Silently ignore state errors if cubit was closed
          if (isClosed) return;
          // Re-throw other errors
          rethrow;
        }
      }
    });
  }

  /// Retries the last failed operation
  /// Retries the last failed request with exponential backoff
  ///
  /// Implements exponential backoff to prevent hammering the server:
  /// - Wait time = initialBackoff * 2^retryCount
  /// - Max retries from PaginationOptions
  /// - Resets after retryResetTimeout from PaginationOptions
  Future<void> retry() async {
    // Check if cubit is closed before proceeding
    if (isClosed) return;

    // Reset retry count if last retry was more than retryResetTimeout ago
    if (_lastRetryTime != null &&
        DateTime.now().difference(_lastRetryTime!) >
            _options.retryResetTimeout) {
      _retryCount = 0;
    }

    // Check if max retries exceeded
    if (_retryCount >= _options.maxRetries) {
      _debugLog(
        'Max retry attempts (${_options.maxRetries}) exceeded. '
        'Wait ${_options.retryResetTimeout.inSeconds} seconds before retrying again.',
      );
      return;
    }

    // Calculate backoff delay using exponential backoff
    final backoffDelay =
        _options.initialBackoff * (1 << _retryCount); // 2^retryCount

    _debugLog(
      'Retry attempt ${_retryCount + 1}/${_options.maxRetries} '
      'after ${backoffDelay.inMilliseconds}ms delay',
    );

    // Wait for backoff delay (with cancellation support)
    try {
      await Future.delayed(backoffDelay);
    } catch (e) {
      // If cancelled or cubit closed, don't proceed with retry
      if (isClosed) return;
      rethrow;
    }

    // Check again if cubit is closed after delay
    if (isClosed) return;

    // Update retry tracking
    _retryCount++;
    _lastRetryTime = DateTime.now();

    // Perform retry based on current state
    if (state.hasError) {
      await loadFirstPage();
    } else if (state.hasAppendError) {
      await loadNextPage();
    }
  }

  /// Resets retry tracking
  ///
  /// Called automatically on successful loads
  void _resetRetryTracking() {
    _retryCount = 0;
    _lastRetryTime = null;
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

  /// Checks if load operation should proceed
  /// Returns true if load should proceed, false otherwise
  bool _shouldProceedWithLoad(PaginatrixLoadType type) {
    // Allow proceeding if we're in appending state and trying to load next page
    // This handles the case where we emit appending state immediately for visual feedback
    final isAppending = state.status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );

    // Block if already loading (but allow appending state for next page loads)
    if (state.isLoading && !(isAppending && type == PaginatrixLoadType.next)) {
      return false;
    }
    if (type == PaginatrixLoadType.next && !canLoadMore) return false;
    if (isClosed) return false;
    return true;
  }

  /// Validates that required metadata exists for append/refresh operations
  /// Returns the current meta if valid, null otherwise
  PageMeta? _validateMetaForOperation(PaginatrixLoadType type) {
    if (type == PaginatrixLoadType.first) return null;

    final currentMeta = state.meta;
    if (currentMeta == null) {
      _debugLog(
        'Cannot ${type == PaginatrixLoadType.next ? "append" : "refresh"} '
        'without existing metadata. Load first page first.',
      );
      return null;
    }
    return currentMeta;
  }

  /// Creates request context for the load operation
  RequestContext _createRequestContext(
    int generation,
    CancelToken cancelToken,
    PaginatrixLoadType type,
  ) {
    return RequestContext.create(
      generation: generation,
      cancelToken: cancelToken,
      isAppend: type == PaginatrixLoadType.next,
      isRefresh: type == PaginatrixLoadType.refresh,
    );
  }

  /// Emits the appropriate loading state based on load type
  void _emitLoadingState(
    PaginatrixLoadType type,
    RequestContext requestContext,
    PageMeta? currentMeta,
  ) {
    switch (type) {
      case PaginatrixLoadType.first:
        emit(PaginationState.loading(
          requestContext: requestContext,
        ));
        break;

      case PaginatrixLoadType.next:
        // Safe to use currentMeta here because of validation
        emit(PaginationState.appending(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: currentMeta!,
        ));
        break;

      case PaginatrixLoadType.refresh:
        // Safe to use currentMeta here because of validation
        emit(PaginationState.refreshing(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: currentMeta!,
        ));
        break;
    }
  }

  /// Fetches data from the loader with timeout
  Future<Map<String, dynamic>> _fetchData(
    int page,
    CancelToken cancelToken,
  ) {
    return _loader(
      page: page,
      perPage: _options.defaultPageSize,
      cancelToken: cancelToken,
    ).timeout(
      _options.requestTimeout,
      onTimeout: () {
        throw PaginationError.network(
          message:
              'Request timed out after ${_options.requestTimeout.inSeconds} seconds',
          statusCode: 408,
        );
      },
    );
  }

  /// Parses response data into items and metadata
  /// Throws PaginationError if parsing fails
  ({List<T> items, PageMeta meta}) _parseResponseData(
    Map<String, dynamic> data,
  ) {
    try {
      final items = _metaParser.extractItems(data);
      final decodedItems = items.map(_itemDecoder).toList();
      final meta = _metaParser.parseMeta(data);
      return (items: decodedItems, meta: meta);
    } on PaginationError {
      rethrow;
    } catch (e) {
      throw PaginationError.parse(
        message: 'Failed to process response data: ${e.toString()}',
        expectedFormat: 'Expected valid items array and metadata structure',
        actualData: ErrorUtils.truncateData(data),
      );
    }
  }

  /// Combines existing items with new items based on load type
  List<T> _combineItems(PaginatrixLoadType type, List<T> newItems) {
    if (type == PaginatrixLoadType.next) {
      return [...state.items, ...newItems];
    }
    return newItems;
  }

  /// Creates success or empty state based on items
  PaginationState<T> _createSuccessState(
    List<T> items,
    PageMeta meta,
    RequestContext requestContext,
    PaginatrixLoadType type,
  ) {
    if (items.isEmpty && type != PaginatrixLoadType.next) {
      return PaginationState<T>.empty(requestContext: requestContext);
    }
    return PaginationState.success(
      items: items,
      meta: meta,
      requestContext: requestContext,
    );
  }

  /// Emits appropriate error state based on load type
  void _emitErrorState(
    PaginatrixLoadType type,
    PaginationError error,
    RequestContext requestContext,
    PageMeta? currentMeta,
  ) {
    switch (type) {
      case PaginatrixLoadType.first:
        emit(PaginationState.error(
          error: error,
          requestContext: requestContext,
        ));
        break;

      case PaginatrixLoadType.next:
        if (currentMeta == null) {
          // Fallback to initial error state if meta is missing
          emit(PaginationState.error(
            error: error,
            requestContext: requestContext,
            previousItems: state.items,
          ));
        } else {
          emit(PaginationState.appendError(
            appendError: error,
            requestContext: requestContext,
            currentItems: state.items,
            currentMeta: currentMeta,
          ));
        }
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
  }

  /// Unified data loading method that handles all load types
  ///
  /// This method consolidates the common logic for loading data,
  /// reducing code duplication across loadFirstPage, loadNextPage, and refresh.
  Future<void> _loadData(PaginatrixLoadType type) async {
    // 1. Guard Checks
    if (!_shouldProceedWithLoad(type)) return;

    final currentMeta = _validateMetaForOperation(type);
    if (currentMeta == null && type != PaginatrixLoadType.first) return;

    // 2. Request Setup
    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = _createRequestContext(
      generation,
      cancelToken,
      type,
    );
    _currentCancelToken = cancelToken;

    // 3. Set Initial State
    _emitLoadingState(type, requestContext, currentMeta);

    // 4. Execution Block
    try {
      final page = (type == PaginatrixLoadType.next) ? _getNextPageNumber() : 1;

      if (page < 1) {
        throw ArgumentError('Page number must be positive, got: $page');
      }

      final data = await _fetchData(page, cancelToken);

      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final parsed = _parseResponseData(data);
      final newItems = _combineItems(type, parsed.items);
      final newState = _createSuccessState(
        newItems,
        parsed.meta,
        requestContext,
        type,
      );

      emit(newState);
      _resetRetryTracking();
    } catch (e) {
      if (!_generationGuard.isValid(requestContext)) {
        return; // Stale response
      }

      final error = _convertToPaginationError(e);
      _emitErrorState(type, error, requestContext, currentMeta);
    } finally {
      _currentCancelToken = null;
      _cancelDebounceTimer();
      _cancelRefreshDebounceTimer();
    }
  }

  int _getNextPageNumber() {
    final meta = state.meta;
    final page = meta?.page;
    if (page != null && page > 0) {
      return page + 1;
    }
    // Default fallback to page 2 if no valid page found
    return 2;
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
    _cancelDebounceTimer();
    _cancelRefreshDebounceTimer();
    cancel();
    return super.close();
  }
}

/// Public API for managing paginated data
/// 
/// This is the recommended way to use flutter_paginatrix. It provides
/// a clean, package-consistent API without exposing implementation details.
/// 
/// **Why PaginatrixController?**
/// - Consistent with package naming (`PaginatrixListView`, `PaginatrixGridView`)
/// - Clean and intuitive API
/// - No need to import `flutter_bloc` directly
/// - Implementation-agnostic (uses `PaginatrixCubit` internally)
/// 
/// ## Usage
/// 
/// ```dart
/// final pagination = PaginatrixController<User>(
///   loader: _loadUsers,
///   itemDecoder: User.fromJson,
///   metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
/// );
/// 
/// PaginatrixListView<User>(
///   controller: pagination,
///   itemBuilder: (context, user, index) => UserTile(user: user),
/// )
/// ```
/// 
/// **Note:** For advanced usage with `BlocProvider` and `BlocBuilder`, you can
/// still use `PaginatrixCubit` directly, which this type aliases to.
typedef PaginatrixController<T> = PaginatrixCubit<T>;
