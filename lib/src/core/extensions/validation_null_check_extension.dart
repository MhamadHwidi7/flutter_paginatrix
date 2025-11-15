library;

/// Extension methods for null-safe validation operations
///
/// This extension provides clean, readable methods for handling null checks
/// in validation logic, reducing boilerplate and improving code maintainability.
///
/// ## Usage
///
/// ```dart
/// // Basic null check with early return
/// meta.requireNotNull(
///   onNull: () => _emitInvalid(
///     [PaginatrixValidationErrorMessages.missingMeta],
///     PaginatrixValidationErrorCodes.missingMeta,
///   ),
/// )?.someMethod();
///
/// // Null check with custom return value
/// final result = page.requireNotNullOr(
///   onNull: () {
///     _emitInvalid(...);
///     return null;
///   },
/// );
///
/// // String null/empty check
/// path.requireNotEmpty(
///   onEmpty: () => _emitInvalid(...),
/// )?.split('.');
/// ```
extension ValidationNullCheckExtension<T> on T? {
  /// Requires the value to be non-null, executing [onNull] callback if null
  ///
  /// Returns the non-null value if present, otherwise executes [onNull] and
  /// returns null. This is useful for early returns in validation methods.
  ///
  /// **Parameters:**
  /// - [onNull] - Callback to execute when value is null
  ///
  /// **Returns:** The non-null value, or null if value was null
  ///
  /// **Example:**
  /// ```dart
  /// final meta = pageMeta.requireNotNull(
  ///   onNull: () => _emitInvalid(
  ///     [PaginatrixValidationErrorMessages.missingMeta],
  ///     PaginatrixValidationErrorCodes.missingMeta,
  ///   ),
  /// );
  /// if (meta == null) return null; // Early return after validation
  /// // Use meta safely here
  /// ```
  T? requireNotNull(void Function() onNull) {
    if (this == null) {
      onNull();
      return null;
    }
    return this;
  }

  /// Requires the value to be non-null, returning [defaultValue] if null
  ///
  /// Executes [onNull] callback if value is null, then returns [defaultValue].
  /// This is useful when you need a specific return value on null.
  ///
  /// **Parameters:**
  /// - [onNull] - Callback to execute when value is null
  /// - [defaultValue] - Value to return if null (defaults to null)
  ///
  /// **Returns:** The non-null value, or [defaultValue] if value was null
  ///
  /// **Example:**
  /// ```dart
  /// final page = pageNumber.requireNotNullOr(
  ///   onNull: () => _emitInvalid(...),
  ///   defaultValue: null,
  /// );
  /// ```
  R requireNotNullOr<R>({
    required void Function() onNull,
    required R defaultValue,
  }) {
    if (this == null) {
      onNull();
      return defaultValue;
    }
    return this as R;
  }

  /// Executes [callback] only if the value is not null
  ///
  /// This is a convenience method for null-safe operations.
  ///
  /// **Parameters:**
  /// - [callback] - Function to execute with the non-null value
  ///
  /// **Returns:** The result of [callback], or null if value was null
  ///
  /// **Example:**
  /// ```dart
  /// final result = meta.ifNotNull((m) => m.page);
  /// ```
  R? ifNotNull<R>(R Function(T) callback) {
    if (this == null) return null;
    return callback(this as T);
  }
}

/// Extension methods for string validation operations
///
/// Provides specialized null and empty checks for strings.
extension ValidationStringExtension on String? {
  /// Requires the string to be non-null and non-empty
  ///
  /// Executes [onEmpty] callback if string is null or empty, then returns null.
  /// This is useful for validating required string parameters.
  ///
  /// **Parameters:**
  /// - [onEmpty] - Callback to execute when string is null or empty
  ///
  /// **Returns:** The non-empty string, or null if string was null or empty
  ///
  /// **Example:**
  /// ```dart
  /// final path = pathString.requireNotEmpty(
  ///   onEmpty: () => _emitInvalid(
  ///     [PaginatrixValidationErrorMessages.emptyPath],
  ///     PaginatrixValidationErrorCodes.emptyPath,
  ///   ),
  /// );
  /// if (path == null) return false; // Early return after validation
  /// ```
  String? requireNotEmpty(void Function() onEmpty) {
    if (this == null || this!.isEmpty) {
      onEmpty();
      return null;
    }
    return this;
  }

  /// Checks if the string is null or empty
  ///
  /// **Returns:** True if string is null or empty, false otherwise
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Checks if the string is not null and not empty
  ///
  /// **Returns:** True if string is not null and not empty, false otherwise
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}

/// Extension methods for nullable integer validation
///
/// Provides specialized validation for nullable integers.
extension ValidationIntExtension on int? {
  /// Requires the integer to be non-null and positive (>= 1)
  ///
  /// Executes [onInvalid] callback if integer is null or less than 1.
  ///
  /// **Parameters:**
  /// - [onNull] - Callback to execute when integer is null
  /// - [onInvalid] - Callback to execute when integer is less than 1
  ///
  /// **Returns:** The valid positive integer, or null if invalid
  ///
  /// **Example:**
  /// ```dart
  /// final page = pageNumber.requirePositive(
  ///   onNull: () => _emitInvalid(...),
  ///   onInvalid: (value) => _emitInvalid(...),
  /// );
  /// ```
  int? requirePositive({
    required void Function() onNull,
    required void Function(int) onInvalid,
  }) {
    if (this == null) {
      onNull();
      return null;
    }
    if (this! < 1) {
      onInvalid(this!);
      return null;
    }
    return this;
  }
}

