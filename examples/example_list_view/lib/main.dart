import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'memory_monitor.dart';
import 'performance_monitor.dart';

void main() {
  // Ensure Flutter binding is initialized before accessing SchedulerBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Start performance monitoring
  PerformanceMonitor.start();
  MemoryMonitor.start();

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
    final config = BuildConfig.current;

    _cubit = PaginatedCubit<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      // Use environment-specific options with custom page size
      options: config.defaultPaginationOptions.copyWith(
        defaultPageSize: 50, // 50 items per page
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
    CancelToken? cancelToken,
  }) async {
    // Simulate API delay to see loading state
    await Future.delayed(const Duration(seconds: 2));

    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 50; // Default to 50 items per page
    const totalItems = 5000; // Total of 5000 items
    final totalPages =
        (totalItems / itemsPerPage).ceil(); // 5000 / 50 = 100 pages

    // Generate mock users
    final users = List.generate(
      itemsPerPage,
      (index) {
        final id = (currentPage - 1) * itemsPerPage + index + 1;
        // Ensure ID doesn't exceed total items
        final userId = id <= totalItems ? id : id % totalItems;
        return {
          'id': userId,
          'name': 'User $userId',
          'email': 'user$userId@example.com',
          'avatar': 'https://i.pravatar.cc/150?img=${(userId % 70) + 1}',
        };
      },
    );

    return {
      'data': users,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': totalItems,
        'last_page': totalPages,
        'has_more': currentPage < totalPages,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'View Memory & Performance Stats',
            onPressed: () {
              _showStatsDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<PaginatedCubit<User>, PaginationState<User>>(
        bloc: _cubit,
        builder: (context, state) {
          return Stack(
            children: [
              PaginatrixListView<User>(
                cubit: _cubit,
                padding: const EdgeInsets.symmetric(vertical: 8),
                // Performance optimizations
                cacheExtent:
                    250, // Limit off-screen items for better memory usage
                prefetchThreshold: 2, // Load next page when 200px from end
                itemBuilder: (context, user, index) {
                  return _UserListItem(user: user);
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
                // Custom loading indicator - choose any LoaderType
                appendLoaderBuilder: (context) => AppendLoader(
                  loaderType: LoaderType
                      .wave, // Options: bouncingDots, wave, rotatingSquares, pulse, skeleton, traditional
                  message: 'Loading more users...',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                  padding: const EdgeInsets.all(16),
                ),
                onPullToRefresh: () {
                  // Optional: Add custom refresh logic
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showStatsDialog(context);
        },
        tooltip: 'Memory & Performance Stats',
        child: const Icon(Icons.memory),
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    final memoryStats = MemoryMonitor.getStats();
    final performanceStats = PerformanceMonitor.getStats();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.blue),
            SizedBox(width: 8),
            Text('Memory & Performance Stats'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Memory Stats Section
              const Text(
                '📊 Memory Usage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatRow('Current Memory',
                  '${memoryStats.currentMemoryMB.toStringAsFixed(2)} MB'),
              _buildStatRow('Peak Memory',
                  '${memoryStats.peakMemoryMB.toStringAsFixed(2)} MB'),
              _buildStatRow('Average Memory',
                  '${memoryStats.averageMemoryMB.toStringAsFixed(2)} MB'),
              _buildStatRow(
                'Memory Growth',
                '${memoryStats.memoryGrowthMB >= 0 ? '+' : ''}${memoryStats.memoryGrowthMB.toStringAsFixed(2)} MB',
                color: memoryStats.memoryGrowthMB > 0
                    ? Colors.orange
                    : Colors.green,
              ),
              _buildStatRow('Snapshots', '${memoryStats.snapshotCount}'),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: memoryStats.hasMemoryLeak
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      memoryStats.hasMemoryLeak
                          ? Icons.warning
                          : Icons.check_circle,
                      color:
                          memoryStats.hasMemoryLeak ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        memoryStats.hasMemoryLeak
                            ? '⚠️ Potential Memory Leak Detected'
                            : '✅ Memory Usage Normal',
                        style: TextStyle(
                          color: memoryStats.hasMemoryLeak
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              // Performance Stats Section
              const Text(
                '⚡ Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatRow('Total Frames', '${performanceStats.totalFrames}'),
              _buildStatRow('Jank Frames', '${performanceStats.jankFrames}'),
              _buildStatRow(
                'Jank Percentage',
                '${performanceStats.jankPercentage.toStringAsFixed(2)}%',
                color: performanceStats.jankPercentage > 1.0
                    ? Colors.orange
                    : Colors.green,
              ),
              _buildStatRow('Avg Frame Time',
                  '${performanceStats.averageFrameTime.toStringAsFixed(2)} ms'),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: performanceStats.hasJank
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      performanceStats.hasJank
                          ? Icons.warning
                          : Icons.check_circle,
                      color: performanceStats.hasJank
                          ? Colors.orange
                          : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        performanceStats.hasJank
                            ? '⚠️ Jank Detected (>1%)'
                            : '✅ Smooth Performance',
                        style: TextStyle(
                          color: performanceStats.hasJank
                              ? Colors.orange.shade900
                              : Colors.green.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              MemoryMonitor.reset();
              PerformanceMonitor.reset();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stats reset')),
              );
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
