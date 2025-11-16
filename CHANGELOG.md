# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [Unreleased]

### Planned
- Additional meta parser configurations
- More UI component variations
- Performance monitoring utilities
- Advanced caching strategies

---

[1.0.0]: https://github.com/MhamadHwidi7/flutter_paginatrix/releases/tag/v1.0.0

