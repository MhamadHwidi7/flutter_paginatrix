import 'package:flutter/material.dart';

import 'app.dart';
import 'memory_monitor.dart';
import 'performance_monitor.dart';

void main() {
  // Ensure Flutter binding is initialized before accessing SchedulerBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Start performance monitoring
  PerformanceMonitor.start();
  MemoryMonitor.start();

  runApp(const App());
}
