import 'package:flutter_paginatrix/src/core/entities/pagination_state.dart';
import 'package:flutter_paginatrix/src/core/entities/query_criteria.dart';

extension PaginationStateExtension<T> on PaginationState<T> {
  /// Whether the state has data
  bool get hasData => items.isNotEmpty;

  /// Whether the state is loading
  bool get isLoading => status.maybeWhen(
        loading: () => true,
        refreshing: () => true,
        appending: () => true,
        orElse: () => false,
      );

  /// Whether the state has an error
  bool get hasError => error != null;

  /// Whether the state has an append error
  bool get hasAppendError => appendError != null;

  /// Whether more data can be loaded
  bool get canLoadMore => meta?.hasMore ?? false;

  /// Whether the state is in a stable state (not loading)
  bool get isStable => !isLoading;

  /// Whether the state is in an error state
  bool get isError => status.maybeWhen(
        error: () => true,
        orElse: () => false,
      );

  /// Whether the state is empty
  bool get isEmpty => status.maybeWhen(
        empty: () => true,
        orElse: () => false,
      );

  /// Whether the state is successful
  bool get isSuccess => status.maybeWhen(
        success: () => true,
        orElse: () => false,
      );

  /// Gets the current query criteria, or empty criteria if null
  QueryCriteria get currentQuery => query ?? QueryCriteria.empty();

  /// Whether the footer should be displayed
  ///
  /// **Best Practice:** This encapsulates the business logic for when to show
  /// the footer (append loader, error, or end of list message). This logic
  /// should be in the state/cubit, not in widgets, to prevent duplication
  /// and ensure consistency.
  ///
  /// **Footer Display Rules:**
  /// - Show footer if appending or has append error (with items or more pages available)
  /// - Show footer if no more data but we have items (show "end of list" message)
  /// - Don't show footer if no items and no more pages (empty search results)
  ///
  /// **Returns:** `true` if footer should be displayed, `false` otherwise
  bool get shouldShowFooter {
    final isAppending = status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );
    final hasMore = canLoadMore;
    final itemCount = items.length;

    // Don't show footer if there are no items and no more pages
    // This prevents showing loading indicator when search returns empty results
    if (itemCount == 0 && !hasMore) {
      return false;
    }

    // Show footer if:
    // 1. Appending or has append error (with items or more pages available)
    // 2. No more data but we have items (show "end of list" message)
    return ((isAppending || hasAppendError) && (itemCount > 0 || hasMore)) ||
        (!hasMore && itemCount > 0 && !isAppending && !hasAppendError);
  }

  /// Whether the state is in appending status
  ///
  /// **Best Practice:** Provides a convenient way to check appending status
  /// without using `maybeWhen` in widgets.
  bool get isAppending => status.maybeWhen(
        appending: () => true,
        orElse: () => false,
      );
}
