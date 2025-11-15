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
    emit(const PaginatrixValidationState.validating());

    // First page doesn't require existing metadata
    if (operation == PaginatrixLoadType.first) {
      emit(const PaginatrixValidationState.valid());
      return true;
    }

    // Next and refresh require existing metadata
    if (meta == null) {
      final errorMessage = operation == PaginatrixLoadType.next
          ? PaginatrixValidationErrorMessages.cannotAppendWithoutMeta
          : PaginatrixValidationErrorMessages.cannotRefreshWithoutMeta;

      emit(PaginatrixValidationState.invalid(
        errors: [errorMessage],
        errorCode: PaginatrixValidationErrorCodes.missingMeta,
        context: {'operation': operation.toString()},
      ));
      return false;
    }

    emit(PaginatrixValidationState.valid(meta: meta));
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
    emit(const PaginatrixValidationState.validating());

    if (page == null) {
      if (allowNull) {
        emit(const PaginatrixValidationState.valid());
        return true;
      }
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.nullPage],
        errorCode: PaginatrixValidationErrorCodes.nullPage,
      ));
      return false;
    }

    if (page < 1) {
      emit(PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.invalidPage(page)],
        errorCode: PaginatrixValidationErrorCodes.invalidPage,
        context: {'page': page},
      ));
      return false;
    }

    // Check bounds if metadata is provided
    if (meta != null && meta.lastPage != null && page > meta.lastPage!) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.pageOutOfBounds(
              page, meta.lastPage!),
        ],
        errorCode: PaginatrixValidationErrorCodes.pageOutOfBounds,
        context: {'page': page, 'lastPage': meta.lastPage},
      ));
      return false;
    }

    emit(PaginatrixValidationState.valid(pageNumber: page));
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
    emit(const PaginatrixValidationState.validating());

    if (meta == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.missingMeta],
        errorCode: PaginatrixValidationErrorCodes.missingMeta,
      ));
      return null;
    }

    final currentPage = meta.page;
    if (currentPage == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.nullPageInMeta],
        errorCode: PaginatrixValidationErrorCodes.nullPageInMeta,
      ));
      return null;
    }

    if (currentPage < 1) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.invalidPageInMeta(currentPage),
        ],
        errorCode: PaginatrixValidationErrorCodes.invalidPageInMeta,
        context: {'currentPage': currentPage},
      ));
      return null;
    }

    final nextPage = currentPage + 1;

    // Check bounds
    if (meta.lastPage != null && nextPage > meta.lastPage!) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.noMorePages(
              nextPage, meta.lastPage!),
        ],
        errorCode: PaginatrixValidationErrorCodes.noMorePages,
        context: {'nextPage': nextPage, 'lastPage': meta.lastPage},
      ));
      return null;
    }

    emit(PaginatrixValidationState.valid(
      meta: meta,
      pageNumber: nextPage,
    ));
    return nextPage;
  }

  /// Validates cursor for cursor-based pagination
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** The validated next cursor, or null if invalid
  String? validateNextCursor(PageMeta? meta) {
    emit(const PaginatrixValidationState.validating());

    if (meta == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.missingMeta],
        errorCode: PaginatrixValidationErrorCodes.missingMeta,
      ));
      return null;
    }

    final nextCursor = meta.nextCursor;
    if (nextCursor == null || nextCursor.isEmpty) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.noNextCursor],
        errorCode: PaginatrixValidationErrorCodes.noNextCursor,
      ));
      return null;
    }

    emit(PaginatrixValidationState.valid(
      meta: meta,
      cursor: nextCursor,
    ));
    return nextCursor;
  }

  /// Validates offset and limit for offset-based pagination
  ///
  /// **Parameters:**
  /// - [meta] - Current pagination metadata
  ///
  /// **Returns:** A tuple of (offset, limit) if valid, null otherwise
  ({int offset, int limit})? validateNextOffset(PageMeta? meta) {
    emit(const PaginatrixValidationState.validating());

    if (meta == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.missingMeta],
        errorCode: PaginatrixValidationErrorCodes.missingMeta,
      ));
      return null;
    }

    final currentOffset = meta.offset;
    final limit = meta.limit;

    if (currentOffset == null || limit == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.nullOffsetOrLimit],
        errorCode: PaginatrixValidationErrorCodes.nullOffsetOrLimit,
      ));
      return null;
    }

    if (currentOffset < 0 || limit < 1) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.invalidOffsetOrLimit(
            currentOffset,
            limit,
          ),
        ],
        errorCode: PaginatrixValidationErrorCodes.invalidOffsetOrLimit,
        context: {'offset': currentOffset, 'limit': limit},
      ));
      return null;
    }

    final nextOffset = currentOffset + limit;

    // Check bounds if total is provided
    if (meta.total != null && nextOffset >= meta.total!) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.noMoreItems(
              nextOffset, meta.total!),
        ],
        errorCode: PaginatrixValidationErrorCodes.noMoreItems,
        context: {'nextOffset': nextOffset, 'total': meta.total},
      ));
      return null;
    }

    emit(PaginatrixValidationState.valid(
      meta: meta,
      offset: nextOffset,
      limit: limit,
    ));
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
    emit(const PaginatrixValidationState.validating());

    if (path == null || path.isEmpty) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.emptyPath],
        errorCode: PaginatrixValidationErrorCodes.emptyPath,
      ));
      return false;
    }

    // Check for empty segments (e.g., "a..b" or ".a" or "a.")
    final segments = path.split('.');
    if (segments.any((segment) => segment.isEmpty)) {
      emit(PaginatrixValidationState.invalid(
        errors: [
          PaginatrixValidationErrorMessages.invalidPathSegments(path),
        ],
        errorCode: PaginatrixValidationErrorCodes.invalidPathSegments,
        context: {'path': path},
      ));
      return false;
    }

    // Check for valid characters (alphanumeric, underscore, hyphen)
    for (final segment in segments) {
      if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(segment)) {
        emit(PaginatrixValidationState.invalid(
          errors: [
            PaginatrixValidationErrorMessages.invalidPathCharacters(
                segment, path),
          ],
          errorCode: PaginatrixValidationErrorCodes.invalidPathCharacters,
          context: {'path': path, 'segment': segment},
        ));
        return false;
      }
    }

    emit(const PaginatrixValidationState.valid());
    return true;
  }

  /// Validates pagination type can be determined from metadata
  ///
  /// **Parameters:**
  /// - [meta] - The metadata to check
  ///
  /// **Returns:** The determined pagination type, or null if cannot be determined
  PaginatrixType? validatePaginationType(PageMeta? meta) {
    emit(const PaginatrixValidationState.validating());

    if (meta == null) {
      emit(const PaginatrixValidationState.invalid(
        errors: [PaginatrixValidationErrorMessages.nullMeta],
        errorCode: PaginatrixValidationErrorCodes.nullMeta,
      ));
      return null;
    }

    if (meta.page != null) {
      emit(PaginatrixValidationState.valid(meta: meta));
      return PaginatrixType.pageBased;
    }

    if (meta.nextCursor != null || meta.previousCursor != null) {
      emit(PaginatrixValidationState.valid(meta: meta));
      return PaginatrixType.cursorBased;
    }

    if (meta.offset != null && meta.limit != null) {
      emit(PaginatrixValidationState.valid(meta: meta));
      return PaginatrixType.offsetBased;
    }

    emit(PaginatrixValidationState.invalid(
      errors: const [
        PaginatrixValidationErrorMessages.unknownPaginationType,
      ],
      errorCode: PaginatrixValidationErrorCodes.unknownPaginationType,
      context: {
        'hasPage': meta.page != null,
        'hasCursor': (meta.nextCursor != null || meta.previousCursor != null),
        'hasOffset': (meta.offset != null && meta.limit != null),
      },
    ));
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
