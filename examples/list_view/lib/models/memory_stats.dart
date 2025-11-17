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

