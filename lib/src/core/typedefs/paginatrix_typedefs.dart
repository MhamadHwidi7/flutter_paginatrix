import 'package:flutter_paginatrix/src/presentation/controllers/paginatrix_cubit.dart';

/// Public API for managing paginated data
///
/// This is the recommended way to use flutter_paginatrix. It provides
/// a clean, package-consistent API without exposing implementation details.
///
/// **Why PaginatrixController?**
/// - Consistent with package naming (`PaginatrixListView`, `PaginatrixGridView`)
/// - Clean and intuitive API
/// - No need to import `flutter_bloc` directly
/// - Implementation-agnostic (uses `PaginatrixCubit` internally)
///
/// ## Usage
///
/// ```dart
/// final controller = PaginatrixController<User>(
///   loader: _loadUsers,
///   itemDecoder: User.fromJson,
///   metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
/// );
///
/// PaginatrixListView<User>(
///   controller: controller,
///   itemBuilder: (context, user, index) => UserTile(user: user),
/// )
/// ```
///
/// **Note:** For advanced usage with `BlocProvider` and `BlocBuilder`, you can
/// still use `PaginatrixCubit` directly, which this type aliases to.
typedef PaginatrixController<T> = PaginatrixCubit<T>;
