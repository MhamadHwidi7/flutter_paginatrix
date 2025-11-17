import 'package:equatable/equatable.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Immutable BLoC state that wraps the PaginationState from flutter_paginatrix
///
/// This state is immutable and uses Equatable for value equality,
/// ensuring proper state comparison in BlocBuilder.
///
/// The underlying PaginationState is also immutable (using Freezed),
/// ensuring complete immutability throughout the state management flow.
class PaginationBlocState<T> extends Equatable {
  /// Creates a new immutable PaginationBlocState
  const PaginationBlocState({
    required this.paginationState,
  });

  /// The underlying pagination state (immutable)
  final PaginationState<T> paginationState;

  /// Whether the state has data
  bool get hasData => paginationState.hasData;

  /// Whether the state is loading
  bool get isLoading => paginationState.isLoading;

  /// Whether the state is refreshing (not appending)
  bool get isRefreshing => paginationState.status.maybeWhen(
        refreshing: () => true,
        orElse: () => false,
      );

  /// Whether the state is appending (loading next page)
  bool get isAppending => paginationState.status.maybeWhen(
        appending: () => true,
        orElse: () => false,
      );

  /// Whether the state has an error
  bool get hasError => paginationState.hasError;

  /// Whether the state has an append error
  bool get hasAppendError => paginationState.hasAppendError;

  /// Whether more data can be loaded
  bool get canLoadMore => paginationState.canLoadMore;

  /// List of items
  List<T> get items => paginationState.items;

  /// Current error
  PaginationError? get error => paginationState.error;

  /// Append error
  PaginationError? get appendError => paginationState.appendError;

  /// Pagination metadata
  PageMeta? get meta => paginationState.meta;

  /// Current status
  PaginationStatus get status => paginationState.status;

  /// Creates a copy of this state with updated values
  ///
  /// Returns a new immutable instance with the specified fields replaced.
  PaginationBlocState<T> copyWith({
    PaginationState<T>? paginationState,
  }) {
    return PaginationBlocState<T>(
      paginationState: paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object?> get props => [paginationState];

  @override
  String toString() {
    return 'PaginationBlocState<$T>(paginationState: $paginationState)';
  }
}


