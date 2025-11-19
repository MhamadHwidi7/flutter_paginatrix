// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterValue {
  Object get value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FilterValue &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'FilterValue(value: $value)';
  }
}

/// @nodoc
class $FilterValueCopyWith<$Res> {
  $FilterValueCopyWith(FilterValue _, $Res Function(FilterValue) __);
}

/// Adds pattern-matching-related methods to [FilterValue].
extension FilterValuePatterns on FilterValue {
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
    TResult Function(StringFilterValue value)? string,
    TResult Function(IntegerFilterValue value)? integer,
    TResult Function(BooleanFilterValue value)? boolean,
    TResult Function(DoubleFilterValue value)? double,
    TResult Function(ListFilterValue value)? list,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue() when string != null:
        return string(_that);
      case IntegerFilterValue() when integer != null:
        return integer(_that);
      case BooleanFilterValue() when boolean != null:
        return boolean(_that);
      case DoubleFilterValue() when double != null:
        return double(_that);
      case ListFilterValue() when list != null:
        return list(_that);
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
    required TResult Function(StringFilterValue value) string,
    required TResult Function(IntegerFilterValue value) integer,
    required TResult Function(BooleanFilterValue value) boolean,
    required TResult Function(DoubleFilterValue value) double,
    required TResult Function(ListFilterValue value) list,
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue():
        return string(_that);
      case IntegerFilterValue():
        return integer(_that);
      case BooleanFilterValue():
        return boolean(_that);
      case DoubleFilterValue():
        return double(_that);
      case ListFilterValue():
        return list(_that);
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
    TResult? Function(StringFilterValue value)? string,
    TResult? Function(IntegerFilterValue value)? integer,
    TResult? Function(BooleanFilterValue value)? boolean,
    TResult? Function(DoubleFilterValue value)? double,
    TResult? Function(ListFilterValue value)? list,
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue() when string != null:
        return string(_that);
      case IntegerFilterValue() when integer != null:
        return integer(_that);
      case BooleanFilterValue() when boolean != null:
        return boolean(_that);
      case DoubleFilterValue() when double != null:
        return double(_that);
      case ListFilterValue() when list != null:
        return list(_that);
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
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? double,
    TResult Function(List<dynamic> value)? list,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue() when string != null:
        return string(_that.value);
      case IntegerFilterValue() when integer != null:
        return integer(_that.value);
      case BooleanFilterValue() when boolean != null:
        return boolean(_that.value);
      case DoubleFilterValue() when double != null:
        return double(_that.value);
      case ListFilterValue() when list != null:
        return list(_that.value);
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
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) double,
    required TResult Function(List<dynamic> value) list,
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue():
        return string(_that.value);
      case IntegerFilterValue():
        return integer(_that.value);
      case BooleanFilterValue():
        return boolean(_that.value);
      case DoubleFilterValue():
        return double(_that.value);
      case ListFilterValue():
        return list(_that.value);
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
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? double,
    TResult? Function(List<dynamic> value)? list,
  }) {
    final _that = this;
    switch (_that) {
      case StringFilterValue() when string != null:
        return string(_that.value);
      case IntegerFilterValue() when integer != null:
        return integer(_that.value);
      case BooleanFilterValue() when boolean != null:
        return boolean(_that.value);
      case DoubleFilterValue() when double != null:
        return double(_that.value);
      case ListFilterValue() when list != null:
        return list(_that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc

class StringFilterValue implements FilterValue {
  const StringFilterValue(this.value);

  @override
  final String value;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StringFilterValueCopyWith<StringFilterValue> get copyWith =>
      _$StringFilterValueCopyWithImpl<StringFilterValue>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StringFilterValue &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'FilterValue.string(value: $value)';
  }
}

/// @nodoc
abstract mixin class $StringFilterValueCopyWith<$Res>
    implements $FilterValueCopyWith<$Res> {
  factory $StringFilterValueCopyWith(
          StringFilterValue value, $Res Function(StringFilterValue) _then) =
      _$StringFilterValueCopyWithImpl;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$StringFilterValueCopyWithImpl<$Res>
    implements $StringFilterValueCopyWith<$Res> {
  _$StringFilterValueCopyWithImpl(this._self, this._then);

  final StringFilterValue _self;
  final $Res Function(StringFilterValue) _then;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(StringFilterValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class IntegerFilterValue implements FilterValue {
  const IntegerFilterValue(this.value);

  @override
  final int value;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntegerFilterValueCopyWith<IntegerFilterValue> get copyWith =>
      _$IntegerFilterValueCopyWithImpl<IntegerFilterValue>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntegerFilterValue &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'FilterValue.integer(value: $value)';
  }
}

/// @nodoc
abstract mixin class $IntegerFilterValueCopyWith<$Res>
    implements $FilterValueCopyWith<$Res> {
  factory $IntegerFilterValueCopyWith(
          IntegerFilterValue value, $Res Function(IntegerFilterValue) _then) =
      _$IntegerFilterValueCopyWithImpl;
  @useResult
  $Res call({int value});
}

/// @nodoc
class _$IntegerFilterValueCopyWithImpl<$Res>
    implements $IntegerFilterValueCopyWith<$Res> {
  _$IntegerFilterValueCopyWithImpl(this._self, this._then);

  final IntegerFilterValue _self;
  final $Res Function(IntegerFilterValue) _then;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(IntegerFilterValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class BooleanFilterValue implements FilterValue {
  const BooleanFilterValue({required this.value});

  @override
  final bool value;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BooleanFilterValueCopyWith<BooleanFilterValue> get copyWith =>
      _$BooleanFilterValueCopyWithImpl<BooleanFilterValue>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BooleanFilterValue &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'FilterValue.boolean(value: $value)';
  }
}

/// @nodoc
abstract mixin class $BooleanFilterValueCopyWith<$Res>
    implements $FilterValueCopyWith<$Res> {
  factory $BooleanFilterValueCopyWith(
          BooleanFilterValue value, $Res Function(BooleanFilterValue) _then) =
      _$BooleanFilterValueCopyWithImpl;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class _$BooleanFilterValueCopyWithImpl<$Res>
    implements $BooleanFilterValueCopyWith<$Res> {
  _$BooleanFilterValueCopyWithImpl(this._self, this._then);

  final BooleanFilterValue _self;
  final $Res Function(BooleanFilterValue) _then;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(BooleanFilterValue(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class DoubleFilterValue implements FilterValue {
  const DoubleFilterValue(this.value);

  @override
  final double value;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DoubleFilterValueCopyWith<DoubleFilterValue> get copyWith =>
      _$DoubleFilterValueCopyWithImpl<DoubleFilterValue>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DoubleFilterValue &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'FilterValue.double(value: $value)';
  }
}

/// @nodoc
abstract mixin class $DoubleFilterValueCopyWith<$Res>
    implements $FilterValueCopyWith<$Res> {
  factory $DoubleFilterValueCopyWith(
          DoubleFilterValue value, $Res Function(DoubleFilterValue) _then) =
      _$DoubleFilterValueCopyWithImpl;
  @useResult
  $Res call({double value});
}

/// @nodoc
class _$DoubleFilterValueCopyWithImpl<$Res>
    implements $DoubleFilterValueCopyWith<$Res> {
  _$DoubleFilterValueCopyWithImpl(this._self, this._then);

  final DoubleFilterValue _self;
  final $Res Function(DoubleFilterValue) _then;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(DoubleFilterValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class ListFilterValue implements FilterValue {
  const ListFilterValue(final List<dynamic> value) : _value = value;

  final List<dynamic> _value;
  @override
  List<dynamic> get value {
    if (_value is EqualUnmodifiableListView) return _value;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_value);
  }

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListFilterValueCopyWith<ListFilterValue> get copyWith =>
      _$ListFilterValueCopyWithImpl<ListFilterValue>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListFilterValue &&
            const DeepCollectionEquality().equals(other._value, _value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_value));

  @override
  String toString() {
    return 'FilterValue.list(value: $value)';
  }
}

/// @nodoc
abstract mixin class $ListFilterValueCopyWith<$Res>
    implements $FilterValueCopyWith<$Res> {
  factory $ListFilterValueCopyWith(
          ListFilterValue value, $Res Function(ListFilterValue) _then) =
      _$ListFilterValueCopyWithImpl;
  @useResult
  $Res call({List<dynamic> value});
}

/// @nodoc
class _$ListFilterValueCopyWithImpl<$Res>
    implements $ListFilterValueCopyWith<$Res> {
  _$ListFilterValueCopyWithImpl(this._self, this._then);

  final ListFilterValue _self;
  final $Res Function(ListFilterValue) _then;

  /// Create a copy of FilterValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(ListFilterValue(
      null == value
          ? _self._value
          : value // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

// dart format on
