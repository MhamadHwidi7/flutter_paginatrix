import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

/// Simple example showing usage without importing flutter_bloc
///
/// This demonstrates that users don't need to add flutter_bloc
/// to their pubspec.yaml or import it directly.
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatrixController<User> _pagination;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _pagination = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _pagination.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data; // {data: [...], meta: {...}}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: PaginatrixListView<User>(
        controller: _pagination,
        itemBuilder: (context, user, index) {
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
        appendLoaderBuilder: (context) => const AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more users...',
        ),
        onPullToRefresh: () => _pagination.refresh(),
      ),
    );
  }

  @override
  void dispose() {
    _pagination.close();
    super.dispose();
  }
}

/// Simple User model for demonstration
class User {
  const User({required this.name, required this.email});

  final String name;
  final String email;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UsersPage(),
  ));
}
