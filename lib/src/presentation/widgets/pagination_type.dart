/// Enum representing different pagination UI types
enum PaginationType {
  /// Scroll-based pagination (infinite scroll)
  /// Automatically loads more items as user scrolls
  scroll,

  /// Page selection pagination (traditional pagination)
  /// User selects specific page numbers
  pageSelection,

  /// Load more button pagination
  /// User clicks a button to load more items
  loadMoreButton,

  /// Cursor-based pagination
  /// Uses cursors/tokens for pagination
  cursor,
}

extension PaginationTypeExtension on PaginationType {
  /// Display name for the pagination type
  String get displayName {
    switch (this) {
      case PaginationType.scroll:
        return 'Infinite Scroll';
      case PaginationType.pageSelection:
        return 'Page Selection';
      case PaginationType.loadMoreButton:
        return 'Load More Button';
      case PaginationType.cursor:
        return 'Cursor Based';
    }
  }

  /// Description of the pagination type
  String get description {
    switch (this) {
      case PaginationType.scroll:
        return 'Automatically loads more items as you scroll down';
      case PaginationType.pageSelection:
        return 'Select specific page numbers to navigate';
      case PaginationType.loadMoreButton:
        return 'Click a button to load more items';
      case PaginationType.cursor:
        return 'Uses cursors or tokens for pagination';
    }
  }
}

