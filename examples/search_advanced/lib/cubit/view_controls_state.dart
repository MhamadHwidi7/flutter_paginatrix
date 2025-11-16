import 'package:equatable/equatable.dart';

/// View Controls State containing all UI-related state
///
/// This state manages search, filters, sorting, and grid layout preferences
/// that control how the UI is displayed and how user interactions are handled.
class ViewControlsState extends Equatable {
  const ViewControlsState({
    this.searchTerm = '',
    this.selectedType,
    this.sortBy,
    this.sortDesc = false,
    this.gridColumns = 2.0,
  });

  /// Current search term
  final String searchTerm;

  /// Selected Pokemon type filter
  final String? selectedType;

  /// Field to sort by (null means no sorting)
  final String? sortBy;

  /// Whether sorting is descending
  final bool sortDesc;

  /// Number of grid columns (1-2)
  final double gridColumns;

  /// Whether there are any active filters
  bool get hasActiveFilters =>
      searchTerm.isNotEmpty || selectedType != null || sortBy != null;

  /// Whether search is active
  bool get hasSearch => searchTerm.isNotEmpty;

  /// Whether type filter is active
  bool get hasTypeFilter => selectedType != null;

  /// Whether sorting is active
  bool get hasSorting => sortBy != null;

  /// Creates a copy with updated values
  ViewControlsState copyWith({
    String? searchTerm,
    String? selectedType,
    String? sortBy,
    bool? sortDesc,
    double? gridColumns,
  }) {
    return ViewControlsState(
      searchTerm: searchTerm ?? this.searchTerm,
      selectedType: selectedType ?? this.selectedType,
      sortBy: sortBy ?? this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      gridColumns: gridColumns ?? this.gridColumns,
    );
  }

  @override
  List<Object?> get props => [
        searchTerm,
        selectedType,
        sortBy,
        sortDesc,
        gridColumns,
      ];
}

