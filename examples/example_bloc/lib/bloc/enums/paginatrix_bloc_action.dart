library;

/// Paginatrix BLoC action enumeration
///
/// Defines the different types of pagination actions that can be
/// executed through the BLoC pattern.
enum PaginatrixBlocAction {
  /// Load the first page (resets the list and starts fresh)
  loadFirst,

  /// Load the next page (appends new data to existing list)
  loadNext,

  /// Refresh the current data (reloads first page and replaces all items)
  refresh,

  /// Retry the last failed operation
  retry,

  /// Clear all data and reset to initial state
  clear,
}

