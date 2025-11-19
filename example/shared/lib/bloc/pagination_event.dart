import 'package:equatable/equatable.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Base class for pagination events
///
/// All events are immutable and use Equatable for value equality.
/// This ensures proper event comparison and prevents duplicate event processing.
abstract class PaginationEvent extends Equatable {
  /// Creates a new immutable pagination event
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the first page (resets the list and starts fresh)
class LoadFirstPage extends PaginationEvent {
  const LoadFirstPage();
}

/// Event to load the next page (appends new data to existing list)
class LoadNextPage extends PaginationEvent {
  const LoadNextPage();
}

/// Event to refresh the current data
class RefreshPage extends PaginationEvent {
  const RefreshPage();
}

/// Event to retry the last failed operation
class RetryPagination extends PaginationEvent {
  const RetryPagination();
}

/// Event to clear all data
class ClearPagination extends PaginationEvent {
  const ClearPagination();
}

/// Internal event to sync controller state changes to BLoC
/// This is used when controller state changes outside of BLoC events
/// (e.g., automatic pagination on scroll)
///
/// Note: This is a non-generic event that carries the state as dynamic
/// to avoid type parameter issues. The type is guaranteed at runtime.
class ControllerStateChanged extends PaginationEvent {
  const ControllerStateChanged(this.paginationState);

  /// The pagination state from the controller (type: PaginationState<T>)
  final PaginationState paginationState;

  @override
  List<Object?> get props => [paginationState];
}
