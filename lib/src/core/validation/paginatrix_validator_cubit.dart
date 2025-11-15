import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Cubit for managing pagination validation logic and UI state
///
/// This cubit centralizes all validation logic for pagination operations,
/// providing a reactive way to validate pagination metadata, page numbers,
/// paths, and other pagination-related data.
///
/// ## Usage
///
/// ```dart
/// final validator = PaginatrixValidatorCubit();
///
/// // Validate metadata
/// validator.validateMetaForOperation(
///   meta: currentMeta,
///   operation: PaginatrixLoadType.next,
/// );
///
/// // Listen to validation state
/// BlocBuilder<PaginatrixValidatorCubit, PaginatrixValidationState>(
///   bloc: validator,
///   builder: (context, state) {
///     return state.when(
///       initial: () => const SizedBox(),
///       validating: () => const CircularProgressIndicator(),
///       valid: (meta, pageNumber, cursor, offset, limit) {
///         return Text('Valid: Page $pageNumber');
///       },
///       invalid: (errors, errorCode, context) {
///         return Text('Invalid: ${errors.join(", ")}');
///       },
///     );
///   },
/// )
/// ```
class PaginatrixValidatorCubit extends Cubit<PaginatrixValidationState> {
  /// Creates a new PaginatrixValidatorCubit
  PaginatrixValidatorCubit() : super(const PaginatrixValidationState.initial());

  // Helper methods to reduce code duplication in validation methods

  /// Emits validating state
  void _emitValidating() {
    emit(const PaginatrixValidationState.validating());
  }

  /// Emits valid state with optional parameters
  void _emitValid({
    PageMeta? meta,
    int? pageNumber,
    String? cursor,
    int? offset,
    int? limit,
  }) {
    emit(PaginatrixValidationState.valid(
      meta: meta,
      pageNumber: pageNumber,
      cursor: cursor,
      offset: offset,
      limit: limit,
    ));
  }

  /// Emits invalid state with errors and error code
  void _emitInvalid(
    List<String> errors,
    String errorCode, [
    Map<String, dynamic>? context,
  ]) {
    emit(PaginatrixValidationState.invalid(
      errors: errors,
      errorCode: errorCode,
      context: context ?? {},
    ));
  }

  /// Validates metadata for a specific operation
  ///
  /// Checks if metadata exists and is valid for the requested operation.
  ///
  /// **Parameters:**
  /// - [meta] - The pagination metadata to validate
  /// - [operation] - The type of operation (first, next, refresh)
  ///
  /// **Returns:** True if valid, false otherwise
  bool validateMetaForOperation({
    PageMeta? meta,
    required PaginatrixLoadType operation,
  }) {
    _emitValidating();

    // First page doesn't require existing metadata
    if (operation == PaginatrixLoadType.first) {
      _emitValid();
      return true;
    }

    // Next and refresh require existing metadata
    final validatedMeta = meta.requireNotNull(() {
      final errorMessage = operation == PaginatrixLoadType.next
          ? PaginatrixValidationErrorMessages.cannotAppendWithoutMeta
          : PaginatrixValidationErrorMessages.cannotRefreshWithoutMeta;

      _emitInvalid(
        [errorMessage],
        PaginatrixValidationErrorCodes.missingMeta,
        {'operation': operation.toString()},
      );
    });
    if (validatedMeta == null) return false;

    _emitValid(meta: validatedMeta);
    return true;
  }

