/// Enum representing different pagination UI types
enum PaginatrixType {
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

extension PaginatrixTypeExtension on PaginatrixType {
  /// Display name for the pagination type
  String get displayName {
    switch (this) {
      case PaginatrixType.scroll:
        return 'Infinite Scroll';
      case PaginatrixType.pageSelection:
        return 'Page Selection';
      case PaginatrixType.loadMoreButton:
        return 'Load More Button';
      case PaginatrixType.cursor:
        return 'Cursor Based';
    }
  }

  /// Description of the pagination type
  String get description {
    switch (this) {
      case PaginatrixType.scroll:
        return 'Automatically loads more items as you scroll down';
      case PaginatrixType.pageSelection:
        return 'Select specific page numbers to navigate';
      case PaginatrixType.loadMoreButton:
        return 'Click a button to load more items';
      case PaginatrixType.cursor:
        return 'Uses cursors or tokens for pagination';
    }
  }
}
