/// Constants for pagination validation error messages.
///
/// This class provides standardized error messages for all validation scenarios,
/// ensuring consistency across the validation system.
///
/// ## Usage
///
/// ```dart
/// throw ValidationException(PaginatrixValidationErrorMessages.missingMeta);
/// ```
class PaginatrixValidationErrorMessages {
  PaginatrixValidationErrorMessages._(); // Private constructor to prevent instantiation

  // Meta validation errors
  /// Error message when metadata is missing for an operation
  static const String missingMeta =
      'Cannot load next page: no metadata available. Load first page before attempting to load next page.';

  /// Error message when trying to append without metadata
  static const String cannotAppendWithoutMeta =
      'Cannot append without existing metadata. Load first page first.';

  /// Error message when trying to refresh without metadata
  static const String cannotRefreshWithoutMeta =
      'Cannot refresh without existing metadata. Load first page first.';

  /// Error message when pagination type cannot be determined
  static const String unknownPaginationType =
      'Cannot determine pagination type from metadata. Metadata must contain page, nextCursor, or offset/limit.';

  /// Error message when metadata is null
  static const String nullMeta =
      'Cannot determine pagination type: metadata is null';

  // Page number validation errors
  /// Error message when page number is null
  static const String nullPage = 'Page number cannot be null';

  /// Error message when page number is null in metadata
  static const String nullPageInMeta =
      'Cannot load next page: page number is null in metadata. This may indicate cursor-based or offset-based pagination. Use appropriate method for the pagination type.';

  /// Error message for invalid page number
  static String invalidPage(int page) =>
      'Invalid page number: $page. Expected positive integer, got: $page';

  /// Error message for invalid page number in metadata
  static String invalidPageInMeta(int currentPage) =>
      'Cannot load next page: invalid page number in metadata. Expected positive integer, got: $currentPage';

  /// Error message when page exceeds total pages
  static String pageOutOfBounds(int page, int lastPage) =>
      'Page number $page exceeds total pages ($lastPage)';

  /// Error message when next page exceeds total pages
  static String noMorePages(int nextPage, int lastPage) =>
      'Next page $nextPage exceeds total pages ($lastPage). No more pages available.';

  // Cursor validation errors
  /// Error message when next cursor is null or empty
  static const String noNextCursor =
      'Cannot load next page: next cursor is null or empty. No more pages available.';

  // Offset/Limit validation errors
  /// Error message when offset or limit is null
  static const String nullOffsetOrLimit =
      'Cannot load next page: offset or limit is null in metadata. This may indicate page-based or cursor-based pagination. Use appropriate method for the pagination type.';

  /// Error message for invalid offset or limit
  static String invalidOffsetOrLimit(int offset, int limit) =>
      'Invalid offset or limit: offset=$offset, limit=$limit. Offset must be >= 0 and limit must be > 0.';

  /// Error message when next offset exceeds total items
  static String noMoreItems(int nextOffset, int total) =>
      'Next offset $nextOffset exceeds total items ($total). No more items available.';

  // Path validation errors
  /// Error message when path is null or empty
  static const String emptyPath = 'Path cannot be null or empty';

  /// Error message when path contains empty segments
  static String invalidPathSegments(String path) =>
      'Invalid path: "$path". Path contains empty segments. Use dot notation like "data.items" or "meta.page".';

  /// Error message when path segment contains invalid characters
  static String invalidPathCharacters(String segment, String path) =>
      'Invalid path segment: "$segment" in path "$path". Segments must contain only alphanumeric characters, underscores, or hyphens.';
}


