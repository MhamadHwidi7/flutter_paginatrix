import 'package:flutter_paginatrix/src/core/models/pagination_options.dart';

/// Build configuration for different environments
///
/// This class provides environment-specific configurations for development
/// and production builds. Use [BuildConfig.current] to get the active
/// configuration based on compile-time constants.
class BuildConfig {
  /// Development configuration
  const BuildConfig.development()
      : isProduction = false,
        enableDebugLogging = true,
        verboseErrors = true,
        enablePerformanceMonitoring = true,
        includeStackTraces = true,
        defaultPaginationOptions = const PaginationOptions(
          enableDebugLogging: true,
        );

  /// Production configuration
  const BuildConfig.production()
      : isProduction = true,
        enableDebugLogging = false,
        verboseErrors = false,
        enablePerformanceMonitoring = false,
        includeStackTraces = false,
        defaultPaginationOptions = PaginationOptions.defaultOptions;

  /// Current build configuration
  ///
  /// Returns the active configuration based on compile-time constants.
  /// This is set via build flags or environment variables.
  // ignore: prefer_constructors_over_static_methods
  static BuildConfig get current {
    // Use compile-time constant to determine environment
    const bool isProduction =
        bool.fromEnvironment('PRODUCTION');

    return isProduction
        ? const BuildConfig.production()
        : const BuildConfig.development();
  }

  /// Whether this is a production build
  final bool isProduction;

  /// Whether debug logging is enabled
  final bool enableDebugLogging;

  /// Whether to include verbose error messages
  final bool verboseErrors;

  /// Whether to enable performance monitoring
  final bool enablePerformanceMonitoring;

  /// Whether to include stack traces in errors
  final bool includeStackTraces;

  /// Default pagination options for this environment
  final PaginationOptions defaultPaginationOptions;

  @override
  String toString() {
    return 'BuildConfig('
        'isProduction: $isProduction, '
        'enableDebugLogging: $enableDebugLogging, '
        'verboseErrors: $verboseErrors, '
        'enablePerformanceMonitoring: $enablePerformanceMonitoring'
        ')';
  }
}
