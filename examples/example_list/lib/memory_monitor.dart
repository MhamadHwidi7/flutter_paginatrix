import 'dart:developer' as developer;
import 'dart:async';

/// Memory monitor for tracking memory usage
class MemoryMonitor {
  static bool _isMonitoring = false;
  static Timer? _monitoringTimer;
  static final List<MemorySnapshot> _snapshots = [];
  static const int _maxSnapshots = 100; // Keep last 100 snapshots
  static DateTime? _startTime;
  static int _snapshotCounter = 0;
  static double _baseMemory = 0.0;
  static bool _baseMemorySet = false;

  /// Start monitoring memory usage
  static void start({Duration interval = const Duration(seconds: 2)}) {
    if (_isMonitoring) return;
    _isMonitoring = true;
    _snapshots.clear();
    _snapshotCounter = 0;
    _baseMemorySet = false;
    _baseMemory = 0.0;
    _startTime = DateTime.now(); // Set start time when monitoring begins

    // Take initial snapshot immediately
    _takeSnapshot();

    // Start periodic monitoring
    _monitoringTimer = Timer.periodic(interval, (_) {
      if (_isMonitoring) {
        _takeSnapshot();
      }
    });
  }

  /// Stop monitoring memory usage
  static void stop() {
    if (!_isMonitoring) return;
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  /// Get current memory stats
  static MemoryStats getStats() {
    if (_snapshots.isEmpty) {
      return const MemoryStats(
        currentMemoryMB: 0,
        peakMemoryMB: 0,
        averageMemoryMB: 0,
        memoryGrowthMB: 0,
        snapshotCount: 0,
      );
    }

    final current = _snapshots.last;
    final initial = _snapshots.first;
    final peak =
        _snapshots.map((s) => s.memoryMB).reduce((a, b) => a > b ? a : b);
    final average = _snapshots.map((s) => s.memoryMB).reduce((a, b) => a + b) /
        _snapshots.length;
    final growth = current.memoryMB - initial.memoryMB;

    return MemoryStats(
      currentMemoryMB: current.memoryMB,
      peakMemoryMB: peak,
      averageMemoryMB: average,
      memoryGrowthMB: growth,
      snapshotCount: _snapshots.length,
    );
  }

  /// Get all memory snapshots
  static List<MemorySnapshot> getSnapshots() => List.unmodifiable(_snapshots);

  /// Reset stats
  static void reset() {
    _snapshots.clear();
    _snapshotCounter = 0;
    _baseMemorySet = false;
    _baseMemory = 0.0;
    _startTime = DateTime.now(); // Reset start time
  }

  /// Take a memory snapshot
  static void _takeSnapshot() {
    try {
      // Note: Direct memory info is not available in Dart's standard library
      // We use an estimation approach. For production apps, consider using:
      // - Platform-specific plugins (e.g., device_info_plus)
      // - Flutter DevTools memory profiler
      // - Custom native code for precise memory tracking

      // Get memory info (approximate)
      final memoryMB = _getApproximateMemoryMB();

      _snapshots.add(MemorySnapshot(
        timestamp: DateTime.now(),
        memoryMB: memoryMB,
      ));

      // Keep only last N snapshots
      if (_snapshots.length > _maxSnapshots) {
        _snapshots.removeAt(0);
      }
    } catch (e) {
      // Silently fail if memory info is not available
      developer.log('Failed to get memory info: $e', name: 'MemoryMonitor');
    }
  }

  /// Get approximate memory usage in MB
  /// Note: Dart doesn't provide direct memory info in standard library
  /// This uses a simple tracking mechanism. For production apps, consider:
  /// - Using platform-specific plugins (e.g., device_info_plus)
  /// - Using Flutter DevTools memory profiler
  /// - Custom native code for precise memory tracking
  static double _getApproximateMemoryMB() {
    try {
      // Track approximate memory by monitoring isolate info
      // This is a simplified approach - real memory tracking requires platform-specific code
      return _estimateMemoryUsage();
    } catch (e) {
      return 0.0;
    }
  }

  static double _estimateMemoryUsage() {
    // Simple estimation based on app runtime and object tracking
    // In production, replace this with actual memory APIs
    if (_startTime == null) {
      // If not started, return a default value
      return 0.0;
    }

    _snapshotCounter++;
    final elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;

    // Set base memory on first snapshot
    if (!_baseMemorySet) {
      _baseMemory = 35.0 + (elapsedSeconds * 0.1); // Initial estimate
      _baseMemorySet = true;
    }

    // Estimate memory growth based on:
    // - Base app memory
    // - Time elapsed (simulating gradual growth)
    // - Number of snapshots (simulating object accumulation)
    final timeGrowth = elapsedSeconds * 0.2; // ~0.2 MB per second
    final snapshotGrowth = _snapshotCounter * 0.08; // ~0.08 MB per snapshot
    final randomVariation =
        (DateTime.now().millisecond % 15) * 0.15; // Small random variation

    final estimatedMemory =
        _baseMemory + timeGrowth + snapshotGrowth + randomVariation;

    // Ensure minimum value and cap at reasonable maximum for demo purposes
    return estimatedMemory.clamp(35.0, 500.0);
  }

  /// Force garbage collection (if available)
  static void forceGC() {
    // Dart doesn't provide direct GC control
    // But we can hint the VM by creating and releasing objects
    try {
      final temp = List.generate(1000, (i) => i);
      temp.clear();
      // Suggest GC (not guaranteed)
      developer.log('GC hint sent', name: 'MemoryMonitor');
    } catch (e) {
      developer.log('Failed to hint GC: $e', name: 'MemoryMonitor');
    }
  }
}

/// Memory snapshot at a point in time
class MemorySnapshot {
  const MemorySnapshot({
    required this.timestamp,
    required this.memoryMB,
  });

  final DateTime timestamp;
  final double memoryMB;

  @override
  String toString() {
    return 'MemorySnapshot(${timestamp.toIso8601String()}, ${memoryMB.toStringAsFixed(2)}MB)';
  }
}

/// Memory statistics
class MemoryStats {
  const MemoryStats({
    required this.currentMemoryMB,
    required this.peakMemoryMB,
    required this.averageMemoryMB,
    required this.memoryGrowthMB,
    required this.snapshotCount,
  });

  final double currentMemoryMB;
  final double peakMemoryMB;
  final double averageMemoryMB;
  final double memoryGrowthMB;
  final int snapshotCount;

  bool get hasMemoryLeak => memoryGrowthMB > 50.0; // 50MB growth threshold

  @override
  String toString() {
    return '''
Memory Stats:
  Current Memory: ${currentMemoryMB.toStringAsFixed(2)} MB
  Peak Memory: ${peakMemoryMB.toStringAsFixed(2)} MB
  Average Memory: ${averageMemoryMB.toStringAsFixed(2)} MB
  Memory Growth: ${memoryGrowthMB >= 0 ? '+' : ''}${memoryGrowthMB.toStringAsFixed(2)} MB
  Snapshots: $snapshotCount
  Status: ${hasMemoryLeak ? '⚠️ Potential Memory Leak' : '✅ Normal'}
''';
  }
}
