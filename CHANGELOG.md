# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-11-27

### Refactored

- **Reduced Code Duplication**: Extracted common logic from `PaginatrixGridView` and `PaginatrixListView` into `PaginatrixStateBuilderMixin`.
  - Moved `buildScrollableContent` and `buildLoadingState` to the mixin.
  - Introduced abstract methods `buildMainSliver`, `buildLoadingSliver`, and `buildDefaultSkeletonizer` for specific implementations.
- **Improved README**: Completely overhauled `README.md` to be more comprehensive, visual, and helpful.
  - Added badges for pub points, license, CI/CD, and version.
  - Added "Common Pitfalls" section.
  - Improved "Why Flutter Paginatrix?" section.
  - Added clear sections for Features, Installation, Quick Start, Basic Usage, Advanced Usage, API Overview.

### Verified

- **Tests**: Verified all changes with `flutter test`.
- **Analysis**: Verified code quality with `dart analyze`.
- **Formatting**: Formatted all code with `dart format`.

---

## [1.0.0] - 2025-11-16

### Added

- **Initial release** of Flutter Paginatrix - A simple, flexible, and backend-agnostic pagination package
- **PaginatrixCubit** / **PaginatrixController** - Cubit-based controller for managing paginated data with automatic state management
- **PaginatrixListView** - ListView widget with built-in pagination support using Slivers
- **PaginatrixGridView** - GridView widget with built-in pagination support using Slivers
- **Multiple pagination strategies**:
  - Page-based pagination (page/perPage)
  - Offset-based pagination (offset/limit)
  - Cursor-based pagination (cursor/token)
- **Meta parsers**:
  - `ConfigMetaParser` - Pre-configured parsers for common API formats (nestedMeta, resultsFormat, pageBased, offsetBased)
  - `CustomMetaParser` - Flexible parser for custom API response structures
- **Comprehensive error handling** with 6 error types:
  - Network errors (connection issues, timeouts, HTTP errors)
  - Parse errors (invalid response format, missing keys)
  - Cancelled errors (request cancellation)
  - Rate limited errors (too many requests)
  - Circuit breaker errors (service unavailable)
  - Unknown errors (unexpected errors)
- **Request cancellation** - Automatic cleanup of in-flight requests
- **Generation guards** - Prevents stale responses and race conditions
- **Retry mechanism** - Exponential backoff retry for failed operations
- **Refresh debouncing** - Prevents rapid successive refresh calls
- **UI Components**:
  - `AppendLoader` - Beautiful loading widget with 6 animation types (circular, linear, pulse, rotating, wave, bouncingDots)
  - `PaginatrixErrorView` - Error display with retry functionality
  - `PaginatrixAppendErrorView` - Inline error view for append failures
  - `PaginatrixEmptyView` - Empty state display
  - `PaginatrixGenericEmptyView` - Predefined generic empty view
  - `PaginatrixSearchEmptyView` - Predefined search empty view
  - `PaginatrixNetworkEmptyView` - Predefined network empty view
  - `PaginationSkeletonizer` - Skeleton loading effect
  - `PageSelector` - Page selection widget with multiple display styles (buttons, dropdown, compact)
- **Build flavors** - Development and Production configurations via `BuildConfig`
- **Comprehensive test suite** - 171 tests covering:
  - Unit tests for entities and controllers
  - Integration tests for complete pagination flows
  - Widget tests for UI components
  - Performance tests for large datasets
  - Edge case coverage (empty responses, errors, cancellation, race conditions)
- **Code coverage** - Full test coverage with codecov integration
- **CI/CD pipeline** - Automated testing, building, and publishing via GitHub Actions
- **Documentation**:
  - Comprehensive README with examples
  - API reference documentation
  - Multiple example applications
  - CI/CD setup guide
  - Pub.dev credentials guide

### Features

- **Backend-agnostic** - Works with any API structure
- **Type-safe** - Full generics support with immutable data structures
- **Reactive** - Stream-based state management with flutter_bloc
- **Performance optimized** - Sliver-based architecture for smooth scrolling
- **Zero external dependencies** - No complex DI frameworks required
- **Memory efficient** - Proper disposal and cleanup
- **Developer-friendly** - Simple API with minimal configuration

### Examples

- `list_view` - PaginatrixListView with performance monitoring
- `grid_view` - PaginatrixGridView pagination
- `bloc_pattern` - BLoC pattern integration with custom events
- `cubit_direct` - Direct PaginatrixCubit usage
- `search_basic` - Basic search functionality with pagination
- `search_advanced` - Advanced search with filters, sorting, and pagination
- `web_infinite_scroll` - Web infinite scroll pagination
- `web_page_selector` - Web page selector pagination

### Documentation

- Complete API reference
- Usage examples for all features
- Integration guides for different state management patterns
- Error handling best practices
- Performance optimization tips

---

## [1.0.2] - 2025-11-20

### Added

- Comprehensive documentation for all loader classes (BouncingDotsLoader, WaveLoader, RotatingSquaresLoader, PulseLoader, SkeletonLoader)
- Comprehensive documentation for PageSelector widget and PageSelectorStyle enum
- Comprehensive documentation for predefined empty view widgets (PaginatrixSearchEmptyView, PaginatrixNetworkEmptyView, PaginatrixGenericEmptyView)
- Complete example/README.md with detailed documentation for all examples

### Changed

- Renamed `paginatrix_empty_views.dart` to `paginatrix_predefined_empty_views.dart` for better clarity
- Reorganized example directory structure:
  - Main example moved to `example/` root (recognized by pub.dev)
  - Additional examples moved to `example/examples/` subdirectory
- Updated main README with new example directory structure

### Improved

- Enhanced documentation coverage across all widget classes
- Improved example organization and discoverability
- Updated all documentation with examples and parameter descriptions

---

## [1.0.1] - 2025-11-20

### Fixed

- Fixed static analysis issues (redundant argument values, dynamic calls)
- Fixed missing `abstract` keyword in Freezed classes (`PageMeta`, `PaginationError`, `PaginationState`, `QueryCriteria`, `RequestContext`, `PaginationOptions`, `MetaConfig`)
- Fixed `maybeWhen` usage in `PaginationStateExtension` - replaced with `whenOrNull` for Dart 3.x compatibility
- Fixed CI/CD workflow path for example dependencies

### Changed

- Updated dependencies to latest compatible versions:
  - `freezed_annotation: ^2.4.1` → `^3.1.0`
  - `freezed: ^2.4.6` → `^3.2.3`
  - `flutter_lints: ^3.0.1` → `^6.0.0`
  - `build_runner: ^2.4.7` → `^2.7.1`
  - `json_serializable: ^6.7.1` → `^6.11.1`
  - `dartdoc: ^7.0.0` → `^8.3.4`
- Refactored `showFlutterToast` to `showToast` using `fluttertoast` package directly
- Added `fluttertoast: ^8.2.4` as a direct dependency

### Added

- Added root-level `example/` directory for pub.dev recognition
- Added comprehensive documentation for `AppendLoader` class and properties
- Added Table of Contents to README
- Added new badges (Pub Points, Popularity, Likes, Platform) to README
- Added Contributing section to README

### Improved

- Improved README completeness and structure
- Improved code formatting and static analysis compliance
- Improved documentation coverage (72.2% → higher)

---

## [Unreleased]

### Planned

- Additional meta parser configurations
- More UI component variations
- Performance monitoring utilities
- Advanced caching strategies

---

[1.0.3]: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/tag/v1.0.3
[1.0.2]: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/tag/v1.0.2
[1.0.1]: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/tag/v1.0.1
[1.0.0]: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/tag/v1.0.0
