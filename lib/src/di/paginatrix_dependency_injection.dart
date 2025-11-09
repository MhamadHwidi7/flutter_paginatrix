import 'package:dio/dio.dart';

import '../core/contracts/meta_parser.dart';
import '../core/models/pagination_options.dart';
import '../data/meta_parser/config_meta_parser.dart';

/// Paginatrix dependency injection container
///
/// Provides a simple dependency injection solution for pagination services
/// without requiring external DI packages. Manages registration and retrieval
/// of dependencies like MetaParser, Dio, and PaginationOptions.
class PaginatrixDI {
  static final Map<Type, dynamic> _instances = {};
  static final Map<String, dynamic> _namedInstances = {};

  /// Configures all dependencies
  static Future<void> configure({
    String environment = 'dev',
    bool isTest = false,
  }) async {
    // Clear existing registrations
    _instances.clear();
    _namedInstances.clear();

    // Configure environment-specific settings
    await _configureEnvironment(environment, isTest);

    // Register core services
    _registerCoreServices();

    // Register environment-specific services
    await _registerEnvironmentServices(environment, isTest);
  }

  /// Configures environment-specific settings
  static Future<void> _configureEnvironment(
      String environment, bool isTest) async {
    switch (environment) {
      case 'dev':
        await _configureDevEnvironment();
        break;
      case 'prod':
        await _configureProdEnvironment();
        break;
      case 'test':
        await _configureTestEnvironment();
        break;
      default:
        throw ArgumentError('Unknown environment: $environment');
    }
  }

  /// Development environment configuration
  static Future<void> _configureDevEnvironment() async {
    _namedInstances['debugLogging'] = true;
    _namedInstances['requestTimeout'] = const Duration(seconds: 60);
  }

  /// Production environment configuration
  static Future<void> _configureProdEnvironment() async {
    _namedInstances['debugLogging'] = false;
    _namedInstances['requestTimeout'] = const Duration(seconds: 30);
  }

  /// Test environment configuration
  static Future<void> _configureTestEnvironment() async {
    _namedInstances['debugLogging'] = false;
    _namedInstances['requestTimeout'] = const Duration(seconds: 5);
  }

  /// Registers core services
  static void _registerCoreServices() {
    // Pagination options
    _instances[PaginationOptions] = PaginationOptions(
      requestTimeout: _namedInstances['requestTimeout'] as Duration,
      enableDebugLogging: _namedInstances['debugLogging'] as bool,
    );
  }

  /// Registers environment-specific services
  static Future<void> _registerEnvironmentServices(
      String environment, bool isTest) async {
    // Meta parser
    const config = MetaConfig(
      pagePath: 'meta.current_page',
      perPagePath: 'meta.per_page',
      totalPath: 'meta.total',
      lastPagePath: 'meta.last_page',
      hasMorePath: 'meta.has_more',
      nextCursorPath: 'meta.next_cursor',
      offsetPath: 'meta.offset',
      itemsPath: 'data',
    );
    _instances[MetaParser] = ConfigMetaParser(config);

    // Dio client
    final dio = Dio();
    dio.options.connectTimeout = _namedInstances['requestTimeout'] as Duration;
    dio.options.receiveTimeout = _namedInstances['requestTimeout'] as Duration;
    _instances[Dio] = dio;

    // These are not needed for basic functionality
  }

  /// Gets a dependency
  static T get<T extends Object>({String? instanceName}) {
    if (instanceName != null) {
      if (!_namedInstances.containsKey(instanceName)) {
        throw StateError('Named instance $instanceName not registered');
      }
      return _namedInstances[instanceName] as T;
    }
    if (!_instances.containsKey(T)) {
      throw StateError('Instance of type $T not registered');
    }
    return _instances[T] as T;
  }

  /// Checks if a dependency is registered
  static bool isRegistered<T extends Object>({String? instanceName}) {
    if (instanceName != null) {
      return _namedInstances.containsKey(instanceName);
    }
    return _instances.containsKey(T);
  }

  /// Resets all dependencies
  static Future<void> reset() async {
    _instances.clear();
    _namedInstances.clear();
  }
}
