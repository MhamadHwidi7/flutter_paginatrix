import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'package:shared/bloc/pagination_state.dart';

import '../cubit/view_controls_cubit.dart';
import '../cubit/view_controls_state.dart';
import '../repository/pokemon_repository.dart';
import 'pagination_event.dart';

/// BLoC for managing pagination with search, filter, and sort support
///
/// This BLoC wraps the PaginatrixCubit and ensures all state changes
/// flow through the BLoC pattern, maintaining a single source of truth.
///
/// The BLoC listens to controller state changes (including automatic pagination)
/// and emits corresponding BLoC states, ensuring the UI always reflects
/// the current state through BlocBuilder.
class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationBlocState<T>> {
  /// Creates a new PaginationBloc with the given repository, view controls cubit, and item decoder
  ///
  /// The cubit is used internally and should not be accessed directly
  /// from outside the BLoC. Use BLoC events and state instead.
  PaginationBloc({
    required PokemonRepository repository,
    required ViewControlsCubit uiCubit,
    required T Function(Map<String, dynamic>) itemDecoder,
  })  : _repository = repository,
        _uiCubit = uiCubit,
        _itemDecoder = itemDecoder,
        super(PaginationBlocState<T>(
          paginationState: _createInitialState<T>(),
        )) {
    // Create the cubit with a loader that uses current UI state
    _cubit = PaginatrixCubit<T>(
      loader: _loadData,
      itemDecoder: _itemDecoder,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: const PaginationOptions(
        searchDebounceDuration: Duration(milliseconds: 400),
        defaultPageSize: 20,
        enableDebugLogging: true, // Enable debug prints
      ),
    );

    // Initialize state
    emit(PaginationBlocState<T>(
      paginationState: _cubit.state,
    ));

    // Register event handlers
    on<LoadFirstPage>(_onLoadFirstPage);
    on<LoadNextPage>(_onLoadNextPage);
    on<RefreshPage>(_onRefreshPage);
    on<RetryPagination>(_onRetryPagination);
    on<ClearPagination>(_onClearPagination);
    on<UpdateSearch>(_onUpdateSearch);
    on<UpdateTypeFilter>(_onUpdateTypeFilter);
    on<UpdateSorting>(_onUpdateSorting);
    on<ClearAllFilters>(_onClearAllFilters);

    // Register handler for controller state changes
    on<ControllerStateChanged>(_onControllerStateChanged);

    // Listen to controller state changes
    _subscription = _cubit.stream.listen(
      (state) {
        debugPrint(
            '🟢 [PaginationBloc] Controller state changed: ${state.status}');
        debugPrint(
            '   📦 Items: ${state.items.length}, Has more: ${state.canLoadMore}');
        add(ControllerStateChanged(state));
      },
    );

    // Listen to UI cubit changes to reload data when filters change
    // Skip the first emission (initial state) to avoid double loading
    var isFirstEmission = true;
    _uiSubscription = _uiCubit.stream.listen((uiState) {
      if (isFirstEmission) {
        isFirstEmission = false;
        return;
      }
      // Always reload data when UI state changes (search, filter, sort)
      // This ensures we reload even if previous search returned empty results
      debugPrint('🟡 [PaginationBloc] UI state changed:');
      debugPrint('   🔍 Search: "${uiState.searchTerm}"');
      debugPrint('   🏷️  Type: ${uiState.selectedType ?? "none"}');
      debugPrint(
          '   🔄 Sort: ${uiState.sortBy ?? "none"} (${uiState.sortDesc ? "desc" : "asc"})');
      debugPrint('   ➡️  Triggering LoadFirstPage...');
      add(const LoadFirstPage());
    });
  }

  final PokemonRepository _repository;
  final ViewControlsCubit _uiCubit;
  final T Function(Map<String, dynamic>) _itemDecoder;
  late final PaginatrixCubit<T> _cubit;
  StreamSubscription<PaginationState<T>>? _subscription;
  StreamSubscription<ViewControlsState>? _uiSubscription;

  /// Get the underlying controller
  ///
  /// **Note**: This is exposed for compatibility with PaginatrixListView/GridView
  /// which require direct controller access. In a pure BLoC pattern, this would
  /// be private, but we need it for the widgets to function properly.
  ///
  /// Prefer using BLoC events and state instead of calling controller methods directly.
  PaginatrixCubit<T> get controller => _cubit;

