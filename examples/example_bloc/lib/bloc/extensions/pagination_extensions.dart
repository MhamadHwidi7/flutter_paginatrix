library;

import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Extension methods for PaginationState to simplify common checks
///
/// Provides convenience methods for checking state and determining UI rendering
extension PaginationStateExtensions<T> on PaginationState<T> {
  /// Whether the state is in initial state
  bool get isInitial => status.maybeWhen(
        initial: () => true,
        orElse: () => false,
      );

  /// Whether the state is loading (without existing data)
  bool get isLoadingInitial => isLoading && !hasData;

  /// Whether the state is refreshing
  bool get isRefreshing => status.maybeWhen(
        refreshing: () => true,
        orElse: () => false,
      );

  /// Whether the state is appending (loading next page)
  bool get isAppending => status.maybeWhen(
        appending: () => true,
        orElse: () => false,
      );

  /// Whether the state is empty (no data after successful load)
  bool get isEmpty => status.maybeWhen(
        empty: () => true,
        orElse: () => false,
      );

  /// Whether the state has error without data
  bool get hasErrorWithoutData => hasError && !hasData;

  // UI Rendering Helpers

  /// Whether we should show loading indicator
  bool get shouldShowLoading => isInitial || isLoadingInitial;

  /// Whether we should show error screen
  bool get shouldShowError => hasErrorWithoutData;

  /// Whether we should show empty screen
  bool get shouldShowEmpty => isEmpty;

  /// Whether we should show content
  bool get shouldShowContent => hasData;
}

