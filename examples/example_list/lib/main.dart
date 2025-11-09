import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  // Start performance monitoring (optional)
  // PerformanceMonitor.start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paginatrix Example',
      // Enable performance overlay to check for jank frames
      // Remove this in production or set to false
      showPerformanceOverlay: true, // Set to true to see FPS and frame times
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UsersPage(),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatedCubit<User> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PaginatedCubit<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _cubit.loadFirstPage();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    // Simulate API delay to see loading state
    await Future.delayed(const Duration(seconds: 2));

    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 20;

    // Generate mock users
    final users = List.generate(
      itemsPerPage,
      (index) {
        final id = (currentPage - 1) * itemsPerPage + index + 1;
        return {
          'id': id,
          'name': 'User $id',
          'email': 'user$id@example.com',
          'avatar': 'https://i.pravatar.cc/150?img=${(id % 70) + 1}',
        };
      },
    );

    return {
      'data': users,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': 100,
        'last_page': 5,
        'has_more': currentPage < 5,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        elevation: 0,
      ),
      body: PaginatrixListView<User>(
        cubit: _cubit,
        padding: const EdgeInsets.symmetric(vertical: 8),
        // Performance optimizations
        cacheExtent: 250, // Limit off-screen items for better memory usage
        prefetchThreshold: 2, // Load next page when 200px from end
        itemBuilder: (context, user, index) {
          return _UserListItem(user: user);
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        // Custom loading indicator - choose any LoaderType
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType.wave, // Options: bouncingDots, wave, rotatingSquares, pulse, skeleton, traditional
          message: 'Loading more users...',
          color: Theme.of(context).colorScheme.primary,
          size: 24,
          padding: const EdgeInsets.all(16),
        ),
        onPullToRefresh: () {
          // Optional: Add custom refresh logic
        },
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;

  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.avatar,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          memCacheWidth: 100,
          memCacheHeight: 100,
          maxWidthDiskCache: 200,
          maxHeightDiskCache: 200,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Container(
              width: 40,
              height: 40,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: downloadProgress.progress,
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              width: 40,
              height: 40,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: Text(
                  user.name[0],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          },
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
      title: Text(
        user.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        user.email,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String? ?? '',
    );
  }
}
