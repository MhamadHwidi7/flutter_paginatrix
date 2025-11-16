// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilterValue {
  Object get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterValueCopyWith<$Res> {
  factory $FilterValueCopyWith(
          FilterValue value, $Res Function(FilterValue) then) =
      _$FilterValueCopyWithImpl<$Res, FilterValue>;
}

/// @nodoc
class _$FilterValueCopyWithImpl<$Res, $Val extends FilterValue>
    implements $FilterValueCopyWith<$Res> {
  _$FilterValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StringFilterValueImplCopyWith<$Res> {
  factory _$$StringFilterValueImplCopyWith(_$StringFilterValueImpl value,
          $Res Function(_$StringFilterValueImpl) then) =
      __$$StringFilterValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$StringFilterValueImplCopyWithImpl<$Res>
    extends _$FilterValueCopyWithImpl<$Res, _$StringFilterValueImpl>
    implements _$$StringFilterValueImplCopyWith<$Res> {
  __$$StringFilterValueImplCopyWithImpl(_$StringFilterValueImpl _value,
      $Res Function(_$StringFilterValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$StringFilterValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StringFilterValueImpl implements StringFilterValue {
  const _$StringFilterValueImpl(this.value);

  @override
  final String value;

  @override
  String toString() {
    return 'FilterValue.string(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringFilterValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringFilterValueImplCopyWith<_$StringFilterValueImpl> get copyWith =>
      __$$StringFilterValueImplCopyWithImpl<_$StringFilterValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    return string(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    return string?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }
}

abstract class StringFilterValue implements FilterValue {
  const factory StringFilterValue(final String value) = _$StringFilterValueImpl;

  @override
  String get value;
  @JsonKey(ignore: true)
  _$$StringFilterValueImplCopyWith<_$StringFilterValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntegerFilterValueImplCopyWith<$Res> {
  factory _$$IntegerFilterValueImplCopyWith(_$IntegerFilterValueImpl value,
          $Res Function(_$IntegerFilterValueImpl) then) =
      __$$IntegerFilterValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$IntegerFilterValueImplCopyWithImpl<$Res>
    extends _$FilterValueCopyWithImpl<$Res, _$IntegerFilterValueImpl>
    implements _$$IntegerFilterValueImplCopyWith<$Res> {
  __$$IntegerFilterValueImplCopyWithImpl(_$IntegerFilterValueImpl _value,
      $Res Function(_$IntegerFilterValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$IntegerFilterValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$IntegerFilterValueImpl implements IntegerFilterValue {
  const _$IntegerFilterValueImpl(this.value);

  @override
  final int value;

  @override
  String toString() {
    return 'FilterValue.integer(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegerFilterValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegerFilterValueImplCopyWith<_$IntegerFilterValueImpl> get copyWith =>
      __$$IntegerFilterValueImplCopyWithImpl<_$IntegerFilterValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    return integer(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    return integer?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }
}

abstract class IntegerFilterValue implements FilterValue {
  const factory IntegerFilterValue(final int value) = _$IntegerFilterValueImpl;

  @override
  int get value;
  @JsonKey(ignore: true)
  _$$IntegerFilterValueImplCopyWith<_$IntegerFilterValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BooleanFilterValueImplCopyWith<$Res> {
  factory _$$BooleanFilterValueImplCopyWith(_$BooleanFilterValueImpl value,
          $Res Function(_$BooleanFilterValueImpl) then) =
      __$$BooleanFilterValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$BooleanFilterValueImplCopyWithImpl<$Res>
    extends _$FilterValueCopyWithImpl<$Res, _$BooleanFilterValueImpl>
    implements _$$BooleanFilterValueImplCopyWith<$Res> {
  __$$BooleanFilterValueImplCopyWithImpl(_$BooleanFilterValueImpl _value,
      $Res Function(_$BooleanFilterValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$BooleanFilterValueImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BooleanFilterValueImpl implements BooleanFilterValue {
  const _$BooleanFilterValueImpl({required this.value});

  @override
  final bool value;

  @override
  String toString() {
    return 'FilterValue.boolean(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BooleanFilterValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BooleanFilterValueImplCopyWith<_$BooleanFilterValueImpl> get copyWith =>
      __$$BooleanFilterValueImplCopyWithImpl<_$BooleanFilterValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    return boolean(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    return boolean?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }
}

abstract class BooleanFilterValue implements FilterValue {
  const factory BooleanFilterValue({required final bool value}) =
      _$BooleanFilterValueImpl;

  @override
  bool get value;
  @JsonKey(ignore: true)
  _$$BooleanFilterValueImplCopyWith<_$BooleanFilterValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoubleFilterValueImplCopyWith<$Res> {
  factory _$$DoubleFilterValueImplCopyWith(_$DoubleFilterValueImpl value,
          $Res Function(_$DoubleFilterValueImpl) then) =
      __$$DoubleFilterValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$$DoubleFilterValueImplCopyWithImpl<$Res>
    extends _$FilterValueCopyWithImpl<$Res, _$DoubleFilterValueImpl>
    implements _$$DoubleFilterValueImplCopyWith<$Res> {
  __$$DoubleFilterValueImplCopyWithImpl(_$DoubleFilterValueImpl _value,
      $Res Function(_$DoubleFilterValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$DoubleFilterValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DoubleFilterValueImpl implements DoubleFilterValue {
  const _$DoubleFilterValueImpl(this.value);

  @override
  final double value;

  @override
  String toString() {
    return 'FilterValue.double(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleFilterValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleFilterValueImplCopyWith<_$DoubleFilterValueImpl> get copyWith =>
      __$$DoubleFilterValueImplCopyWithImpl<_$DoubleFilterValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    return double(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    return double?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    return double(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    return double?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(this);
    }
    return orElse();
  }
}

abstract class DoubleFilterValue implements FilterValue {
  const factory DoubleFilterValue(final double value) = _$DoubleFilterValueImpl;

  @override
  double get value;
  @JsonKey(ignore: true)
  _$$DoubleFilterValueImplCopyWith<_$DoubleFilterValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ListFilterValueImplCopyWith<$Res> {
  factory _$$ListFilterValueImplCopyWith(_$ListFilterValueImpl value,
          $Res Function(_$ListFilterValueImpl) then) =
      __$$ListFilterValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<dynamic> value});
}

/// @nodoc
class __$$ListFilterValueImplCopyWithImpl<$Res>
    extends _$FilterValueCopyWithImpl<$Res, _$ListFilterValueImpl>
    implements _$$ListFilterValueImplCopyWith<$Res> {
  __$$ListFilterValueImplCopyWithImpl(
      _$ListFilterValueImpl _value, $Res Function(_$ListFilterValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$ListFilterValueImpl(
      null == value
          ? _value._value
          : value // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc

class _$ListFilterValueImpl implements ListFilterValue {
  const _$ListFilterValueImpl(final List<dynamic> value) : _value = value;

  final List<dynamic> _value;
  @override
  List<dynamic> get value {
    if (_value is EqualUnmodifiableListView) return _value;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_value);
  }

  @override
  String toString() {
    return 'FilterValue.list(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListFilterValueImpl &&
            const DeepCollectionEquality().equals(other._value, _value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListFilterValueImplCopyWith<_$ListFilterValueImpl> get copyWith =>
      __$$ListFilterValueImplCopyWithImpl<_$ListFilterValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    return list(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    return list?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    return list(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    return list?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(this);
    }
    return orElse();
  }
}

abstract class ListFilterValue implements FilterValue {
  const factory ListFilterValue(final List<dynamic> value) =
      _$ListFilterValueImpl;

  @override
  List<dynamic> get value;
  @JsonKey(ignore: true)
  _$$ListFilterValueImplCopyWith<_$ListFilterValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
