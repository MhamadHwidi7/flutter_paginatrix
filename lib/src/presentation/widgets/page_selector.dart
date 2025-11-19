import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// A container widget for page selection with multiple display styles
///
/// This widget provides a flexible page selector that supports three different
/// display styles: buttons, dropdown, and compact. It automatically handles
/// page number generation with ellipsis for large page counts and provides
/// navigation controls (previous/next, first/last).
///
/// **Example:**
/// ```dart
/// PageSelector(
///   currentPage: 5,
///   totalPages: 20,
///   onPageSelected: (page) {
///     controller.loadPage(page);
///   },
///   style: PageSelectorStyle.buttons,
///   maxVisiblePages: 7,
/// )
/// ```
///
/// The widget automatically hides itself when `totalPages <= 1`.
class PageSelector extends StatelessWidget {
  /// Creates a page selector widget.
  ///
  /// [currentPage] - The current page number (1-based). Must be between 1 and [totalPages].
  /// [totalPages] - The total number of pages available. Must be greater than 0.
  /// [onPageSelected] - Callback function called when a page is selected. Receives the selected page number.
  /// [isLoading] - Whether pagination is currently loading. Disables all interactions when true. Defaults to false.
  /// [style] - The display style for the page selector. Defaults to [PageSelectorStyle.buttons].
  /// [maxVisiblePages] - Maximum number of page buttons to show in buttons style. Defaults to 7.
  /// [showFirstLast] - Whether to show first/last page buttons. Defaults to true.
  /// [showPreviousNext] - Whether to show previous/next navigation buttons. Defaults to true.
  /// [padding] - Padding around the selector container. If null, uses default padding.
  /// [backgroundColor] - Background color of the container. If null, uses theme's surface color.
  /// [borderRadius] - Border radius of the container. If null, uses default rounded corners.
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

  /// The current page number (1-based).
  ///
  /// This value must be between 1 and [totalPages] (inclusive).
  /// The current page will be highlighted in the buttons style.
  final int currentPage;

  /// The total number of pages available.
  ///
  /// Must be greater than 0. If `totalPages <= 1`, the widget
  /// will automatically hide itself.
  final int totalPages;

  /// Callback function called when a page is selected.
  ///
  /// Receives the selected page number (1-based) as a parameter.
  /// This callback is not called when:
  /// - The selected page is the same as [currentPage]
  /// - [isLoading] is true
  /// - Navigation buttons are disabled (e.g., previous on page 1)
  final void Function(int page) onPageSelected;

  /// Whether pagination is currently loading.
  ///
  /// When true, all page selection interactions are disabled.
  /// Navigation buttons and page buttons will be disabled during loading.
  /// Defaults to false.
  final bool isLoading;

  /// The display style for the page selector.
  ///
  /// - [PageSelectorStyle.buttons]: Shows page numbers as clickable buttons
  /// - [PageSelectorStyle.dropdown]: Shows a dropdown menu for page selection
  /// - [PageSelectorStyle.compact]: Shows current/total pages with prev/next buttons
  ///
  /// Defaults to [PageSelectorStyle.buttons].
  final PageSelectorStyle style;

  /// Maximum number of page buttons to show in buttons style.
  ///
  /// When the total number of pages exceeds this value, the widget
  /// will show ellipsis (...) to indicate hidden pages. The widget
  /// intelligently shows pages around the current page.
  ///
  /// Defaults to 7. This value is only used for [PageSelectorStyle.buttons].
  final int maxVisiblePages;

  /// Whether to show first/last page buttons.
  ///
  /// When true, buttons to jump to the first and last page will be
  /// displayed (when applicable). These buttons only appear when the
  /// current page is far enough from the edges.
  ///
  /// Defaults to true.
  final bool showFirstLast;

  /// Whether to show previous/next navigation buttons.
  ///
  /// When true, buttons to navigate to the previous and next page
  /// will be displayed. These buttons are automatically disabled
  /// when at the first or last page.
  ///
  /// Defaults to true.
  final bool showPreviousNext;

  /// Padding around the selector container.
  ///
  /// If null, uses default padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 12)`.
  final EdgeInsetsGeometry? padding;

  /// Background color of the container.
  ///
  /// If null, uses the theme's surface color from the current context.
  final Color? backgroundColor;

  /// Border radius of the container.
  ///
  /// If null, uses default border radius: `BorderRadius.all(Radius.circular(12))`.
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
          _buildPreviousButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
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
          _buildNextButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
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
          _buildPreviousButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
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
          _buildNextButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
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
          _buildPreviousButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
            iconSize: PaginatrixIconSizes.small,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
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
          _buildNextButton(
            context: context,
            theme: theme,
            colorScheme: colorScheme,
            iconSize: PaginatrixIconSizes.small,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Next',
          ),
      ],
    );
  }

  /// Builds a previous page navigation button
  Widget _buildPreviousButton({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    double? iconSize,
    EdgeInsets? padding,
    BoxConstraints? constraints,
    String tooltip = 'Previous page',
  }) {
    return IconButton(
      icon: const Icon(Icons.chevron_left),
      iconSize: iconSize,
      padding: padding,
      constraints: constraints,
      onPressed: isLoading || currentPage == 1
          ? null
          : () => onPageSelected(currentPage - 1),
      tooltip: tooltip,
    );
  }

  /// Builds a next page navigation button
  Widget _buildNextButton({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    double? iconSize,
    EdgeInsets? padding,
    BoxConstraints? constraints,
    String tooltip = 'Next page',
  }) {
    return IconButton(
      icon: const Icon(Icons.chevron_right),
      iconSize: iconSize,
      padding: padding,
      constraints: constraints,
      onPressed: isLoading || currentPage == totalPages
          ? null
          : () => onPageSelected(currentPage + 1),
      tooltip: tooltip,
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

/// Display styles for the page selector widget.
///
/// This enum defines the different visual styles available for displaying
/// page selection controls. Each style provides a different user experience
/// optimized for different use cases.
enum PageSelectorStyle {
  /// Button style - shows page numbers as clickable buttons.
  ///
  /// Displays page numbers as individual clickable buttons with the current
  /// page highlighted. Uses ellipsis (...) to indicate hidden pages when
  /// the total number of pages exceeds the maximum visible pages setting.
  ///
  /// Best for: Desktop and tablet interfaces where space is available.
  ///
  /// **Example:**
  /// ```
  /// [<] [1] [2] [3] ... [20] [>]
  /// ```
  buttons,

  /// Dropdown style - shows a dropdown menu for page selection.
  ///
  /// Displays a dropdown menu containing all available pages, with previous/next
  /// buttons for navigation. Shows "Page X of Y" format.
  ///
  /// Best for: Mobile interfaces or when you want to save horizontal space.
  ///
  /// **Example:**
  /// ```
  /// [<] Page [5 ▼] of 20 [>]
  /// ```
  dropdown,

  /// Compact style - shows current/total pages with prev/next buttons.
  ///
  /// Displays a minimal format showing "X / Y" with only previous/next
  /// navigation buttons. Takes up the least amount of space.
  ///
  /// Best for: Mobile interfaces or when space is very limited.
  ///
  /// **Example:**
  /// ```
  /// [<] 5 / 20 [>]
  /// ```
  compact,
}
