library;

/// Paginatrix load type enumeration
///
/// Defines the different types of data loading operations available
/// in the Paginatrix pagination system.
enum PaginatrixLoadType {
  /// Load the first page (resets the list and starts fresh)
  first,

  /// Load the next page (appends new data to existing list)
  next,

  /// Refresh the current data (reloads first page and replaces all items)
  refresh,
}

