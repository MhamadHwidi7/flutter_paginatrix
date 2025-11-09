/// Flutter Paginatrix - A simple, backend-agnostic pagination engine
///
/// This library provides a clean solution for handling paginated data
/// with caching and beautiful UI components.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_paginatrix/flutter_paginatrix.dart';
///
/// void main() {
///   runApp(MyApp());
/// }
/// ```
///
/// ## Core Features
///
/// - **Backend-agnostic**: Supports page/perPage, offset/limit, and cursor/tokens pagination
/// - **Simple API**: Easy to use with minimal configuration
/// - **UI Widgets**: Built-in list and grid views
library flutter_paginatrix;

// Core contracts
export 'src/core/contracts/meta_parser.dart';
// Core entities
export 'src/core/entities/page_meta.dart';
export 'src/core/entities/pagination_error.dart';
export 'src/core/entities/pagination_state.dart';
export 'src/core/entities/pagination_status.dart';
export 'src/core/entities/request_context.dart';
// Core enums
export 'src/core/enums/paginatrix_load_type.dart';
// Core models
export 'src/core/models/pagination_options.dart';
// Core typedefs
export 'src/core/typedefs/typedefs.dart';
// Core utilities
export 'src/core/utils/generation_guard.dart';
// Core helpers
export 'src/core/helpers/paginatrix_helpers.dart';
// Data layer - Meta parsers
export 'src/data/meta_parser/config_meta_parser.dart';
export 'src/data/meta_parser/custom_meta_parser.dart';
// Dependency injection
export 'src/di/paginatrix_dependency_injection.dart';
// Presentation layer - Controllers
export 'src/presentation/controllers/paginated_controller.dart';
// Presentation layer - UI widgets
export 'src/presentation/widgets/append_loader.dart';
export 'src/presentation/widgets/modern_loaders.dart';
export 'src/presentation/widgets/page_selector.dart';
export 'src/presentation/widgets/pagination_empty_view.dart';
export 'src/presentation/widgets/pagination_error_view.dart';
export 'src/presentation/widgets/pagination_shimmer.dart';
export 'src/presentation/widgets/pagination_type.dart';
export 'src/presentation/widgets/paginatrix_grid_view.dart';
export 'src/presentation/widgets/paginatrix_list_view.dart';