  /// Loader function that uses current UI state for search, filter, and sort
  Future<Map<String, dynamic>> _loadData({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    // Always build from UI state to ensure consistency
    // The query parameter from PaginatrixCubit may be stale if UI state changed
    // This ensures filters are always applied correctly
    final uiState = _uiCubit.state;
    final queryCriteria = QueryCriteria(
      searchTerm: uiState.searchTerm.isNotEmpty ? uiState.searchTerm : '',
      filters: uiState.selectedType != null
          ? {'type': uiState.selectedType!}
          : const {},
      sortBy: uiState.sortBy,
      sortDesc: uiState.sortDesc,
    );

    return _repository.loadPokemonPage(
      page: page,
      perPage: perPage,
      offset: offset,
      limit: limit,
      cancelToken: cancelToken,
      query: queryCriteria,
    );
  }

  /// Creates initial pagination state
  static PaginationState<T> _createInitialState<T>() {
    return PaginationState<T>.initial();
  }

  /// Handles LoadFirstPage event
  Future<void> _onLoadFirstPage(
    LoadFirstPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    debugPrint('🟦 [PaginationBloc] Handling LoadFirstPage event');
    // Load first page - the loader function reads from UI cubit state
    // so it will automatically use the latest search/filter/sort values
    await _cubit.loadFirstPage();
    debugPrint('🟦 [PaginationBloc] LoadFirstPage completed');
  }

  /// Handles LoadNextPage event
  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    debugPrint('🟦 [PaginationBloc] Handling LoadNextPage event');
    await _cubit.loadNextPage();
    debugPrint('🟦 [PaginationBloc] LoadNextPage completed');
  }

  /// Handles RefreshPage event
  Future<void> _onRefreshPage(
    RefreshPage event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    debugPrint('🟦 [PaginationBloc] Handling RefreshPage event');
    await _cubit.refresh();
    debugPrint('🟦 [PaginationBloc] RefreshPage completed');
  }

  /// Handles RetryPagination event
  Future<void> _onRetryPagination(
    RetryPagination event,
    Emitter<PaginationBlocState<T>> emit,
  ) async {
    await _cubit.retry();
  }

  /// Handles ClearPagination event
  void _onClearPagination(
    ClearPagination event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    _cubit.clear();
  }

  /// Handles UpdateSearch event
  void _onUpdateSearch(
    UpdateSearch event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    debugPrint(
        '🟦 [PaginationBloc] Handling UpdateSearch event: "${event.searchTerm}"');
    _uiCubit.updateSearchTerm(event.searchTerm);
    // Trigger LoadFirstPage immediately after updating UI state
    // This ensures the filter is applied right away
    add(const LoadFirstPage());
  }

  /// Handles UpdateTypeFilter event
  void _onUpdateTypeFilter(
    UpdateTypeFilter event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    debugPrint(
        '🟦 [PaginationBloc] Handling UpdateTypeFilter event: ${event.type ?? "none"}');
    _uiCubit.updateTypeFilter(event.type);
    // Trigger LoadFirstPage immediately after updating UI state
    // This ensures the filter is applied right away
    add(const LoadFirstPage());
  }

  /// Handles UpdateSorting event
  void _onUpdateSorting(
    UpdateSorting event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    debugPrint(
        '🟦 [PaginationBloc] Handling UpdateSorting event: ${event.sortBy ?? "none"} (${event.sortDesc ? "desc" : "asc"})');
    _uiCubit.updateSortBy(event.sortBy);
    if (event.sortBy != null) {
      _uiCubit.updateSortDesc(event.sortDesc);
    }
    // Trigger LoadFirstPage immediately after updating UI state
    // This ensures the filter is applied right away
    add(const LoadFirstPage());
  }

  /// Handles ClearAllFilters event
  void _onClearAllFilters(
    ClearAllFilters event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    _uiCubit.clearAll();
    // Trigger LoadFirstPage immediately after updating UI state
    // This ensures the filter is applied right away
    add(const LoadFirstPage());
  }

  /// Handles internal event when controller state changes
  void _onControllerStateChanged(
    ControllerStateChanged event,
    Emitter<PaginationBlocState<T>> emit,
  ) {
    emit(PaginationBlocState<T>(
      paginationState: event.paginationState as PaginationState<T>,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _uiSubscription?.cancel();
    _cubit.close();
    return super.close();
  }
}
