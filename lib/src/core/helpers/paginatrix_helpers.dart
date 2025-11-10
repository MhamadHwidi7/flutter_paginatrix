library;

/// Paginatrix helper utilities
///
/// This file contains utility functions and helpers for pagination operations.
/// These helpers provide common functionality that can be reused across
/// the paginatrix library.

/// Calculates the total number of pages based on total items and items per page
///
/// [totalItems] - Total number of items
/// [itemsPerPage] - Number of items per page
///
/// Returns the total number of pages (rounded up)
int calculateTotalPages(int totalItems, int itemsPerPage) {
  if (itemsPerPage <= 0) return 0;
  return (totalItems / itemsPerPage).ceil();
}

/// Checks if there are more pages available
///
/// [currentPage] - Current page number (1-based)
/// [totalPages] - Total number of pages
///
/// Returns true if there are more pages, false otherwise
bool hasMorePages(int currentPage, int totalPages) {
  return currentPage < totalPages;
}

/// Calculates the start index for a given page
///
/// [page] - Page number (1-based)
/// [itemsPerPage] - Number of items per page
///
/// Returns the start index (0-based)
int calculateStartIndex(int page, int itemsPerPage) {
  return (page - 1) * itemsPerPage;
}

/// Calculates the end index for a given page
///
/// [page] - Page number (1-based)
/// [itemsPerPage] - Number of items per page
/// [totalItems] - Total number of items (optional, for bounds checking)
///
/// Returns the end index (exclusive, 0-based)
int calculateEndIndex(int page, int itemsPerPage, [int? totalItems]) {
  final endIndex = page * itemsPerPage;
  if (totalItems != null) {
    return endIndex > totalItems ? totalItems : endIndex;
  }
  return endIndex;
}

/// Validates pagination parameters
///
/// [page] - Page number to validate
/// [itemsPerPage] - Items per page to validate
/// [maxPageSize] - Maximum allowed page size
///
/// Returns true if parameters are valid, false otherwise
bool validatePaginationParams({
  required int page,
  required int itemsPerPage,
  int maxPageSize = 100,
}) {
  return page > 0 && itemsPerPage > 0 && itemsPerPage <= maxPageSize;
}

/// Clamps page number to valid range
///
/// [page] - Page number to clamp
/// [totalPages] - Total number of pages
///
/// Returns a valid page number within the range [1, totalPages]
int clampPage(int page, int totalPages) {
  if (page < 1) return 1;
  if (page > totalPages) return totalPages;
  return page;
}

/// Formats pagination info as a string
///
/// [currentPage] - Current page number
/// [totalPages] - Total number of pages
/// [totalItems] - Total number of items
///
/// Returns a formatted string like "Page 1 of 10 (100 items)"
String formatPaginationInfo({
  required int currentPage,
  required int totalPages,
  int? totalItems,
}) {
  final itemsInfo = totalItems != null ? ' ($totalItems items)' : '';
  return 'Page $currentPage of $totalPages$itemsInfo';
}
