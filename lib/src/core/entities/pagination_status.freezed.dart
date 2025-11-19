// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationStatus {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaginationStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus()';
  }
}

/// @nodoc
class $PaginationStatusCopyWith<$Res> {
  $PaginationStatusCopyWith(
      PaginationStatus _, $Res Function(PaginationStatus) __);
}

/// Adds pattern-matching-related methods to [PaginationStatus].
extension PaginationStatusPatterns on PaginationStatus {
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
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Empty value)? empty,
    TResult Function(_Refreshing value)? refreshing,
    TResult Function(_Appending value)? appending,
    TResult Function(_Error value)? error,
    TResult Function(_AppendError value)? appendError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Success() when success != null:
        return success(_that);
      case _Empty() when empty != null:
        return empty(_that);
      case _Refreshing() when refreshing != null:
        return refreshing(_that);
      case _Appending() when appending != null:
        return appending(_that);
      case _Error() when error != null:
        return error(_that);
      case _AppendError() when appendError != null:
        return appendError(_that);
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
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Refreshing value) refreshing,
    required TResult Function(_Appending value) appending,
    required TResult Function(_Error value) error,
    required TResult Function(_AppendError value) appendError,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case _Success():
        return success(_that);
      case _Empty():
        return empty(_that);
      case _Refreshing():
        return refreshing(_that);
      case _Appending():
        return appending(_that);
      case _Error():
        return error(_that);
      case _AppendError():
        return appendError(_that);
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
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Refreshing value)? refreshing,
    TResult? Function(_Appending value)? appending,
    TResult? Function(_Error value)? error,
    TResult? Function(_AppendError value)? appendError,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Success() when success != null:
        return success(_that);
      case _Empty() when empty != null:
        return empty(_that);
      case _Refreshing() when refreshing != null:
        return refreshing(_that);
      case _Appending() when appending != null:
        return appending(_that);
      case _Error() when error != null:
        return error(_that);
      case _AppendError() when appendError != null:
        return appendError(_that);
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
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? empty,
    TResult Function()? refreshing,
    TResult Function()? appending,
    TResult Function()? error,
    TResult Function()? appendError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Success() when success != null:
        return success();
      case _Empty() when empty != null:
        return empty();
      case _Refreshing() when refreshing != null:
        return refreshing();
      case _Appending() when appending != null:
        return appending();
      case _Error() when error != null:
        return error();
      case _AppendError() when appendError != null:
        return appendError();
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
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() empty,
    required TResult Function() refreshing,
    required TResult Function() appending,
    required TResult Function() error,
    required TResult Function() appendError,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading();
      case _Success():
        return success();
      case _Empty():
        return empty();
      case _Refreshing():
        return refreshing();
      case _Appending():
        return appending();
      case _Error():
        return error();
      case _AppendError():
        return appendError();
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
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? empty,
    TResult? Function()? refreshing,
    TResult? Function()? appending,
    TResult? Function()? error,
    TResult? Function()? appendError,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Success() when success != null:
        return success();
      case _Empty() when empty != null:
        return empty();
      case _Refreshing() when refreshing != null:
        return refreshing();
      case _Appending() when appending != null:
        return appending();
      case _Error() when error != null:
        return error();
      case _AppendError() when appendError != null:
        return appendError();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements PaginationStatus {
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
    return 'PaginationStatus.initial()';
  }
}

/// @nodoc

class _Loading implements PaginationStatus {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.loading()';
  }
}

/// @nodoc

class _Success implements PaginationStatus {
  const _Success();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Success);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.success()';
  }
}

/// @nodoc

class _Empty implements PaginationStatus {
  const _Empty();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Empty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.empty()';
  }
}

/// @nodoc

class _Refreshing implements PaginationStatus {
  const _Refreshing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Refreshing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.refreshing()';
  }
}

/// @nodoc

class _Appending implements PaginationStatus {
  const _Appending();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Appending);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.appending()';
  }
}

/// @nodoc

class _Error implements PaginationStatus {
  const _Error();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Error);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.error()';
  }
}

/// @nodoc

class _AppendError implements PaginationStatus {
  const _AppendError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _AppendError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaginationStatus.appendError()';
  }
}

// dart format on
