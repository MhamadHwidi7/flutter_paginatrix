/// Internal service locator for dependency injection.
///
/// **This is an internal utility and is not part of the public API.**
/// It is not exported from the main library and should not be used by
/// consumers of the package.
///
/// This class is available for internal use within the package if needed,
/// but the core pagination classes do not depend on it. All public APIs
/// accept dependencies through constructors or parameters.
class PaginatrixDI {
  static final Map<Type, dynamic> _instances = {};

  /// Registers an instance of type [T]
  ///
  /// Example:
  /// ```dart
  /// PaginatrixDI.register<Dio>(Dio());
  /// ```
  static void register<T>(T instance) {
    _instances[T] = instance;
  }

  /// Retrieves the registered instance of type [T]
  ///
  /// Throws [StateError] if [T] is not registered.
  ///
  /// Example:
  /// ```dart
  /// final dio = PaginatrixDI.get<Dio>();
  /// ```
  static T get<T>() {
    if (!_instances.containsKey(T)) {
      throw StateError(
        'Instance of type $T not registered. '
        'Call PaginatrixDI.register<$T>(instance) first.',
      );
    }
    return _instances[T] as T;
  }

  /// Checks if an instance of type [T] is registered
  ///
  /// Example:
  /// ```dart
  /// if (PaginatrixDI.isRegistered<Dio>()) {
  ///   final dio = PaginatrixDI.get<Dio>();
  /// }
  /// ```
  static bool isRegistered<T>() {
    return _instances.containsKey(T);
  }

  /// Clears all registered instances
  ///
  /// Useful for testing or when you want to reset the DI container.
  ///
  /// Example:
  /// ```dart
  /// tearDown(() {
  ///   PaginatrixDI.reset();
  /// });
  /// ```
  static void reset() {
    _instances.clear();
  }

  /// Returns the number of registered instances
  ///
  /// Useful for debugging or testing.
  static int get registeredCount => _instances.length;
}
