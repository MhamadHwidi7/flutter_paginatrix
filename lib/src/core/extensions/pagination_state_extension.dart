import 'package:flutter_paginatrix/src/core/entities/pagination_state.dart';

extension PaginationStateExtension<T> on PaginationState<T> {
  /// Whether the state has data
  bool get hasData => items.isNotEmpty;

  /// Whether the state is loading
  bool get isLoading => status.maybeWhen(
        loading: () => true,
        refreshing: () => true,
        appending: () => true,
        orElse: () => false,
      );

  /// Whether the state has an error
  bool get hasError => error != null;

  /// Whether the state has an append error
  bool get hasAppendError => appendError != null;

  /// Whether more data can be loaded
  bool get canLoadMore {
    if (meta == null) return false;
    return meta?.hasMore ?? false;
  }

  /// Whether the state is in a stable state (not loading)
  bool get isStable => !isLoading;

  /// Whether the state is in an error state
  bool get isError => status.maybeWhen(
        error: () => true,
        orElse: () => false,
      );

  /// Whether the state is empty
  bool get isEmpty => status.maybeWhen(
        empty: () => true,
        orElse: () => false,
      );

  /// Whether the state is successful
  bool get isSuccess => status.maybeWhen(
        success: () => true,
        orElse: () => false,
      );
}
