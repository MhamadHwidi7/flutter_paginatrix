import '../entities/request_context.dart';

/// Utility for preventing stale responses using generation numbers
class GenerationGuard {
  int _currentGeneration = 0;
  
  /// Gets the current generation number
  int get currentGeneration => _currentGeneration;
  
  /// Increments the generation number and returns the new value
  /// 
  /// This should be called when starting a new request to invalidate
  /// any previous requests that might still be in flight
  int incrementGeneration() {
    _currentGeneration++;
    return _currentGeneration;
  }
  
  /// Checks if a request context is still valid (not stale)
  /// 
  /// [context] - Request context to check
  /// 
  /// Returns true if the context is still valid
  bool isValid(RequestContext context) {
    return context.generation == _currentGeneration;
  }
  
  /// Checks if a request context is stale
  /// 
  /// [context] - Request context to check
  /// 
  /// Returns true if the context is stale
  bool isStale(RequestContext context) {
    return !isValid(context);
  }
  
  /// Resets the generation counter
  void reset() {
    _currentGeneration = 0;
  }
}
