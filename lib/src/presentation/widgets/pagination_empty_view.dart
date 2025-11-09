import 'package:flutter/material.dart';

/// Empty state view for when no data is available
class PaginationEmptyView extends StatelessWidget {
  const PaginationEmptyView({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.action,
    this.onActionTap,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final Widget? icon;
  final String? title;
  final String? description;
  final Widget? action;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Padding(
      padding: padding ?? const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 24),
          ] else ...[
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
          ],
          
          if (title != null) ...[
            Text(
              title!,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
          
          if (description != null) ...[
            Text(
              description!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          
          if (action != null) ...[
            Builder(
              builder: (context) {
                final widget = action!;
                if (onActionTap != null) {
                  return GestureDetector(
                    onTap: onActionTap,
                    child: widget,
                  );
                }
                return widget;
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Predefined empty view for search results
class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({
    super.key,
    this.query,
    this.onClearSearch,
  });
  final String? query;
  final VoidCallback? onClearSearch;
  
  @override
  Widget build(BuildContext context) {
    return PaginationEmptyView(
      icon: Icon(
        Icons.search_off,
        size: 64,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
class NetworkEmptyView extends StatelessWidget {
  final VoidCallback? onRetry;
  
  const NetworkEmptyView({
    super.key,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return PaginationEmptyView(
      icon: Icon(
        Icons.wifi_off,
        size: 64,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
class GenericEmptyView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRefresh;
  
  const GenericEmptyView({
    super.key,
    this.message,
    this.onRefresh,
  });
  
  @override
  Widget build(BuildContext context) {
    return PaginationEmptyView(
      icon: Icon(
        Icons.inbox_outlined,
        size: 64,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
