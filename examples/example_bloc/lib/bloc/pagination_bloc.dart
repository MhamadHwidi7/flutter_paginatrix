import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'enums/paginatrix_bloc_action.dart';
import 'pagination_event.dart';
import 'pagination_state.dart';

/// BLoC for managing pagination using flutter_paginatrix
///
/// This BLoC wraps the PaginatedController and ensures all state changes
/// flow through the BLoC pattern, maintaining a single source of truth.
///
/// The BLoC listens to controller state changes (including automatic pagination)
/// and emits corresponding BLoC states, ensuring the UI always reflects
/// the current state through BlocBuilder.
///
/// Architecture:
/// - Follows the same consolidated pattern as PaginatedController
/// - Uses enum-based action dispatching to reduce code duplication
/// - All event handlers delegate to a single _executeAction method
///
/// Best Practices:
/// - Uses emit.onEach for automatic stream subscription cleanup
/// - No manual subscription management needed
/// - Prevents memory leaks automatically
/// - DRY principle: single execution path for all actions
class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationBlocState<T>> {
  /// Creates a new PaginationBloc with the given controller
  ///
  /// The controller is used internally and should not be accessed directly
  /// from outside the BLoC. Use BLoC events and state instead.
  PaginationBloc({
    required PaginatedController<T> controller,
  })  : _controller = controller,
        super(PaginationBlocState<T>(
          paginationState: controller.state,
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
        return _controller.stream
            .map((state) => ControllerStateChanged(state))
            .asyncExpand(mapper);
      },
    );
  }

  final PaginatedController<T> _controller;

  /// Get the underlying controller
  ///
  /// **Note**: This is exposed for compatibility with PaginatrixListView/GridView
  /// which require direct controller access. In a pure BLoC pattern, this would
  /// be private, but we need it for the widgets to function properly.
  ///
  /// Prefer using BLoC events and state instead of calling controller methods directly.
  PaginatedController<T> get controller => _controller;

  /// Unified action execution method that handles all pagination actions
  ///
  /// This method consolidates the common logic for executing pagination actions,
  /// following the same pattern as PaginatedController._loadData.
  /// All event handlers delegate to this method with the appropriate action type.
  ///
  /// Benefits:
  /// - DRY: No code duplication across event handlers
  /// - Maintainability: Single place to modify action execution logic
  /// - Consistency: Same pattern as PaginatedController
  Future<void> _executeAction(
    PaginatrixBlocAction action,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    switch (action) {
      case PaginatrixBlocAction.loadFirst:
        await _controller.loadFirstPage();
        break;

      case PaginatrixBlocAction.loadNext:
        await _controller.loadNextPage();
        break;

      case PaginatrixBlocAction.refresh:
        await _controller.refresh();
        break;

      case PaginatrixBlocAction.retry:
        await _controller.retry();
        break;

      case PaginatrixBlocAction.clear:
        _controller.clear();
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
    // Just dispose the controller
    _controller.dispose();
    return super.close();
  }
}

