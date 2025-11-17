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


