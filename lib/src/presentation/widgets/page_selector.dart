import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// A container widget for page selection with multiple display styles
class PageSelector extends StatelessWidget {
  const PageSelector({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.isLoading = false,
    this.style = PageSelectorStyle.buttons,
    this.maxVisiblePages = 7,
    this.showFirstLast = true,
    this.showPreviousNext = true,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Callback when a page is selected
  final void Function(int page) onPageSelected;

  /// Whether pagination is currently loading
  final bool isLoading;

  /// Display style for the page selector
  final PageSelectorStyle style;

  /// Maximum number of page buttons to show
  final int maxVisiblePages;

  /// Whether to show first/last page buttons
  final bool showFirstLast;

  /// Whether to show previous/next buttons
  final bool showPreviousNext;

  /// Padding around the selector
  final EdgeInsetsGeometry? padding;

  /// Background color of the container
  final Color? backgroundColor;

  /// Border radius of the container
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final colorScheme = context.colorScheme;
    final theme = context.theme;

    final container = Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: _buildContent(context, theme, colorScheme),
    );

    return container;
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    switch (style) {
      case PageSelectorStyle.buttons:
        return _buildButtonsStyle(context, theme, colorScheme);
      case PageSelectorStyle.dropdown:
        return _buildDropdownStyle(context, theme, colorScheme);
      case PageSelectorStyle.compact:
        return _buildCompactStyle(context, theme, colorScheme);
    }
  }

  Widget _buildButtonsStyle(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final pages = _generatePageNumbers(currentPage, totalPages);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: isLoading || currentPage == 1
                ? null
                : () => onPageSelected(currentPage - 1),
            tooltip: 'Previous page',
          ),
        if (showFirstLast && currentPage > 3)
          _buildPageButton(
            context,
            theme,
            colorScheme,
            1,
            isCurrent: false,
          ),
        if (showFirstLast && currentPage > 3) const SizedBox(width: 4),
        ...pages.map((page) {
          if (page == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return _buildPageButton(
            context,
            theme,
            colorScheme,
            page,
            isCurrent: page == currentPage,
          );
        }),
        if (showFirstLast && currentPage < totalPages - 2)
          const SizedBox(width: 4),
        if (showFirstLast && currentPage < totalPages - 2)
          _buildPageButton(
            context,
            theme,
            colorScheme,
            totalPages,
            isCurrent: false,
          ),
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: isLoading || currentPage == totalPages
                ? null
                : () => onPageSelected(currentPage + 1),
            tooltip: 'Next page',
          ),
      ],
    );
  }

  Widget _buildDropdownStyle(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: isLoading || currentPage == 1
                ? null
                : () => onPageSelected(currentPage - 1),
            tooltip: 'Previous page',
          ),
        const SizedBox(width: 8),
        Text(
          'Page',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: DropdownButton<int>(
            value: currentPage,
            isDense: true,
            underline: const SizedBox.shrink(),
            items: List.generate(
              totalPages,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}'),
              ),
            ),
            onChanged: isLoading
                ? null
                : (value) {
                    if (value != null && value != currentPage) {
                      onPageSelected(value);
                    }
                  },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'of $totalPages',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(width: 8),
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: isLoading || currentPage == totalPages
                ? null
                : () => onPageSelected(currentPage + 1),
            tooltip: 'Next page',
          ),
      ],
    );
  }

  Widget _buildCompactStyle(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: PaginatrixIconSizes.small,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: isLoading || currentPage == 1
                ? null
                : () => onPageSelected(currentPage - 1),
            tooltip: 'Previous',
          ),
        const SizedBox(width: PaginatrixSpacing.horizontalSmall),
        Text(
          '$currentPage / $totalPages',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: PaginatrixSpacing.horizontalSmall),
        if (showPreviousNext)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: PaginatrixIconSizes.small,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: isLoading || currentPage == totalPages
                ? null
                : () => onPageSelected(currentPage + 1),
            tooltip: 'Next',
          ),
      ],
    );
  }

  Widget _buildPageButton(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    int page, {
    required bool isCurrent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isCurrent ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: isLoading || isCurrent ? null : () => onPageSelected(page),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Text(
              '$page',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isCurrent
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<int?> _generatePageNumbers(int current, int total) {
    if (total <= maxVisiblePages) {
      // Show all pages if within max visible
      return List.generate(total, (i) => i + 1);
    }

    final pages = <int?>[];

    // Calculate how many pages to show around current
    final halfVisible = (maxVisiblePages - 2) ~/ 2; // -2 for first and last

    if (current <= halfVisible + 2) {
      // Show pages from start
      for (int i = 1; i <= maxVisiblePages - 1; i++) {
        pages.add(i);
      }
      pages.add(null); // Ellipsis
      pages.add(total);
    } else if (current >= total - halfVisible - 1) {
      // Show pages from end
      pages.add(1);
      pages.add(null); // Ellipsis
      for (int i = total - maxVisiblePages + 2; i <= total; i++) {
        pages.add(i);
      }
    } else {
      // Show pages around current
      pages.add(1);
      pages.add(null); // Ellipsis
      for (int i = current - halfVisible; i <= current + halfVisible; i++) {
        pages.add(i);
      }
      pages.add(null); // Ellipsis
      pages.add(total);
    }

    return pages;
  }
}

/// Display styles for page selector
enum PageSelectorStyle {
  /// Button style - shows page numbers as clickable buttons
  buttons,

  /// Dropdown style - shows a dropdown menu for page selection
  dropdown,

  /// Compact style - shows current/total pages with prev/next buttons
  compact,
}
