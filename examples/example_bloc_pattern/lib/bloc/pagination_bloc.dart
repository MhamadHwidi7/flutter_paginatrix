import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'enums/paginatrix_bloc_action.dart';
import 'pagination_event.dart';
import 'pagination_state.dart';

/// BLoC for managing pagination using flutter_paginatrix
///
/// This BLoC wraps the PaginatedCubit and ensures all state changes
/// flow through the BLoC pattern, maintaining a single source of truth.
///
/// The BLoC listens to controller state changes (including automatic pagination)
/// and emits corresponding BLoC states, ensuring the UI always reflects
/// the current state through BlocBuilder.
///
/// Architecture:
/// - Follows the same consolidated pattern as PaginatedCubit
/// - Uses enum-based action dispatching to reduce code duplication
/// - All event handlers delegate to a single _executeAction method
///
/// Best Practices:
/// - Uses emit.onEach for automatic stream subscription cleanup
/// - No manual subscription management needed
/// - Prevents memory leaks automatically
/// - DRY principle: single execution path for all actions
class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationBlocState<T>> {
  /// Creates a new PaginationBloc with the given cubit
  ///
  /// The cubit is used internally and should not be accessed directly
  /// from outside the BLoC. Use BLoC events and state instead.
  PaginationBloc({
    required PaginatedCubit<T> cubit,
  })  : _cubit = cubit,
        super(PaginationBlocState<T>(
          paginationState: cubit.state,
        )) {
    // Register event handlers - all delegate to _executeAction
    on<LoadFirstPage>((event, emit) => _executeAction(
          PaginatrixBlocAction.loadFirst,
          emit,
        ));
    on<LoadNextPage>((event, emit) => _executeAction(
          PaginatrixBlocAction.loadNext,
          emit,
        ));
    on<RefreshPage>((event, emit) => _executeAction(
          PaginatrixBlocAction.refresh,
          emit,
        ));
    on<RetryPagination>((event, emit) => _executeAction(
          PaginatrixBlocAction.retry,
          emit,
        ));
    on<ClearPagination>((event, emit) => _executeAction(
          PaginatrixBlocAction.clear,
          emit,
        ));

    // Listen to controller state changes using emit.onEach (BEST PRACTICE)
    // This is the recommended way by flutter_bloc team:
    // - Automatic subscription management
    // - Automatic cleanup when bloc closes
    // - No manual cancel() needed
    // - No risk of memory leaks
    // - Clean and declarative code
    on<ControllerStateChanged>(
      _onControllerStateChanged,
      transformer: (events, mapper) {
        // Use emit.onEach pattern: listen to external stream and map to events
        return _cubit.stream
            .map((state) => ControllerStateChanged(state))
            .asyncExpand(mapper);
      },
    );
  }

  final PaginatedCubit<T> _cubit;

  /// Get the underlying controller
  ///
  /// **Note**: This is exposed for compatibility with PaginatrixListView/GridView
  /// which require direct controller access. In a pure BLoC pattern, this would
  /// be private, but we need it for the widgets to function properly.
  ///
  /// Prefer using BLoC events and state instead of calling controller methods directly.
  PaginatedCubit<T> get controller => _cubit;

  /// Unified action execution method that handles all pagination actions
  ///
  /// This method consolidates the common logic for executing pagination actions,
  /// following the same pattern as PaginatedCubit._loadData.
  /// All event handlers delegate to this method with the appropriate action type.
  ///
  /// Benefits:
  /// - DRY: No code duplication across event handlers
  /// - Maintainability: Single place to modify action execution logic
  /// - Consistency: Same pattern as PaginatedCubit
  Future<void> _executeAction(
    PaginatrixBlocAction action,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    switch (action) {
      case PaginatrixBlocAction.loadFirst:
        await _cubit.loadFirstPage();
        break;

      case PaginatrixBlocAction.loadNext:
        await _cubit.loadNextPage();
        break;

      case PaginatrixBlocAction.refresh:
        await _cubit.refresh();
        break;

      case PaginatrixBlocAction.retry:
        await _cubit.retry();
        break;

      case PaginatrixBlocAction.clear:
        _cubit.clear();
        break;
    }
  }

  /// Handles internal event when controller state changes
  ///
  /// This ensures that all controller state changes (including automatic
  /// pagination triggered by scroll) are reflected in the BLoC state.
  void _onControllerStateChanged(
    ControllerStateChanged event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    // Emit the new BLoC state based on controller state
    // The paginationState is guaranteed to be PaginationState<T> at runtime
    emit(PaginationBlocState<T>(
      paginationState: event.paginationState as PaginationState<T>,
    ));
  }

  @override
  Future<void> close() {
    // No need to manually cancel subscription - bloc handles it automatically
    // Just close the cubit
    _cubit.close();
    return super.close();
  }
}
