// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginatrix_validation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginatrixValidationState {
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatrixValidationStateCopyWith<$Res> {
  factory $PaginatrixValidationStateCopyWith(PaginatrixValidationState value,
          $Res Function(PaginatrixValidationState) then) =
      _$PaginatrixValidationStateCopyWithImpl<$Res, PaginatrixValidationState>;
}

/// @nodoc
class _$PaginatrixValidationStateCopyWithImpl<$Res,
        $Val extends PaginatrixValidationState>
    implements $PaginatrixValidationStateCopyWith<$Res> {
  _$PaginatrixValidationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$PaginatrixValidationStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'PaginatrixValidationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
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
    return initial();
  }

  @override
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
    return initial?.call();
  }

  @override
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
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements PaginatrixValidationState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$ValidatingImplCopyWith<$Res> {
  factory _$$ValidatingImplCopyWith(
          _$ValidatingImpl value, $Res Function(_$ValidatingImpl) then) =
      __$$ValidatingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ValidatingImplCopyWithImpl<$Res>
    extends _$PaginatrixValidationStateCopyWithImpl<$Res, _$ValidatingImpl>
    implements _$$ValidatingImplCopyWith<$Res> {
  __$$ValidatingImplCopyWithImpl(
      _$ValidatingImpl _value, $Res Function(_$ValidatingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ValidatingImpl implements _Validating {
  const _$ValidatingImpl();

  @override
  String toString() {
    return 'PaginatrixValidationState.validating()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ValidatingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
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
    return validating();
  }

  @override
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
    return validating?.call();
  }

  @override
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
    if (validating != null) {
      return validating();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) {
    return validating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) {
    return validating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    if (validating != null) {
      return validating(this);
    }
    return orElse();
  }
}

abstract class _Validating implements PaginatrixValidationState {
  const factory _Validating() = _$ValidatingImpl;
}

/// @nodoc
abstract class _$$ValidImplCopyWith<$Res> {
  factory _$$ValidImplCopyWith(
          _$ValidImpl value, $Res Function(_$ValidImpl) then) =
      __$$ValidImplCopyWithImpl<$Res>;
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
class __$$ValidImplCopyWithImpl<$Res>
    extends _$PaginatrixValidationStateCopyWithImpl<$Res, _$ValidImpl>
    implements _$$ValidImplCopyWith<$Res> {
  __$$ValidImplCopyWithImpl(
      _$ValidImpl _value, $Res Function(_$ValidImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = freezed,
    Object? pageNumber = freezed,
    Object? cursor = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
  }) {
    return _then(_$ValidImpl(
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PageMeta?,
      pageNumber: freezed == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      cursor: freezed == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $PageMetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $PageMetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value));
    });
  }
}

/// @nodoc

class _$ValidImpl implements _Valid {
  const _$ValidImpl(
      {this.meta, this.pageNumber, this.cursor, this.offset, this.limit});

  /// Validated metadata (if applicable)
  @override
  final PageMeta? meta;

  /// Validated page number (if applicable)
  @override
  final int? pageNumber;

  /// Validated cursor (if applicable)
  @override
  final String? cursor;

  /// Validated offset (if applicable)
  @override
  final int? offset;

  /// Validated limit (if applicable)
  @override
  final int? limit;

  @override
  String toString() {
    return 'PaginatrixValidationState.valid(meta: $meta, pageNumber: $pageNumber, cursor: $cursor, offset: $offset, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidImplCopyWith<_$ValidImpl> get copyWith =>
      __$$ValidImplCopyWithImpl<_$ValidImpl>(this, _$identity);

  @override
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
    return valid(meta, pageNumber, cursor, offset, limit);
  }

  @override
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
    return valid?.call(meta, pageNumber, cursor, offset, limit);
  }

  @override
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
    if (valid != null) {
      return valid(meta, pageNumber, cursor, offset, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) {
    return valid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) {
    return valid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    if (valid != null) {
      return valid(this);
    }
    return orElse();
  }
}

abstract class _Valid implements PaginatrixValidationState {
  const factory _Valid(
      {final PageMeta? meta,
      final int? pageNumber,
      final String? cursor,
      final int? offset,
      final int? limit}) = _$ValidImpl;

  /// Validated metadata (if applicable)
  PageMeta? get meta;

  /// Validated page number (if applicable)
  int? get pageNumber;

  /// Validated cursor (if applicable)
  String? get cursor;

  /// Validated offset (if applicable)
  int? get offset;

  /// Validated limit (if applicable)
  int? get limit;
  @JsonKey(ignore: true)
  _$$ValidImplCopyWith<_$ValidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidImplCopyWith<$Res> {
  factory _$$InvalidImplCopyWith(
          _$InvalidImpl value, $Res Function(_$InvalidImpl) then) =
      __$$InvalidImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<String> errors, String? errorCode, Map<String, dynamic>? context});
}

/// @nodoc
class __$$InvalidImplCopyWithImpl<$Res>
    extends _$PaginatrixValidationStateCopyWithImpl<$Res, _$InvalidImpl>
    implements _$$InvalidImplCopyWith<$Res> {
  __$$InvalidImplCopyWithImpl(
      _$InvalidImpl _value, $Res Function(_$InvalidImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errors = null,
    Object? errorCode = freezed,
    Object? context = freezed,
  }) {
    return _then(_$InvalidImpl(
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$InvalidImpl implements _Invalid {
  const _$InvalidImpl(
      {required final List<String> errors,
      this.errorCode,
      final Map<String, dynamic>? context})
      : _errors = errors,
        _context = context;

  /// List of validation error messages
  final List<String> _errors;

  /// List of validation error messages
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  /// Validation error code for programmatic handling
  @override
  final String? errorCode;

  /// Additional context about the validation failure
  final Map<String, dynamic>? _context;

  /// Additional context about the validation failure
  @override
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaginatrixValidationState.invalid(errors: $errors, errorCode: $errorCode, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidImplCopyWith<_$InvalidImpl> get copyWith =>
      __$$InvalidImplCopyWithImpl<_$InvalidImpl>(this, _$identity);

  @override
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
    return invalid(errors, errorCode, context);
  }

  @override
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
    return invalid?.call(errors, errorCode, context);
  }

  @override
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
    if (invalid != null) {
      return invalid(errors, errorCode, context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Validating value) validating,
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
  }) {
    return invalid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Validating value)? validating,
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
  }) {
    return invalid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Validating value)? validating,
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    if (invalid != null) {
      return invalid(this);
    }
    return orElse();
  }
}

abstract class _Invalid implements PaginatrixValidationState {
  const factory _Invalid(
      {required final List<String> errors,
      final String? errorCode,
      final Map<String, dynamic>? context}) = _$InvalidImpl;

  /// List of validation error messages
  List<String> get errors;

  /// Validation error code for programmatic handling
  String? get errorCode;

  /// Additional context about the validation failure
  Map<String, dynamic>? get context;
  @JsonKey(ignore: true)
  _$$InvalidImplCopyWith<_$InvalidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
