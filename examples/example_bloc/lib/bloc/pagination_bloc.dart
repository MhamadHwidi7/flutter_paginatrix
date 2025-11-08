import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

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
    // Register event handlers
    on<LoadFirstPage>(_onLoadFirstPage);
    on<LoadNextPage>(_onLoadNextPage);
    on<RefreshPage>(_onRefreshPage);
    on<RetryPagination>(_onRetryPagination);
    on<ClearPagination>(_onClearPagination);
    on<ControllerStateChanged>(_onControllerStateChanged);

    // Listen to controller state changes to sync with BLoC state
    // This ensures automatic pagination (e.g., on scroll) updates BLoC state
    _controllerSubscription = _controller.stream.listen(
      (paginationState) {
        // Dispatch internal event to sync controller state to BLoC
        // This is safe because we're not calling emit directly
        if (!isClosed) {
          add(ControllerStateChanged(paginationState));
        }
      },
    );
  }

  final PaginatedController<T> _controller;
  StreamSubscription<PaginationState<T>>? _controllerSubscription;

  /// Get the underlying controller
  ///
  /// **Note**: This is exposed for compatibility with PaginatrixListView/GridView
  /// which require direct controller access. In a pure BLoC pattern, this would
  /// be private, but we need it for the widgets to function properly.
  ///
  /// Prefer using BLoC events and state instead of calling controller methods directly.
  PaginatedController<T> get controller => _controller;

  Future<void> _onLoadFirstPage(
    LoadFirstPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    await _controller.loadFirstPage();
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    await _controller.loadNextPage();
  }

  Future<void> _onRefreshPage(
    RefreshPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    await _controller.refresh();
  }

  Future<void> _onRetryPagination(
    RetryPagination event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    await _controller.retry();
  }

  void _onClearPagination(
    ClearPagination event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    // Controller will emit state changes through its stream,
    // which will be handled by _onControllerStateChanged
    _controller.clear();
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
    _controllerSubscription?.cancel();
    _controller.dispose();
    return super.close();
  }
}

