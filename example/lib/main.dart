import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paginatrix Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UsersPage(),
    );
  }
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;
  final String role;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatrixCubit<User> _cubit;

  @override
  void initState() {
    super.initState();
    final config = BuildConfig.current;

    _cubit = PaginatrixCubit<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        enableDebugLogging: true,
        defaultPageSize: config.defaultPaginationOptions.defaultPageSize,
        searchDebounceDuration:
            config.defaultPaginationOptions.searchDebounceDuration,
        refreshDebounceDuration:
            config.defaultPaginationOptions.refreshDebounceDuration,
      ),
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
    QueryCriteria? query,
    CancelToken? cancelToken,
  }) async {
    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 20;

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock users
    final users = List.generate(
      itemsPerPage,
      (index) {
        final id = (currentPage - 1) * itemsPerPage + index + 1;
        return {
          'id': id,
          'name': 'User $id',
          'email': 'user$id@example.com',
          'avatar': 'https://i.pravatar.cc/150?img=$id',
          'role': _getRole(id),
        };
      },
    );

    const totalPages = 10;
    final hasMore = currentPage < totalPages;

    return {
      'data': users,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': 200,
        'last_page': totalPages,
        'has_more': hasMore,
      },
    };
  }

  String _getRole(int id) {
    final roles = ['Admin', 'User', 'Moderator', 'Guest', 'Editor'];
    return roles[id % roles.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _cubit.refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: PaginatrixListView<User>(
        cubit: _cubit,
        padding: const EdgeInsets.all(8),
        cacheExtent: 250,
        prefetchThreshold: 1,
        endOfListMessage: 'No more users to load',
        itemBuilder: (context, user, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Chip(
                label: Text(
                  user.role,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
        },
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more users...',
          color: Theme.of(context).colorScheme.primary,
          size: 28,
          padding: const EdgeInsets.all(20),
        ),
        onPullToRefresh: () {
          _cubit.refresh();
        },
      ),
    );
  }
}
