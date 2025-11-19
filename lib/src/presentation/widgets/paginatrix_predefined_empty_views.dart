import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';
import 'package:flutter_paginatrix/src/presentation/widgets/paginatrix_empty_view.dart';

/// Predefined empty view widget for search results.
///
/// A specialized empty state widget designed for displaying when search
/// queries return no results. It provides a user-friendly message and
/// an optional action button to clear the search.
///
/// **Example:**
/// ```dart
/// PaginatrixSearchEmptyView(
///   query: 'john doe',
///   onClearSearch: () {
///     controller.clearSearch();
///   },
/// )
/// ```
class PaginatrixSearchEmptyView extends StatelessWidget {
  /// Creates a search empty view widget.
  ///
  /// [query] - The search query that returned no results. If provided,
  ///           it will be displayed in the description message.
  /// [onClearSearch] - Optional callback to clear the search. If provided,
  ///                  a "Clear Search" button will be displayed.
  const PaginatrixSearchEmptyView({
    super.key,
    this.query,
    this.onClearSearch,
  });

  /// The search query that returned no results.
  ///
  /// If provided, the description will show "No results found for [query]".
  /// If null, a generic message will be displayed.
  final String? query;

  /// Callback function to clear the search.
  ///
  /// If provided, a "Clear Search" button will be displayed below the
  /// description. When pressed, this callback will be invoked.
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: context.buildEmptyStateIcon(Icons.search_off),
      title: 'No results found',
      description: query != null
          ? 'No results found for "$query"'
          : 'Try adjusting your search terms',
      action: onClearSearch != null
          ? ElevatedButton(
              onPressed: onClearSearch,
              child: const Text('Clear Search'),
            )
          : null,
    );
  }
}

/// Predefined empty view widget for network errors.
///
/// A specialized empty state widget designed for displaying when network
/// connectivity issues prevent data from loading. It provides a clear
/// message about the connection problem and an optional retry action.
///
/// **Example:**
/// ```dart
/// PaginatrixNetworkEmptyView(
///   onRetry: () {
///     controller.retry();
///   },
/// )
/// ```
class PaginatrixNetworkEmptyView extends StatelessWidget {
  /// Creates a network empty view widget.
  ///
  /// [onRetry] - Optional callback to retry the network request.
  ///            If provided, a "Retry" button will be displayed.
  const PaginatrixNetworkEmptyView({
    super.key,
    this.onRetry,
  });

  /// Callback function to retry the network request.
  ///
  /// If provided, a "Retry" button will be displayed below the
  /// description. When pressed, this callback will be invoked to
  /// attempt loading the data again.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: context.buildEmptyStateIcon(Icons.wifi_off),
      title: 'No connection',
      description: 'Check your internet connection and try again',
      action: onRetry != null
          ? ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            )
          : null,
    );
  }
}

/// Predefined empty view widget for generic empty states.
///
/// A general-purpose empty state widget that can be used when there's
/// no data to display. It provides a customizable message and an optional
/// refresh action button.
///
/// **Example:**
/// ```dart
/// PaginatrixGenericEmptyView(
///   message: 'No items available at this time',
///   onRefresh: () {
///     controller.refresh();
///   },
/// )
/// ```
class PaginatrixGenericEmptyView extends StatelessWidget {
  /// Creates a generic empty view widget.
  ///
  /// [message] - Optional custom message to display. If null, a default
  ///            message "There's nothing to show here yet" will be used.
  /// [onRefresh] - Optional callback to refresh the data. If provided,
  ///              a "Refresh" button will be displayed.
  const PaginatrixGenericEmptyView({
    super.key,
    this.message,
    this.onRefresh,
  });

  /// Optional custom message to display in the description.
  ///
  /// If null, defaults to "There's nothing to show here yet".
  /// This allows you to provide context-specific messages for different
  /// empty states in your application.
  final String? message;

  /// Callback function to refresh the data.
  ///
  /// If provided, a "Refresh" button will be displayed below the
  /// description. When pressed, this callback will be invoked to
  /// reload the data.
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: context.buildEmptyStateIcon(Icons.inbox_outlined),
      title: 'No data available',
      description: message ?? 'There\'s nothing to show here yet',
      action: onRefresh != null
          ? ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Refresh'),
            )
          : null,
    );
  }
}