  /// Validates a page number
  ///
  /// Checks if the page number is valid (positive integer, within bounds).
  ///
  /// **Parameters:**
  /// - [page] - The page number to validate
  /// - [meta] - Optional metadata for bounds checking
  /// - [allowNull] - Whether null is considered valid
  ///
  /// **Returns:** True if valid, false otherwise
  bool validatePageNumber({
    int? page,
    PageMeta? meta,
    bool allowNull = false,
  }) {
    _emitValidating();

    if (page == null) {
      if (allowNull) {
        _emitValid();
        return true;
      }
      _emitInvalid(
        [PaginatrixValidationErrorMessages.nullPage],
        PaginatrixValidationErrorCodes.nullPage,
      );
      return false;
    }

    if (page < 1) {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.invalidPage(page)],
        PaginatrixValidationErrorCodes.invalidPage,
        {'page': page},
      );
      return false;
    }

    // Check bounds if metadata is provided
    final lastPage = meta?.lastPage;
    if (meta != null && lastPage != null && page > lastPage) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.pageOutOfBounds(page, lastPage),
        ],
        PaginatrixValidationErrorCodes.pageOutOfBounds,
        {'page': page, 'lastPage': lastPage},
      );
      return false;
    }

    _emitValid(pageNumber: page);
    return true;
  }

  /// Validates next page number from metadata
  ///
  /// Calculates and validates the next page number based on current metadata.
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** The validated next page number, or null if invalid
  int? validateNextPageNumber(PageMeta? meta) {
    _emitValidating();

    final validatedMeta = meta.requireNotNull(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.missingMeta],
        PaginatrixValidationErrorCodes.missingMeta,
      );
    });
    if (validatedMeta == null) return null;

    final currentPage = validatedMeta.page.requireNotNull(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.nullPageInMeta],
        PaginatrixValidationErrorCodes.nullPageInMeta,
      );
    });
    if (currentPage == null) return null;

    if (currentPage < 1) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.invalidPageInMeta(currentPage),
        ],
        PaginatrixValidationErrorCodes.invalidPageInMeta,
        {'currentPage': currentPage},
      );
      return null;
    }

    final nextPage = currentPage + 1;

    // Check bounds
    final lastPage = validatedMeta.lastPage;
    if (lastPage != null && nextPage > lastPage) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.noMorePages(nextPage, lastPage),
        ],
        PaginatrixValidationErrorCodes.noMorePages,
        {'nextPage': nextPage, 'lastPage': lastPage},
      );
      return null;
    }

    _emitValid(
      meta: validatedMeta,
      pageNumber: nextPage,
    );
    return nextPage;
  }

  /// Validates cursor for cursor-based pagination
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** The validated next cursor, or null if invalid
  String? validateNextCursor(PageMeta? meta) {
    _emitValidating();

    final validatedMeta = meta.requireNotNull(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.missingMeta],
        PaginatrixValidationErrorCodes.missingMeta,
      );
    });
    if (validatedMeta == null) return null;

    final nextCursor = validatedMeta.nextCursor.requireNotEmpty(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.noNextCursor],
        PaginatrixValidationErrorCodes.noNextCursor,
      );
    });
    if (nextCursor == null) return null;

    _emitValid(
      meta: validatedMeta,
      cursor: nextCursor,
    );
    return nextCursor;
  }

  /// Validates offset and limit for offset-based pagination
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** A tuple of (offset, limit) if valid, null otherwise
  ({int offset, int limit})? validateNextOffset(PageMeta? meta) {
    _emitValidating();

    final validatedMeta = meta.requireNotNull(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.missingMeta],
        PaginatrixValidationErrorCodes.missingMeta,
      );
    });
    if (validatedMeta == null) return null;

    final currentOffset = validatedMeta.offset;
    final limit = validatedMeta.limit;

    if (currentOffset == null || limit == null) {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.nullOffsetOrLimit],
        PaginatrixValidationErrorCodes.nullOffsetOrLimit,
      );
      return null;
    }

    if (currentOffset < 0 || limit < 1) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.invalidOffsetOrLimit(
            currentOffset,
            limit,
          ),
        ],
        PaginatrixValidationErrorCodes.invalidOffsetOrLimit,
        {'offset': currentOffset, 'limit': limit},
      );
      return null;
    }

    final nextOffset = currentOffset + limit;

    // Check bounds if total is provided
    final total = validatedMeta.total;
    if (total != null && nextOffset >= total) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.noMoreItems(nextOffset, total),
        ],
        PaginatrixValidationErrorCodes.noMoreItems,
        {'nextOffset': nextOffset, 'total': total},
      );
      return null;
    }

    _emitValid(
      meta: validatedMeta,
      offset: nextOffset,
      limit: limit,
    );
    return (offset: nextOffset, limit: limit);
  }

  /// Validates pagination path
  ///
  /// Checks if a dot-notation path is well-formed.
  ///
  /// **Parameters:**
  /// - [path] - The path to validate (e.g., "data.items", "meta.page")
  ///
  /// **Returns:** True if valid, false otherwise
  bool validatePath(String? path) {
    _emitValidating();

    final validatedPath = path.requireNotEmpty(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.emptyPath],
        PaginatrixValidationErrorCodes.emptyPath,
      );
    });
    if (validatedPath == null) return false;

    // Check for empty segments (e.g., "a..b" or ".a" or "a.")
    final segments = validatedPath.split('.');
    if (segments.any((segment) => segment.isEmpty)) {
      _emitInvalid(
        [
          PaginatrixValidationErrorMessages.invalidPathSegments(validatedPath),
        ],
        PaginatrixValidationErrorCodes.invalidPathSegments,
        {'path': validatedPath},
      );
      return false;
    }

    // Check for valid characters (alphanumeric, underscore, hyphen)
    for (final segment in segments) {
      if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(segment)) {
        _emitInvalid(
          [
            PaginatrixValidationErrorMessages.invalidPathCharacters(
                segment, validatedPath),
          ],
          PaginatrixValidationErrorCodes.invalidPathCharacters,
          {'path': validatedPath, 'segment': segment},
        );
        return false;
      }
    }

    _emitValid();
    return true;
  }

  /// Validates pagination type can be determined from metadata
  ///
  /// **Parameters:**
  /// - [meta] - The metadata to check
  ///
  /// **Returns:** The determined pagination type, or null if cannot be determined
  PaginatrixType? validatePaginationType(PageMeta? meta) {
    _emitValidating();

    final validatedMeta = meta.requireNotNull(() {
      _emitInvalid(
        [PaginatrixValidationErrorMessages.nullMeta],
        PaginatrixValidationErrorCodes.nullMeta,
      );
    });
    if (validatedMeta == null) return null;

    if (validatedMeta.page != null) {
      _emitValid(meta: validatedMeta);
      return PaginatrixType.pageBased;
    }

    if (validatedMeta.nextCursor != null ||
        validatedMeta.previousCursor != null) {
      _emitValid(meta: validatedMeta);
      return PaginatrixType.cursorBased;
    }

    if (validatedMeta.offset != null && validatedMeta.limit != null) {
      _emitValid(meta: validatedMeta);
      return PaginatrixType.offsetBased;
    }

    _emitInvalid(
      const [
        PaginatrixValidationErrorMessages.unknownPaginationType,
      ],
      PaginatrixValidationErrorCodes.unknownPaginationType,
      {
        'hasPage': validatedMeta.page != null,
        'hasCursor': (validatedMeta.nextCursor != null ||
            validatedMeta.previousCursor != null),
        'hasOffset':
            (validatedMeta.offset != null && validatedMeta.limit != null),
      },
    );
    return null;
  }

  /// Resets validation state to initial
  void reset() {
    emit(const PaginatrixValidationState.initial());
  }
}

/// Enum representing different pagination types
enum PaginatrixType {
  /// Page-based pagination (page 1, 2, 3, etc.)
  pageBased,

  /// Cursor-based pagination (using cursor strings)
  cursorBased,

  /// Offset-based pagination (using offset and limit)
  offsetBased,
}
