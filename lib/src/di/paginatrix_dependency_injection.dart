/// Paginatrix simple dependency injection container
///
/// A minimal DI solution for registering and retrieving dependencies
/// in your pagination implementation. This is optional and most users
/// can simply create instances directly.
///
/// ## Usage
///
/// ```dart
/// // Register dependencies
/// PaginatrixDI.register<Dio>(Dio());
/// PaginatrixDI.register<MetaParser>(
///   ConfigMetaParser(MetaConfig.nestedMeta)
/// );
///
/// // Retrieve dependencies
/// final dio = PaginatrixDI.get<Dio>();
/// final parser = PaginatrixDI.get<MetaParser>();
///
/// // Clean up (useful in tests)
/// PaginatrixDI.reset();
/// ```
///
/// ## Note
/// This is a simple service locator pattern. For more complex DI needs,
/// consider using dedicated packages like get_it, provider, or riverpod.
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
