// Import base PaginationEvent to extend it
import 'package:shared/bloc/pagination_event.dart';

// Re-export all base events from shared package
export 'package:shared/bloc/pagination_event.dart';

/// Additional events specific to search_advanced
/// Base events are imported and re-exported from shared package

/// Event to update search term
class UpdateSearch extends PaginationEvent {
  const UpdateSearch(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

/// Event to update type filter
class UpdateTypeFilter extends PaginationEvent {
  const UpdateTypeFilter(this.type);

  final String? type;

  @override
  List<Object?> get props => [type];
}

/// Event to update sorting
class UpdateSorting extends PaginationEvent {
  const UpdateSorting({
    this.sortBy,
    this.sortDesc = false,
  });

  final String? sortBy;
  final bool sortDesc;

  @override
  List<Object?> get props => [sortBy, sortDesc];
}

/// Event to clear all filters
class ClearAllFilters extends PaginationEvent {
  const ClearAllFilters();
}
