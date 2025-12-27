import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

/// Hive service for local storage
class HiveService {
  static const String _taskBoxName = 'tasks';
  Box<TaskModel>? _taskBox;

  /// Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    // Open boxes
    _taskBox = await Hive.openBox<TaskModel>(_taskBoxName);
  }

  /// Get task box
  Box<TaskModel> get taskBox {
    if (_taskBox == null || !_taskBox!.isOpen) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _taskBox!;
  }

  /// Get all tasks
  List<TaskModel> getAllTasks() {
    return taskBox.values.toList();
  }

  /// Get task by ID
  TaskModel? getTaskById(String id) {
    return taskBox.get(id);
  }

  /// Add task
  Future<void> addTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  /// Update task
  Future<void> updateTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  /// Delete task
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    await taskBox.clear();
  }

  /// Watch for changes
  Stream<BoxEvent> watchTasks() {
    return taskBox.watch();
  }

  /// Close boxes
  Future<void> close() async {
    await _taskBox?.close();
  }
}
