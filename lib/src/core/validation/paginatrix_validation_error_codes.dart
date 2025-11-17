/// Constants for pagination validation error codes.
///
/// This class provides standardized error codes for all validation scenarios,
/// enabling programmatic error handling and internationalization.
///
/// ## Usage
///
/// ```dart
/// if (errorCode == PaginatrixValidationErrorCodes.missingMeta) {
///   // Handle missing metadata
/// }
/// ```
class PaginatrixValidationErrorCodes {
  PaginatrixValidationErrorCodes._(); // Private constructor to prevent instantiation

  // Meta validation error codes
  /// Error code when metadata is missing
  static const String missingMeta = 'MISSING_META';

  /// Error code when pagination type cannot be determined
  static const String unknownPaginationType = 'UNKNOWN_PAGINATION_TYPE';

  /// Error code when metadata is null
  static const String nullMeta = 'NULL_META';

  // Page number validation error codes
  /// Error code when page number is null
  static const String nullPage = 'NULL_PAGE';

  /// Error code when page number is null in metadata
  static const String nullPageInMeta = 'NULL_PAGE_IN_META';

  /// Error code when page number is invalid
  static const String invalidPage = 'INVALID_PAGE';

  /// Error code when page number is invalid in metadata
  static const String invalidPageInMeta = 'INVALID_PAGE_IN_META';

  /// Error code when page number is out of bounds
  static const String pageOutOfBounds = 'PAGE_OUT_OF_BOUNDS';

  /// Error code when no more pages are available
  static const String noMorePages = 'NO_MORE_PAGES';

  // Cursor validation error codes
  /// Error code when next cursor is not available
  static const String noNextCursor = 'NO_NEXT_CURSOR';

  // Offset/Limit validation error codes
  /// Error code when offset or limit is null
  static const String nullOffsetOrLimit = 'NULL_OFFSET_OR_LIMIT';

  /// Error code when offset or limit is invalid
  static const String invalidOffsetOrLimit = 'INVALID_OFFSET_OR_LIMIT';

  /// Error code when no more items are available
  static const String noMoreItems = 'NO_MORE_ITEMS';

  // Path validation error codes
  /// Error code when path is empty
  static const String emptyPath = 'EMPTY_PATH';

  /// Error code when path contains invalid segments
  static const String invalidPathSegments = 'INVALID_PATH_SEGMENTS';

  /// Error code when path contains invalid characters
  static const String invalidPathCharacters = 'INVALID_PATH_CHARACTERS';
}


