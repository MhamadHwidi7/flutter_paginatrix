import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';
import 'package:flutter_paginatrix/src/presentation/widgets/paginatrix_empty_view.dart';

/// Predefined empty view for search results
class PaginatrixSearchEmptyView extends StatelessWidget {
  const PaginatrixSearchEmptyView({
    super.key,
    this.query,
    this.onClearSearch,
  });
  final String? query;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: Builder(
        builder: (context) => Icon(
          Icons.search_off,
          size: 64,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
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

/// Predefined empty view for network errors
class PaginatrixNetworkEmptyView extends StatelessWidget {
  const PaginatrixNetworkEmptyView({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: Builder(
        builder: (context) => Icon(
          Icons.wifi_off,
          size: 64,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
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

/// Predefined empty view for generic empty state
class PaginatrixGenericEmptyView extends StatelessWidget {
  const PaginatrixGenericEmptyView({
    super.key,
    this.message,
    this.onRefresh,
  });

  final String? message;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return PaginatrixEmptyView(
      icon: Builder(
        builder: (context) => Icon(
          Icons.inbox_outlined,
          size: 64,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
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

