import 'package:flutter/scheduler.dart';

/// Performance monitor for detecting jank frames
class PerformanceMonitor {
  static bool _isMonitoring = false;
  static int _jankCount = 0;
  static int _totalFrames = 0;
  static double _totalFrameTime = 0.0;

  /// Start monitoring performance
  static void start() {
    if (_isMonitoring) return;
    _isMonitoring = true;
    _jankCount = 0;
    _totalFrames = 0;
    _totalFrameTime = 0.0;

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
  }

  /// Stop monitoring performance
  static void stop() {
    if (!_isMonitoring) return;
    _isMonitoring = false;
    // Note: There's no removeTimingsCallback in Flutter API
    // The callback will remain but won't process when _isMonitoring is false
  }

  /// Get current performance stats
  static PerformanceStats getStats() {
    final avgFrameTime = _totalFrames > 0 ? _totalFrameTime / _totalFrames : 0.0;
    final jankPercentage =
        _totalFrames > 0 ? (_jankCount / _totalFrames) * 100.0 : 0.0;

    return PerformanceStats(
      totalFrames: _totalFrames,
      jankFrames: _jankCount,
      averageFrameTime: avgFrameTime,
      jankPercentage: jankPercentage,
    );
  }

  /// Reset stats
  static void reset() {
    _jankCount = 0;
    _totalFrames = 0;
    _totalFrameTime = 0.0;
  }

  static void _onFrameTimings(List<FrameTiming> timings) {
    if (!_isMonitoring) return;
    
    for (final timing in timings) {
      _totalFrames++;
      
      // Calculate total frame time from build and raster durations
      final buildTime = timing.buildDuration.inMicroseconds / 1000.0;
      final rasterTime = timing.rasterDuration.inMicroseconds / 1000.0;
      final totalTime = buildTime + rasterTime;
      
      _totalFrameTime += totalTime;

      // Jank is when frame takes more than 16.67ms (60 FPS threshold)
      if (totalTime > 16.67) {
        _jankCount++;
      }
    }
  }
}

/// Performance statistics
class PerformanceStats {
  const PerformanceStats({
    required this.totalFrames,
    required this.jankFrames,
    required this.averageFrameTime,
    required this.jankPercentage,
  });

  final int totalFrames;
  final int jankFrames;
  final double averageFrameTime;
  final double jankPercentage;

  bool get hasJank => jankPercentage > 1.0;

  @override
  String toString() {
    return '''
Performance Stats:
  Total Frames: $totalFrames
  Jank Frames: $jankFrames (${jankPercentage.toStringAsFixed(2)}%)
  Average Frame Time: ${averageFrameTime.toStringAsFixed(2)}ms
  Status: ${hasJank ? '⚠️ Jank Detected' : '✅ Smooth'}
''';
  }
}

