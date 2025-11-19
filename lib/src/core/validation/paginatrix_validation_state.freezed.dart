// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginatrix_validation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatrixValidationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginatrixValidationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginatrixValidationState()';
  }
}

/// @nodoc
class $PaginatrixValidationStateCopyWith<$Res> {
  $PaginatrixValidationStateCopyWith(
      PaginatrixValidationState _, $Res Function(PaginatrixValidationState) __);
}

/// Adds pattern-matching-related methods to [PaginatrixValidationState].
extension PaginatrixValidationStatePatterns on PaginatrixValidationState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Validating() when validating != null:
        return validating(_that);
      case _Valid() when valid != null:
        return valid(_that);
      case _Invalid() when invalid != null:
        return invalid(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Validating():
        return validating(_that);
      case _Valid():
        return valid(_that);
      case _Invalid():
        return invalid(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Validating() when validating != null:
        return validating(_that);
      case _Valid() when valid != null:
        return valid(_that);
      case _Invalid() when invalid != null:
        return invalid(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? validating,
    TResult Function(PageMeta? meta, int? pageNumber, String? cursor,
            int? offset, int? limit)?
        valid,
    TResult Function(List<String> errors, String? errorCode,
            Map<String, dynamic>? context)?
        invalid,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Validating() when validating != null:
        return validating();
      case _Valid() when valid != null:
        return valid(_that.meta, _that.pageNumber, _that.cursor, _that.offset,
            _that.limit);
      case _Invalid() when invalid != null:
        return invalid(_that.errors, _that.errorCode, _that.context);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() validating,
    required TResult Function(PageMeta? meta, int? pageNumber, String? cursor,
            int? offset, int? limit)
        valid,
    required TResult Function(List<String> errors, String? errorCode,
            Map<String, dynamic>? context)
        invalid,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Validating():
        return validating();
      case _Valid():
        return valid(_that.meta, _that.pageNumber, _that.cursor, _that.offset,
            _that.limit);
      case _Invalid():
        return invalid(_that.errors, _that.errorCode, _that.context);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? validating,
    TResult? Function(PageMeta? meta, int? pageNumber, String? cursor,
            int? offset, int? limit)?
        valid,
    TResult? Function(List<String> errors, String? errorCode,
            Map<String, dynamic>? context)?
        invalid,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Validating() when validating != null:
        return validating();
      case _Valid() when valid != null:
        return valid(_that.meta, _that.pageNumber, _that.cursor, _that.offset,
            _that.limit);
      case _Invalid() when invalid != null:
        return invalid(_that.errors, _that.errorCode, _that.context);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements PaginatrixValidationState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginatrixValidationState.initial()';
  }
}

/// @nodoc

class _Validating implements PaginatrixValidationState {
  const _Validating();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Validating);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginatrixValidationState.validating()';
  }
}

/// @nodoc

class _Valid implements PaginatrixValidationState {
  const _Valid(
      {this.meta, this.pageNumber, this.cursor, this.offset, this.limit});

  /// Validated metadata (if applicable)
  final PageMeta? meta;

  /// Validated page number (if applicable)
  final int? pageNumber;

  /// Validated cursor (if applicable)
  final String? cursor;

  /// Validated offset (if applicable)
  final int? offset;

  /// Validated limit (if applicable)
  final int? limit;

  /// Create a copy of PaginatrixValidationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ValidCopyWith<_Valid> get copyWith =>
      __$ValidCopyWithImpl<_Valid>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Valid &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, meta, pageNumber, cursor, offset, limit);

  @override
  String toString() {
    return 'PaginatrixValidationState.valid(meta: $meta, pageNumber: $pageNumber, cursor: $cursor, offset: $offset, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$ValidCopyWith<$Res>
    implements $PaginatrixValidationStateCopyWith<$Res> {
  factory _$ValidCopyWith(_Valid value, $Res Function(_Valid) _then) =
      __$ValidCopyWithImpl;
  @useResult
  $Res call(
      {PageMeta? meta,
      int? pageNumber,
      String? cursor,
      int? offset,
      int? limit});

  $PageMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$ValidCopyWithImpl<$Res> implements _$ValidCopyWith<$Res> {
  __$ValidCopyWithImpl(this._self, this._then);

  final _Valid _self;
  final $Res Function(_Valid) _then;

  /// Create a copy of PaginatrixValidationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? meta = freezed,
    Object? pageNumber = freezed,
    Object? cursor = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
  }) {
    return _then(_Valid(
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      cursor: freezed == cursor
          ? _self.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of PaginatrixValidationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
      return null;
    }

    return $PageMetaCopyWith<$Res>(_self.meta!, (value) {
      return _then(_self.copyWith(meta: value));
    });
  }
}

/// @nodoc

class _Invalid implements PaginatrixValidationState {
  const _Invalid(
      {required final List<String> errors,
      this.errorCode,
      final Map<String, dynamic>? context})
      : _errors = errors,
        _context = context;

  /// List of validation error messages
  final List<String> _errors;

  /// List of validation error messages
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  /// Validation error code for programmatic handling
  final String? errorCode;

  /// Additional context about the validation failure
  final Map<String, dynamic>? _context;

  /// Additional context about the validation failure
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of PaginatrixValidationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvalidCopyWith<_Invalid> get copyWith =>
      __$InvalidCopyWithImpl<_Invalid>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Invalid &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._context, _context));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_errors),
      errorCode,
      const DeepCollectionEquality().hash(_context));

  @override
  String toString() {
    return 'PaginatrixValidationState.invalid(errors: $errors, errorCode: $errorCode, context: $context)';
  }
}

/// @nodoc
abstract mixin class _$InvalidCopyWith<$Res>
    implements $PaginatrixValidationStateCopyWith<$Res> {
  factory _$InvalidCopyWith(_Invalid value, $Res Function(_Invalid) _then) =
      __$InvalidCopyWithImpl;
  @useResult
  $Res call(
      {List<String> errors, String? errorCode, Map<String, dynamic>? context});
}

/// @nodoc
class __$InvalidCopyWithImpl<$Res> implements _$InvalidCopyWith<$Res> {
  __$InvalidCopyWithImpl(this._self, this._then);

  final _Invalid _self;
  final $Res Function(_Invalid) _then;

  /// Create a copy of PaginatrixValidationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? errors = null,
    Object? errorCode = freezed,
    Object? context = freezed,
  }) {
    return _then(_Invalid(
      errors: null == errors
          ? _self._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _self._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
