import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:flutter_paginatrix/src/core/utils/generation_guard.dart';

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

  // CancelToken tracking for operation coordination
  // Track tokens separately for refresh and append operations to enable
  // proper cancellation when operations conflict (e.g., refresh cancels append)
  CancelToken? _refreshCancelToken;
  CancelToken? _appendCancelToken;
  CancelToken? _firstPageCancelToken;

  Timer? _scrollDebounceTimer;
  Timer? _refreshDebounceTimer;
  Timer? _searchDebounceTimer;

  // Retry backoff tracking
  int _retryCount = 0;
  DateTime? _lastRetryTime;

  /// Whether more data can be loaded.
  ///
  /// Returns true if there are more pages available to load, false otherwise.
  /// This is determined by checking if the current page is less than the last page.
  bool get canLoadMore => state.canLoadMore;

  /// Whether the cubit is currently loading data.
  ///
  /// Returns true if a load operation is in progress, false otherwise.
  /// This includes initial load, refresh, and append operations.
  bool get isLoading => state.isLoading;

  /// Whether the cubit has successfully loaded data.
  ///
  /// Returns true if there are items in the current state, false otherwise.
  bool get hasData => state.hasData;

  /// Whether the cubit has encountered an error during initial load.
  ///
  /// Returns true if the initial load failed, false otherwise.
  /// Use [retry] to attempt loading again.
  bool get hasError => state.hasError;

  /// Whether the cubit has encountered an error during append operation.
  ///
  /// Returns true if loading the next page failed, false otherwise.
  /// Use [retry] to attempt loading again.
  bool get hasAppendError => state.hasAppendError;

  /// Safely cancels the scroll debounce timer to prevent memory leaks
  ///
  /// **Timer Lifecycle:**
  /// - Timers are created when scroll events trigger near-end detection
  /// - Timers are automatically cancelled in the `finally` block of `_loadData()`
  /// - Timers are also cancelled in `close()` to ensure cleanup
  /// - If an error occurs before timer creation, no cleanup is needed (safe)
  void _cancelDebounceTimer() {
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = null;
  }

  /// Safely cancels the refresh debounce timer to prevent memory leaks
  ///
  /// **Timer Lifecycle:**
  /// - Timers are created when `refresh()` is called
  /// - Timers are automatically cancelled in the `finally` block of `_loadData()`
  /// - Timers are also cancelled in `close()` to ensure cleanup
  /// - If an error occurs before timer creation, no cleanup is needed (safe)
  void _cancelRefreshDebounceTimer() {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = null;
  }

  /// Safely cancels the search debounce timer to prevent memory leaks
  ///
  /// **Timer Lifecycle:**
  /// - Timers are created when `updateSearchTerm()` is called
  /// - Timers are cancelled when a new search term is set (replaced)
  /// - Timers are also cancelled in `close()` to ensure cleanup
  /// - If an error occurs before timer creation, no cleanup is needed (safe)
  void _cancelSearchDebounceTimer() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = null;
  }

  /// Safely emits a new state, preventing errors when cubit is closed
  ///
  /// This wrapper method checks if the cubit is closed before emitting.
  /// This prevents "Cannot emit new states after calling close" errors
  /// that can occur when asynchronous operations complete after the cubit
  /// has been closed (e.g., during route navigation or widget disposal).
  ///
  /// **Best Practice:** Always use `_safeEmit()` instead of direct `emit()`
  /// to prevent runtime errors from stale async callbacks.
  ///
  /// **Parameters:**
  /// - [state] - The new state to emit
  void _safeEmit(PaginationState<T> state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Validates that a request context is still valid (not stale) and cubit is not closed
  ///
  /// This method checks both generation validity and cubit closure status.
  /// It should be called before applying any results from an async operation
  /// to prevent stale responses from overwriting newer data.
  ///
  /// **Why this matters:**
  /// - Older inflight responses can complete after newer requests
  /// - Without generation checks, older data can overwrite newer data
  /// - This causes incorrect UI state and data corruption
  ///
  /// **Best Practice:** Always call this before emitting state based on
  /// async operation results (success or error).
  ///
  /// **Parameters:**
  /// - [requestContext] - The request context to validate
  ///
  /// **Returns:** True if the context is valid and cubit is open, false otherwise
  bool _isValidRequestContext(RequestContext requestContext) {
    if (isClosed) return false;
    return _generationGuard.isValid(requestContext);
  }

  /// Handles the scroll near-end event by emitting immediate feedback and scheduling load
  ///
  /// This method extracts the complex logic for handling near-end scroll events,
  /// including immediate state emission and debounced API calls.
  ///
  /// **Parameters:**
  /// - [debounceDuration] - Duration to wait before triggering the actual API call
  void _handleNearEndScroll(Duration debounceDuration) {
    // Cancel any pending debounce timer
    _cancelDebounceTimer();

    // Emit appending state immediately to show loading footer
    // This provides immediate visual feedback while debouncing the actual API call
    _emitImmediateAppendingState();

    // Create new debounce timer for actual API call
    _scrollDebounceTimer = Timer(debounceDuration, () {
      // Early return check to prevent execution after cubit is closed
      if (isClosed) return;
      _executeDebouncedLoad();
    });
  }

  /// Emits appending state immediately for visual feedback
  ///
  /// This provides immediate visual feedback to the user while the debounced
  /// API call is being prepared. The state is emitted synchronously to show
  /// the loading footer right away.
  ///
  /// **Note:** This creates a temporary request context for visual feedback only.
  /// The actual load operation will create a new request context with a new generation.
  /// We check isClosed to prevent emitting after cubit closure.
  void _emitImmediateAppendingState() {
    if (isClosed) return; // Don't emit if cubit is closed

    final currentMeta = state.meta;
    if (currentMeta != null &&
        !state.status.maybeWhen(appending: () => true, orElse: () => false)) {
      // Create a temporary request context for immediate feedback
      // This uses the current generation, but the actual load will increment it
      final tempRequestContext = RequestContext.create(
        generation: _generationGuard.currentGeneration,
        cancelToken: CancelToken(),
        isAppend: true,
      );

      // Emit appending state immediately - footer will show right away
      // Note: This is safe because _safeEmit also checks isClosed
      _safeEmit(PaginationState.appending(
        requestContext: tempRequestContext,
        currentItems: state.items,
        currentMeta: currentMeta,
        query: state.query ?? const QueryCriteria(),
      ));
    }
  }

  /// Executes the debounced load operation after scroll debounce delay
  ///
  /// This method is called after the debounce timer expires to actually
  /// trigger the next page load. It includes proper guards against race
  /// conditions and cubit closure.
  Future<void> _executeDebouncedLoad() async {
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
          // Re-throw other errors to be handled by _loadData's error handling
          // This ensures proper error state emission
          if (!isClosed) {
            rethrow; // Let _loadData handle it properly
          }
        }
      }
    }
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

    // Don't trigger pagination if there are no items (e.g., empty search results)
    // This prevents showing loading footer when search returns no results
    if (!hasData && !canLoadMore) return false;

    // Only check if we have valid scroll dimensions
    if (!metrics.hasContentDimensions || metrics.maxScrollExtent == 0) {
      return false;
    }

    // Use provided threshold or default from options
    final threshold = prefetchThreshold ?? _options.defaultPrefetchThreshold;
    final thresholdPixels =
        threshold * PaginatrixScrollConstants.thresholdPixelMultiplier;

    // Calculate remaining scroll distance
    final remainingScroll = metrics.maxScrollExtent - metrics.pixels;

    // Check if we're near the end (within threshold pixels from bottom)
    // For reverse scrolling, check distance from top
    final isNearEnd = reverse
        ? metrics.pixels <= metrics.minScrollExtent + thresholdPixels
        : remainingScroll <= thresholdPixels;

    if (isNearEnd) {
      _handleNearEndScroll(debounceDuration);
      return true;
    }

    return false;
  }

  /// Loads the first page of data (resets the list and starts fresh).
  ///
  /// Calls the loader function with page 1 and replaces all existing items
  /// with the new data. This is used for initial load or when resetting the list.
  ///
  /// **Usage:**
  /// ```dart
  /// await controller.loadFirstPage();
  /// ```
  ///
  /// **State transitions:**
  /// - Initial/Loading → Success (with data) or Empty (no data) or Error
  ///
  /// **Note:** This will cancel any in-flight requests and reset the state.
  Future<void> loadFirstPage() async {
    await _loadData(PaginatrixLoadType.first);
  }

  /// Loads the next page of data (appends new data to existing list).
  ///
  /// Calls the same loader function with the next page number and appends
  /// the returned data to the existing list. This is used for pagination.
  ///
  /// **Usage:**
  /// ```dart
  /// await controller.loadNextPage();
  /// ```
  ///
  /// **State transitions:**
  /// - Success → Appending → Success (with more items) or AppendError
  ///
  /// **Note:** This requires that the first page has been loaded successfully.
  /// Will not proceed if [canLoadMore] is false or if already loading.
  Future<void> loadNextPage() async {
    await _loadData(PaginatrixLoadType.next);
  }

  /// Refreshes the current data (reloads first page and replaces all items).
  ///
  /// Calls the loader function with page 1 to refresh the data,
  /// replacing all existing items with fresh data from the server.
  ///
  /// **Usage:**
  /// ```dart
  /// await controller.refresh();
  /// ```
  ///
  /// **State transitions:**
  /// - Success → Refreshing → Success (with fresh data) or Error
  ///
  /// **Debouncing:**
  /// Uses debouncing to prevent rapid successive refresh calls.
  /// The debounce duration is configurable via [PaginationOptions.refreshDebounceDuration].
  /// If a refresh is already in progress or debounced, subsequent calls will be ignored.
  ///
  /// **Note:** This preserves existing items while refreshing, providing a smooth UX.
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

  /// Retries the last failed operation with exponential backoff.
  ///
  /// Automatically determines whether to retry the initial load or append operation
  /// based on the current error state.
  ///
  /// **Usage:**
  /// ```dart
  /// await controller.retry();
  /// ```
  ///
  /// **Exponential Backoff:**
  /// Implements exponential backoff to prevent hammering the server:
  /// - Wait time = `initialBackoff * exponentialBackoffBase * (2^retryCount)`
  /// - Max retries from [PaginationOptions.maxRetries]
  /// - Resets after [PaginationOptions.retryResetTimeout]
  ///
  /// **Example:**
  /// - 1st retry: waits 1000ms (500ms * 2 * 2^0)
  /// - 2nd retry: waits 2000ms (500ms * 2 * 2^1)
  /// - 3rd retry: waits 4000ms (500ms * 2 * 2^2)
  ///
  /// **Note:** If max retries are exceeded, this method will log a warning
  /// and return without attempting a retry. Wait for the reset timeout before retrying again.
  Future<void> retry() async {
    // Check if cubit is closed before proceeding
    if (isClosed) return;

    // Reset retry count if last retry was more than retryResetTimeout ago
    final lastRetryTime = _lastRetryTime;
    if (lastRetryTime != null &&
        DateTime.now().difference(lastRetryTime) > _options.retryResetTimeout) {
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
    // Formula: initialBackoff * exponentialBackoffBase * (2^retryCount)
    final backoffDelay =
        _options.initialBackoff * _calculateBackoffMultiplier(_retryCount);

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

  /// Calculates the exponential backoff multiplier for retry attempts
  ///
  /// Formula: exponentialBackoffBase * (2^retryCount)
  /// This provides exponential backoff: 2^0 = 1, 2^1 = 2, 2^2 = 4, etc.
  ///
  /// **Parameters:**
  /// - [retryCount] - Current retry attempt number (0-based)
  ///
  /// **Returns:** Multiplier value for the backoff calculation
  int _calculateBackoffMultiplier(int retryCount) {
    return PaginationDefaults.exponentialBackoffBase * (1 << retryCount);
  }

  /// Cancels all in-flight requests.
  ///
  /// This will cancel any ongoing HTTP requests (refresh, append, or first page)
  /// and prevent them from updating the state. Useful when you need to cancel
  /// requests (e.g., when navigating away from a page).
  ///
  /// **Best Practice:** This method cancels all operation types to ensure
  /// no stale responses can mutate state after cancellation.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.cancel();
  /// ```
  ///
  /// **Note:** This does not reset the state, only cancels the current requests.
  /// Use [clear] if you want to reset the state as well.
  void cancel() {
    _cancelAllTokens();
  }

  /// Cancels all active cancel tokens
  ///
  /// **Best Practice:** This ensures all in-flight requests are cancelled,
  /// preventing stale responses from mutating state.
  void _cancelAllTokens() {
    _refreshCancelToken?.cancel();
    _refreshCancelToken = null;
    _appendCancelToken?.cancel();
    _appendCancelToken = null;
    _firstPageCancelToken?.cancel();
    _firstPageCancelToken = null;
  }

  /// Gets the appropriate cancel token for a load type
  ///
  /// **Best Practice:** Returns the token associated with the operation type
  /// for proper tracking and cancellation.
  CancelToken? _getCancelTokenForType(PaginatrixLoadType type) {
    switch (type) {
      case PaginatrixLoadType.first:
        return _firstPageCancelToken;
      case PaginatrixLoadType.next:
        return _appendCancelToken;
      case PaginatrixLoadType.refresh:
        return _refreshCancelToken;
    }
  }

  /// Sets the cancel token for a specific load type
  ///
  /// **Best Practice:** Tracks tokens by operation type to enable
  /// selective cancellation (e.g., cancel append when refresh starts).
  void _setCancelTokenForType(PaginatrixLoadType type, CancelToken? token) {
    switch (type) {
      case PaginatrixLoadType.first:
        _firstPageCancelToken = token;
        break;
      case PaginatrixLoadType.next:
        _appendCancelToken = token;
        break;
      case PaginatrixLoadType.refresh:
        _refreshCancelToken = token;
        break;
    }
  }

  /// Cancels tokens for conflicting operations
  ///
  /// **Operation Coordination Semantics:**
  /// - When refresh starts: cancel any in-flight append operations
  /// - When append starts: cancel any in-flight refresh operations
  /// - When first page loads: cancel any in-flight refresh or append operations
  ///
  /// **Why this matters:**
  /// - Prevents data corruption from interleaved operations
  /// - Ensures refresh always replaces data (not appends)
  /// - Ensures append doesn't conflict with refresh
  ///
  /// **Parameters:**
  /// - [type] - The type of operation starting
  void _cancelConflictingOperations(PaginatrixLoadType type) {
    switch (type) {
      case PaginatrixLoadType.first:
        // First page load cancels both refresh and append
        _refreshCancelToken?.cancel();
        _refreshCancelToken = null;
        _appendCancelToken?.cancel();
        _appendCancelToken = null;
        break;
      case PaginatrixLoadType.next:
        // Append cancels refresh (refresh should replace, not append)
        _refreshCancelToken?.cancel();
        _refreshCancelToken = null;
        break;
      case PaginatrixLoadType.refresh:
        // Refresh cancels append (refresh replaces data, append would corrupt it)
        _appendCancelToken?.cancel();
        _appendCancelToken = null;
        break;
    }
  }

  /// Clears all data and resets to initial state.
  ///
  /// Cancels any in-flight requests and resets the state to initial.
  /// This is useful when you want to completely reset the pagination state.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.clear();
  /// // Then load first page again
  /// await controller.loadFirstPage();
  /// ```
  ///
  /// **Note:** This will emit the initial state, clearing all items and metadata.
  void clear() {
    cancel();
    _safeEmit(PaginationState.initial());
  }

  /// Updates the search term and triggers a debounced reload of the first page.
  ///
  /// This method updates the query criteria with the new search term and
  /// automatically reloads the first page after a debounce delay to prevent
  /// excessive API calls while the user is typing.
  ///
  /// **Usage:**
  /// ```dart
  /// // In a TextField's onChanged callback
  /// controller.updateSearchTerm('john');
  /// ```
  ///
  /// **Behavior:**
  /// - Updates `state.query.searchTerm`
  /// - Cancels any previous search debounce timer
  /// - Schedules a new debounced reload after [PaginationOptions.searchDebounceDuration]
  /// - Automatically resets to page 1 when reload occurs
  /// - Cancels any in-flight requests before starting new search
  ///
  /// **Note:** The debounce duration is configurable via [PaginationOptions.searchDebounceDuration].
  /// If the duration is zero, the reload happens immediately.
  void updateSearchTerm(String term) {
    if (isClosed) return;

    // Trim search term to normalize whitespace-only searches
    // This prevents accidental searches with only spaces
    final trimmedTerm = term.trim();

    // Update query criteria with new search term
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.copyWith(searchTerm: trimmedTerm);
    _safeEmit(state.copyWith(query: updatedQuery));

    // Cancel any previous search debounce timer
    _cancelSearchDebounceTimer();

    // Always use debounce, even for empty strings, to prevent rapid calls
    // But use a shorter debounce for empty (clear search)
    final debounceDuration = trimmedTerm.isEmpty
        ? const Duration(milliseconds: 100) // Shorter debounce for clearing
        : _options.searchDebounceDuration;

    if (debounceDuration == Duration.zero) {
      _reloadFirstPageWithCurrentQuery();
      return;
    }

    // Create debounce timer for search
    _searchDebounceTimer = Timer(debounceDuration, () {
      if (!isClosed) {
        _reloadFirstPageWithCurrentQuery();
      }
    });
  }

  /// Updates a specific filter and immediately reloads the first page.
  ///
  /// This method updates the query criteria with the new filter value and
  /// immediately triggers a reload of the first page (no debouncing).
  ///
  /// **Usage:**
  /// ```dart
  /// // Add or update a filter
  /// controller.updateFilter('status', 'active');
  ///
  /// // Remove a filter by passing null
  /// controller.updateFilter('status', null);
  /// ```
  ///
  /// **Behavior:**
  /// - Updates `state.query.filters` with the new key-value pair
  /// - If value is null, removes the filter
  /// - Immediately reloads first page (no debouncing)
  /// - Cancels any in-flight requests before starting new load
  ///
  /// **Note:** Filters trigger immediate reloads because they represent
  /// discrete user actions (e.g., selecting from a dropdown), unlike
  /// search which is continuous typing.
  void updateFilter(String key, dynamic value) {
    if (isClosed) return;

    // Validate key
    if (key.isEmpty || key.trim().isEmpty) {
      throw ArgumentError('Filter key cannot be empty');
    }

    // Validate value type (optional, but helpful)
    if (value != null &&
        value is! String &&
        value is! int &&
        value is! double &&
        value is! bool) {
      _debugLog(
          'Warning: Filter value type ${value.runtimeType} may not serialize correctly');
    }

    // Update query criteria with new filter
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.withFilter(key, value);
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with new filter (no debouncing)
    _reloadFirstPageWithCurrentQuery();
  }

  /// Updates multiple filters at once and immediately reloads the first page.
  ///
  /// This method is useful when you need to update several filters simultaneously,
  /// such as when applying a filter preset or resetting multiple filters.
  ///
  /// **Usage:**
  /// ```dart
  /// // Update multiple filters
  /// controller.updateFilters({
  ///   'status': 'active',
  ///   'category': 'electronics',
  ///   'priceRange': '100-500',
  /// });
  ///
  /// // Remove filters by passing null values
  /// controller.updateFilters({
  ///   'status': null,
  ///   'category': null,
  /// });
  /// ```
  ///
  /// **Behavior:**
  /// - Updates `state.query.filters` with all provided key-value pairs
  /// - Filters with null values are removed
  /// - Immediately reloads first page (no debouncing)
  /// - Cancels any in-flight requests before starting new load
  void updateFilters(Map<String, dynamic> filters) {
    if (isClosed) return;

    // Update query criteria with new filters
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.withFilters(filters);
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with new filters (no debouncing)
    _reloadFirstPageWithCurrentQuery();
  }

  /// Removes a specific filter and immediately reloads the first page.
  ///
  /// This method removes only the specified filter from the query criteria
  /// while preserving other filters, search term, and sorting.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.removeFilter('status');
  /// ```
  ///
  /// **Behavior:**
  /// - Removes the specified filter from `state.query.filters`
  /// - Preserves other filters, search term, and sorting
  /// - Immediately reloads first page
  void removeFilter(String key) {
    if (isClosed) return;

    // Validate key
    if (key.isEmpty || key.trim().isEmpty) {
      throw ArgumentError('Filter key cannot be empty');
    }

    // Remove filter while preserving other criteria
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.removeFilter(key);
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with updated filters
    _reloadFirstPageWithCurrentQuery();
  }

  /// Clears all filters and reloads the first page.
  ///
  /// This method removes all filters from the query criteria while preserving
  /// the search term and sorting, then reloads the first page.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.clearFilters();
  /// ```
  ///
  /// **Behavior:**
  /// - Clears all filters from `state.query.filters`
  /// - Preserves search term and sorting
  /// - Immediately reloads first page
  void clearFilters() {
    if (isClosed) return;

    // Clear filters while preserving search and sorting
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.clearFilters();
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with cleared filters
    _reloadFirstPageWithCurrentQuery();
  }

  /// Updates the sorting criteria and immediately reloads the first page.
  ///
  /// This method updates the query criteria with new sorting parameters and
  /// immediately triggers a reload of the first page.
  ///
  /// **Usage:**
  /// ```dart
  /// // Sort by name ascending
  /// controller.updateSorting('name', sortDesc: false);
  ///
  /// // Sort by price descending
  /// controller.updateSorting('price', sortDesc: true);
  ///
  /// // Clear sorting
  /// controller.updateSorting(null);
  /// ```
  ///
  /// **Behavior:**
  /// - Updates `state.query.sortBy` and `state.query.sortDesc`
  /// - If sortBy is null, clears sorting
  /// - Immediately reloads first page
  /// - Cancels any in-flight requests before starting new load
  void updateSorting(String? sortBy, {bool sortDesc = false}) {
    if (isClosed) return;

    // Validate sortBy if provided
    String? normalizedSortBy;
    if (sortBy != null) {
      final trimmed = sortBy.trim();
      if (trimmed.isEmpty) {
        throw ArgumentError('sortBy cannot be empty or whitespace-only');
      }
      // Optionally validate format (alphanumeric + underscore)
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
        _debugLog('Warning: sortBy contains invalid characters: $trimmed');
      }
      normalizedSortBy = trimmed;
    }

    // Update query criteria with new sorting
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.copyWith(
      sortBy: normalizedSortBy,
      sortDesc: normalizedSortBy != null ? sortDesc : false,
    );
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with new sorting
    _reloadFirstPageWithCurrentQuery();
  }

  /// Clears sorting and immediately reloads the first page.
  ///
  /// This method removes sorting from the query criteria while preserving
  /// search term and filters, then reloads the first page.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.clearSorting();
  /// ```
  ///
  /// **Behavior:**
  /// - Clears sorting from `state.query` (sets sortBy to null, sortDesc to false)
  /// - Preserves search term and filters
  /// - Immediately reloads first page
  void clearSorting() {
    if (isClosed) return;

    // Clear sorting while preserving search and filters
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.clearSorting();
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with cleared sorting
    _reloadFirstPageWithCurrentQuery();
  }

  /// Clears all search, filters, and sorting, then reloads the first page.
  ///
  /// This method resets the query criteria to empty and reloads the first page
  /// with no search, filters, or sorting applied.
  ///
  /// **Usage:**
  /// ```dart
  /// controller.clearAllQuery();
  /// ```
  ///
  /// **Behavior:**
  /// - Clears search term, filters, and sorting
  /// - Immediately reloads first page
  /// - Cancels any in-flight requests before starting new load
  void clearAllQuery() {
    if (isClosed) return;

    // Clear all query criteria
    final currentQuery = state.query ?? const QueryCriteria();
    final updatedQuery = currentQuery.clearAll();
    _safeEmit(state.copyWith(query: updatedQuery));

    // Immediately reload with cleared query
    _reloadFirstPageWithCurrentQuery();
  }

  /// Reloads the first page with the current query criteria
  ///
  /// This method cancels any in-flight requests, cancels search debounce timers,
  /// and loads the first page. The loader can access the current query via state.query.
  /// The app layer is responsible for reading state.query and applying it to the actual API call.
  void _reloadFirstPageWithCurrentQuery() {
    // Cancel any in-flight requests
    cancel();

    // Cancel search debounce timer (if any)
    _cancelSearchDebounceTimer();

    // Reload first page - the loader can access query via state.query
    // The app layer is responsible for reading state.query and applying it
    // to the actual API call
    loadFirstPage();
  }

  /// Determines if a load operation should proceed based on current state.
  ///
  /// This method performs defensive validation to prevent crashes, race conditions,
  /// and invalid state transitions by checking all prerequisites before attempting
  /// a load operation.
  ///
  /// **Validation Rules (in order of execution):**
  ///
  /// 1. **Appending State Exception:**
  ///    - If state is `appending` and load type is `next`, allow proceeding
  ///    - This handles the case where appending state is emitted immediately for
  ///      visual feedback, but the actual API call hasn't started yet
  ///    - Example: User scrolls near end → immediate appending state → debounced load
  ///
  /// 2. **Loading State Check:**
  ///    - Blocks if already loading (prevents concurrent loads)
  ///    - Exception: Allows proceeding if in appending state for next page loads
  ///    - Prevents race conditions from rapid user interactions
  ///
  /// 3. **Next Page Validation:**
  ///    - Only applies to `PaginatrixLoadType.next`
  ///    - Requires `canLoadMore == true` (more pages available)
  ///    - Requires `state.meta != null` (metadata exists for pagination calculation)
  ///    - Prevents crashes in `_getNextPageNumber()` and related methods
  ///
  /// 4. **Cubit Closure Check:**
  ///    - Blocks if cubit is closed (prevents state emissions after disposal)
  ///    - Final safety check to prevent memory leaks and exceptions
  ///
  /// **Edge Cases Handled:**
  ///
  /// - **Appending State for Next Page:**
  ///   - When user scrolls near end, we emit appending state immediately
  ///   - The actual API call is debounced, so we need to allow proceeding
  ///   - This provides immediate visual feedback while preventing duplicate calls
  ///
  /// - **First Page Loads:**
  ///   - Always proceed if not already loading (no metadata required)
  ///   - Used for initial load or reset scenarios
  ///
  /// - **Refresh Operations:**
  ///   - Require existing metadata (validated in `_validateMetaForOperation`)
  ///   - This method doesn't block refresh, but `_validateMetaForOperation` does
  ///
  /// - **Concurrent Load Prevention:**
  ///   - Multiple rapid calls to `loadFirstPage()` or `loadNextPage()` are blocked
  ///   - Only one load operation can proceed at a time
  ///
  /// **Return Values:**
  /// - `true`: Load operation should proceed
  /// - `false`: Load operation should be blocked (reason logged if debug enabled)
  ///
  /// **Usage:**
  /// ```dart
  /// if (!_shouldProceedWithLoad(PaginatrixLoadType.next)) {
  ///   return; // Blocked by validation
  /// }
  /// // Proceed with load operation
  /// ```
  ///
  /// **See Also:**
  /// - `_validateMetaForOperation()` - Validates metadata for refresh/append
  /// - `_emitImmediateAppendingState()` - Emits appending state for visual feedback
  /// - `_executeDebouncedLoad()` - Executes the actual debounced load
  bool _shouldProceedWithLoad(PaginatrixLoadType type) {
    // Early exit if closed
    if (isClosed) return false;

    // Allow proceeding if in appending state for next page loads
    // This is a special case: when user scrolls near end, we emit appending
    // state immediately for visual feedback, but the actual API call is debounced.
    // By the time the debounced call executes, we're already in appending state,
    // so we need to allow proceeding to avoid blocking the legitimate load.
    final isAppending = state.status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );

    // Check if already loading (with exception for appending state)
    // Allow proceeding if in appending state for next page loads
    // (this handles immediate visual feedback before debounced API call)
    final isCurrentlyLoading =
        state.isLoading && !(isAppending && type == PaginatrixLoadType.next);

    if (isCurrentlyLoading) {
      return false;
    }

    // For next page loads, validate prerequisites
    if (type == PaginatrixLoadType.next) {
      if (!canLoadMore) return false;
      if (state.meta == null) {
        _debugLog(
          'Cannot load next page: metadata is null. '
          'Load first page before attempting to load next page.',
        );
        return false;
      }
    }

    return true;
  }

  /// Determines pagination parameters based on load type and metadata
  ///
  /// This method extracts the complex pagination parameter determination logic
  /// from `_loadData()`, making it more testable and maintainable.
  /// Uses factory methods to create appropriate pagination parameters based on type.
  ///
  /// **Parameters:**
  /// - [type] - The type of load operation (first, next, refresh)
  /// - [currentMeta] - Current pagination metadata (null for first page)
  ///
  /// **Returns:** A map with pagination parameters (page, cursor, offset, limit)
  ///
  /// **Throws:** [StateError] if pagination type cannot be determined
  Map<String, dynamic> _determinePaginationParams(
    PaginatrixLoadType type,
    PageMeta? currentMeta,
  ) {
    // For first page or refresh, try to infer pagination type from meta parser
    if (type != PaginatrixLoadType.next || currentMeta == null) {
      // Check if meta parser is configured for offset-based pagination
      if (_metaParser is ConfigMetaParser) {
        final configParser = _metaParser;
        if (configParser.isOffsetBased) {
          // Use offset-based pagination with offset=0 for first page
          // Default limit is 20 (common default for pagination)
          return _createOffsetBasedParams(offset: 0, limit: 20);
        }
      }
      return _createPageBasedParams(page: 1);
    }

    // For next page, determine pagination type from metadata
    return _createPaginationParamsFromMeta(currentMeta);
  }

  /// Creates page-based pagination parameters
  ///
  /// **Parameters:**
  /// - [page] - The page number to load
  ///
  /// **Returns:** A map with page-based pagination parameters
  Map<String, dynamic> _createPageBasedParams({required int page}) {
    return {
      'page': page,
      'cursor': null,
      'offset': null,
      'limit': null,
    };
  }

  /// Creates cursor-based pagination parameters
  ///
  /// **Parameters:**
  /// - [cursor] - The cursor token for the next page
  ///
  /// **Returns:** A map with cursor-based pagination parameters
  Map<String, dynamic> _createCursorBasedParams({required String cursor}) {
    return {
      'page': null,
      'cursor': cursor,
      'offset': null,
      'limit': null,
    };
  }

  /// Creates offset-based pagination parameters
  ///
  /// **Parameters:**
  /// - [offset] - The offset value for the next page
  /// - [limit] - The limit value (items per page)
  ///
  /// **Returns:** A map with offset-based pagination parameters
  ///
  /// **Throws:** [StateError] if offset is out of valid range
  Map<String, dynamic> _createOffsetBasedParams({
    required int offset,
    required int limit,
  }) {
    // Bounds checking to prevent integer overflow
    if (offset < 0 || offset > PaginatrixPaginationConstants.maxOffsetValue) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message:
              'Offset calculation resulted in invalid value. Consider using cursor-based pagination for large datasets.',
          context: 'Validation Error',
          details: {
            'offset': offset.toString(),
            'min': '0',
            'max': PaginatrixPaginationConstants.maxOffsetValue.toString(),
            'suggestion':
                'For datasets with more than ${PaginatrixPaginationConstants.maxOffsetValue} items, consider switching to cursor-based pagination.',
          },
        ),
      );
    }
    return {
      'page': null,
      'cursor': null,
      'offset': offset,
      'limit': limit,
    };
  }

  /// Creates pagination parameters from metadata using factory pattern
  ///
  /// This method determines the pagination type from metadata and creates
  /// the appropriate parameters using factory methods.
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** A map with pagination parameters
  ///
  /// **Throws:** [StateError] if pagination type cannot be determined
  Map<String, dynamic> _createPaginationParamsFromMeta(PageMeta meta) {
    // Determine pagination type from metadata and use appropriate factory method
    if (meta.page != null) {
      // Page-based pagination
      return _createPageBasedParams(page: _getNextPageNumber());
    } else if (meta.nextCursor != null && meta.nextCursor!.isNotEmpty) {
      // Cursor-based pagination
      final nextCursor =
          _getNextCursor(); // Now guaranteed non-null and non-empty
      return _createCursorBasedParams(cursor: nextCursor);
    } else if (meta.offset != null && meta.limit != null) {
      // Offset-based pagination
      final currentOffset = meta.offset ?? 0;
      final limit = meta.limit;
      if (limit == null) {
        throw StateError(
          ErrorUtils.formatErrorMessage(
            message: 'Cannot create offset-based params: limit is null',
            context: 'Pagination Error',
            details: {
              'reason': 'This should not happen if meta.limit is not null',
              'paginationType': 'offset-based',
            },
          ),
        );
      }

      // Check for potential overflow BEFORE calculation
      if (currentOffset >
          PaginatrixPaginationConstants.maxOffsetValue - limit) {
        throw StateError(
          ErrorUtils.formatErrorMessage(
            message:
                'Offset calculation would overflow. Consider using cursor-based pagination for large datasets.',
            context: 'Validation Error',
            details: {
              'currentOffset': currentOffset.toString(),
              'limit': limit.toString(),
              'maxAllowed':
                  PaginatrixPaginationConstants.maxOffsetValue.toString(),
              'suggestion':
                  'For datasets with more than ${PaginatrixPaginationConstants.maxOffsetValue} items, consider switching to cursor-based pagination.',
            },
          ),
        );
      }

      final newOffset = currentOffset + limit; // Now safe

      return _createOffsetBasedParams(
        offset: newOffset,
        limit: limit,
      );
    } else {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot determine pagination type from metadata',
          context: 'Pagination Error',
          details: {
            'required':
                'Metadata must contain page, nextCursor, or offset/limit',
            'hasPage': (meta.page != null).toString(),
            'hasNextCursor': (meta.nextCursor != null).toString(),
            'hasOffset': (meta.offset != null).toString(),
            'hasLimit': (meta.limit != null).toString(),
          },
        ),
      );
    }
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
  ///
  /// **Note:** This method is called immediately after creating a new request context,
  /// so the generation should always be valid. However, we still check for safety
  /// in case the cubit was closed between request creation and state emission.
  void _emitLoadingState(
    PaginatrixLoadType type,
    RequestContext requestContext,
    PageMeta? currentMeta,
  ) {
    // Check both isClosed and generation validity for safety
    if (!_isValidRequestContext(requestContext)) return;
    final currentQuery = state.query ?? const QueryCriteria();

    // Helper to emit loading state with query
    void emitLoading(QueryCriteria query) {
      _safeEmit(PaginationState.loading(
        requestContext: requestContext,
        query: query,
      ));
    }

    switch (type) {
      case PaginatrixLoadType.first:
        emitLoading(currentQuery);
        break;

      case PaginatrixLoadType.next:
        // currentMeta is guaranteed to be non-null here due to validation in _loadData
        final meta = currentMeta;
        if (meta == null) {
          _debugLog(
              'Warning: currentMeta is null for next operation, falling back to loading state');
          emitLoading(currentQuery);
          return;
        }
        _safeEmit(PaginationState.appending(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: meta,
          query: currentQuery,
        ));
        break;

      case PaginatrixLoadType.refresh:
        // currentMeta is guaranteed to be non-null here due to validation in _loadData
        final meta = currentMeta;
        if (meta == null) {
          _debugLog(
              'Warning: currentMeta is null for refresh operation, falling back to loading state');
          emitLoading(currentQuery);
          return;
        }
        _safeEmit(PaginationState.refreshing(
          requestContext: requestContext,
          currentItems: state.items,
          currentMeta: meta,
          query: currentQuery,
        ));
        break;
    }
  }

  /// Fetches data from the loader with timeout
  ///
  /// Supports multiple pagination types:
  /// - Page-based: uses [page] parameter
  /// - Cursor-based: uses [cursor] parameter
  /// - Offset-based: uses [offset] and [limit] parameters
  Future<Map<String, dynamic>> _fetchData({
    int? page,
    String? cursor,
    int? offset,
    int? limit,
    required CancelToken cancelToken,
  }) {
    final currentQuery = state.query ?? const QueryCriteria();
    return _loader(
      page: page,
      perPage: _options.defaultPageSize,
      offset: offset,
      limit: limit,
      cursor: cursor,
      cancelToken: cancelToken,
      query: currentQuery, // Pass QueryCriteria directly
    ).timeout(
      _options.requestTimeout,
      onTimeout: () {
        throw ErrorUtils.createNetworkError(
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
      throw ErrorUtils.createParseError(
        message: 'Failed to process response data: ${e.toString()}',
        expectedFormat: 'Expected valid items array and metadata structure',
        actualData: data,
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
    final currentQuery = state.query ?? const QueryCriteria();

    // Handle empty items based on load type
    if (items.isEmpty) {
      if (type == PaginatrixLoadType.next) {
        // Empty append - could be valid (no more items) or error
        // Check if hasMore to determine
        if (meta.hasMore == false) {
          // Valid empty append - no more items available
          // Return success state with existing items (no new items to append)
          return PaginationState.success(
            items: state.items,
            meta: meta,
            requestContext: requestContext,
            query: currentQuery,
          );
        } else {
          // Unexpected empty append - might be an error
          // Log warning but return success state to avoid breaking the UI
          _debugLog(
            'Warning: Received empty items but hasMore is true. '
            'This might indicate an API issue. Possible causes: '
            '1) API returned incorrect hasMore flag, '
            '2) All items were filtered out, '
            '3) API pagination logic error. '
            'Check your API response structure and meta parser configuration.',
          );
          return PaginationState.success(
            items: state.items,
            meta: meta,
            requestContext: requestContext,
            query: currentQuery,
          );
        }
      } else {
        // Empty first page or refresh - return empty state
        return PaginationState<T>.empty(
          requestContext: requestContext,
          query: currentQuery,
        );
      }
    }

    return PaginationState.success(
      items: items,
      meta: meta,
      requestContext: requestContext,
      query: currentQuery,
    );
  }

  /// Emits appropriate error state based on load type
  ///
  /// **Important:** This method validates the request context to prevent
  /// stale error responses from overwriting newer state. Always call this
  /// after validating the request context in the calling code.
  void _emitErrorState(
    PaginatrixLoadType type,
    PaginationError error,
    RequestContext requestContext,
    PageMeta? currentMeta,
  ) {
    // Validate request context to prevent stale error responses
    if (!_isValidRequestContext(requestContext)) return;
    final currentQuery = state.query ?? const QueryCriteria();
    switch (type) {
      case PaginatrixLoadType.first:
        _safeEmit(PaginationState.error(
          error: error,
          requestContext: requestContext,
          query: currentQuery,
        ));
        break;

      case PaginatrixLoadType.next:
        if (currentMeta == null) {
          // Preserve items and previous meta even if current meta is missing
          // This prevents user from losing their data when append fails without metadata
          _safeEmit(PaginationState.error(
            error: error,
            requestContext: requestContext,
            previousItems: state.items,
            previousMeta: state.meta, // Preserve previous meta if available
            query: currentQuery,
          ));
        } else {
          _safeEmit(PaginationState.appendError(
            appendError: error,
            requestContext: requestContext,
            currentItems: state.items,
            currentMeta: currentMeta,
            query: currentQuery,
          ));
        }
        break;

      case PaginatrixLoadType.refresh:
        _safeEmit(PaginationState.error(
          error: error,
          requestContext: requestContext,
          previousItems: state.items,
          previousMeta: currentMeta,
          query: currentQuery,
        ));
        break;
    }
  }

  /// Unified data loading method that handles all load types
  ///
  /// This method consolidates the common logic for loading data,
  /// reducing code duplication across loadFirstPage, loadNextPage, and refresh.
  ///
  /// **Operation Coordination:**
  /// - Cancels conflicting operations before starting new ones
  /// - Tracks cancel tokens separately by operation type
  /// - Ensures proper cleanup on completion or error
  ///
  /// **Request Lifecycle:**
  /// 1. Cancel conflicting operations (refresh vs append)
  /// 2. Create fresh CancelToken for this operation
  /// 3. Track token by operation type
  /// 4. Execute request
  /// 5. Clear token on completion/error
  Future<void> _loadData(PaginatrixLoadType type) async {
    // 1. Guard Checks
    if (!_shouldProceedWithLoad(type)) return;

    final currentMeta = _validateMetaForOperation(type);
    if (currentMeta == null && type != PaginatrixLoadType.first) return;

    // 2. Operation Coordination: Cancel conflicting operations
    // This ensures refresh doesn't interleave with append, and vice versa
    _cancelConflictingOperations(type);

    // 3. Request Setup
    final generation = _generationGuard.incrementGeneration();
    final cancelToken = CancelToken();
    final requestContext = _createRequestContext(
      generation,
      cancelToken,
      type,
    );
    // Track token by operation type for proper cancellation
    _setCancelTokenForType(type, cancelToken);

    // 3. Set Initial State
    _emitLoadingState(type, requestContext, currentMeta);

    // 4. Execution Block
    try {
      // Determine pagination parameters based on metadata type
      final paginationParams = _determinePaginationParams(type, currentMeta);

      final data = await _fetchData(
        page: paginationParams['page'] as int?,
        cursor: paginationParams['cursor'] as String?,
        offset: paginationParams['offset'] as int?,
        limit: paginationParams['limit'] as int?,
        cancelToken: cancelToken,
      );

      // Validate request context before processing response
      // This prevents stale responses from overwriting newer data
      if (!_isValidRequestContext(requestContext)) {
        return; // Stale response or cubit closed
      }

      final parsed = _parseResponseData(data);

      // Double-check validity after parsing (cubit might have closed during parsing)
      if (!_isValidRequestContext(requestContext)) {
        return; // Stale response or cubit closed
      }

      final newItems = _combineItems(type, parsed.items);
      final newState = _createSuccessState(
        newItems,
        parsed.meta,
        requestContext,
        type,
      );

      // Final check before emitting (defensive programming)
      if (_isValidRequestContext(requestContext)) {
        _safeEmit(newState);
        _resetRetryTracking();
      }
    } catch (e) {
      // Validate request context before processing error
      // This prevents stale error responses from overwriting newer state
      if (!_isValidRequestContext(requestContext)) {
        return; // Stale response or cubit closed
      }

      final error = _convertToPaginationError(e);

      // Double-check validity after error conversion
      // (cubit might have closed during error conversion)
      if (!_isValidRequestContext(requestContext)) {
        return; // Stale response or cubit closed
      }

      _emitErrorState(type, error, requestContext, currentMeta);
    } finally {
      // Clear the cancel token for this operation type
      // Only clear if it's still the current token (may have been replaced by newer operation)
      final currentToken = _getCancelTokenForType(type);
      if (identical(currentToken, cancelToken)) {
        _setCancelTokenForType(type, null);
      }
      _cancelDebounceTimer();
      _cancelRefreshDebounceTimer();
      // Note: Search timer is intentionally NOT cancelled here because:
      // 1. Search operations should complete independently
      // 2. Search triggers loadFirstPage which will cancel in-flight requests
      // 3. Cancelling here would prevent legitimate search-triggered reloads
    }
  }

  /// Gets the next page number from current metadata.
  ///
  /// Validates that metadata exists and contains a valid page number
  /// before calculating the next page. Throws [StateError] if metadata
  /// is invalid or missing, preventing silent failures.
  ///
  /// **Preconditions:**
  /// - This method should only be called after [_validateMetaForOperation]
  ///   has confirmed metadata exists for next page loads.
  /// - [canLoadMore] should be checked before calling this method.
  /// - Only use for page-based pagination (not cursor-based or offset-based)
  ///
  /// **Returns:** The next page number (current page + 1)
  ///
  /// **Throws:** [StateError] if metadata is null or page number is invalid
  int _getNextPageNumber() {
    final meta = state.meta;
    if (meta == null) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot load next page: no metadata available',
          context: 'Validation Error',
          details: {
            'reason': 'Load first page before attempting to load next page',
          },
        ),
      );
    }

    final page = meta.page;
    if (page == null) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot load next page: page number is null in metadata',
          context: 'Validation Error',
          details: {
            'reason':
                'This may indicate cursor-based or offset-based pagination',
            'suggestion': 'Use appropriate method for the pagination type',
          },
        ),
      );
    }

    if (page < 1) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot load next page: invalid page number in metadata',
          context: 'Validation Error',
          details: {
            'expected': 'Positive integer',
            'actual': page.toString(),
          },
        ),
      );
    }

    return page + 1;
  }

  /// Gets the next cursor from current metadata for cursor-based pagination.
  ///
  /// Validates that metadata exists and contains a valid next cursor
  /// before returning it. Throws [StateError] if metadata is invalid or missing.
  ///
  /// **Preconditions:**
  /// - This method should only be called after [_validateMetaForOperation]
  ///   has confirmed metadata exists for next page loads.
  /// - [canLoadMore] should be checked before calling this method.
  /// - Only use for cursor-based pagination
  ///
  /// **Returns:** The next cursor string (guaranteed non-null and non-empty)
  ///
  /// **Throws:** [StateError] if metadata is null or next cursor is invalid
  String _getNextCursor() {
    final meta = state.meta;
    if (meta == null) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot load next page: no metadata available',
          context: 'Validation Error',
          details: {
            'reason': 'Load first page before attempting to load next page',
          },
        ),
      );
    }

    final cursor = meta.nextCursor;
    if (cursor == null || cursor.isEmpty) {
      throw StateError(
        ErrorUtils.formatErrorMessage(
          message: 'Cannot load next page: nextCursor is null or empty',
          context: 'Validation Error',
          details: {
            'reason':
                'This may indicate that there are no more pages available',
            'paginationType': 'cursor-based',
          },
        ),
      );
    }

    return cursor;
  }

  /// Converts various error types to [PaginationError].
  ///
  /// Handles conversion of different error types to appropriate
  /// [PaginationError] variants for consistent error handling.
  PaginationError _convertToPaginationError(dynamic error) {
    if (error is PaginationError) return error;
    if (error is DioException) {
      return ErrorUtils.createNetworkError(
        message: error.message ?? 'Network error',
        statusCode: error.response?.statusCode,
        originalError: error.toString(),
      );
    }
    if (error is StateError) {
      // StateError indicates invalid state (e.g., missing metadata)
      // Treat as parse error since it's related to data structure issues
      return ErrorUtils.createParseError(
        message: error.message,
        expectedFormat: 'Valid pagination metadata with page number',
        actualData: null,
      );
    }
    if (error is ArgumentError) {
      // ArgumentError indicates invalid arguments (e.g., invalid page number)
      return ErrorUtils.createParseError(
        message: error.message ?? 'Invalid argument',
        expectedFormat: 'Valid pagination parameters',
        actualData: error.invalidValue,
      );
    }
    return ErrorUtils.createUnknownError(
      message: error.toString(),
      originalError: error.toString(),
    );
  }

  /// Closes the cubit and cleans up all resources.
  ///
  /// Cancels any pending timers, in-flight requests, and closes the cubit.
  /// Always call this in the `dispose` method of your widget to prevent memory leaks.
  ///
  /// **Usage:**
  /// ```dart
  /// @override
  /// void dispose() {
  ///   controller.close();
  ///   super.dispose();
  /// }
  /// ```
  ///
  /// **Note:** After calling [close], the cubit cannot emit new states.
  @override
  Future<void> close() {
    _cancelDebounceTimer();
    _cancelRefreshDebounceTimer();
    _cancelSearchDebounceTimer();
    cancel();
    return super.close();
  }
}
