import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/task_manager/presentation/screens/task_list_screen.dart';
import 'features/task_manager/data/local/hive_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  final hiveService = HiveService();
  await hiveService.init();

  runApp(
    // ProviderScope is required for Riverpod to work
    const ProviderScope(child: TaskManagerApp()),
  );
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,

      // Use custom Material 3 theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Start directly with Task Manager
      home: const TaskListScreen(),
    );
  }
}
