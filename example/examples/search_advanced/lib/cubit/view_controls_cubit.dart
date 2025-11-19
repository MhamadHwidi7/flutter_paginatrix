import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_controls_state.dart';

/// View Controls Cubit for managing search, filters, sorting, and grid layout
///
/// This cubit manages all UI-related state that doesn't directly affect
/// pagination but controls how the UI is displayed and how user interactions
/// are handled.
class ViewControlsCubit extends Cubit<ViewControlsState> {
  ViewControlsCubit() : super(const ViewControlsState());

  /// Updates the search term
  void updateSearchTerm(String searchTerm) {
    emit(state.copyWith(searchTerm: searchTerm));
  }

  /// Updates the selected type filter
  void updateTypeFilter(String? type) {
    emit(state.copyWith(selectedType: type));
  }

  /// Updates the sort field
  void updateSortBy(String? sortBy) {
    emit(state.copyWith(sortBy: sortBy));
  }

  /// Updates the sort direction
  void updateSortDesc(bool sortDesc) {
    emit(state.copyWith(sortDesc: sortDesc));
  }

  /// Toggles the sort direction
  void toggleSortDirection() {
    emit(state.copyWith(sortDesc: !state.sortDesc));
  }

  /// Updates the grid column count
  void updateGridColumns(double columns) {
    emit(state.copyWith(gridColumns: columns.clamp(1, 2)));
  }

  /// Clears all filters and search
  void clearAll() {
    emit(const ViewControlsState(
      gridColumns: 2.0,
    ));
  }

  /// Clears only search
  void clearSearch() {
    emit(state.copyWith(searchTerm: ''));
  }

  /// Clears only type filter
  void clearTypeFilter() {
    emit(state.copyWith(selectedType: null));
  }

  /// Clears only sorting
  void clearSorting() {
    emit(state.copyWith(sortBy: null, sortDesc: false));
  }
}
