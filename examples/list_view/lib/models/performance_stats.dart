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
