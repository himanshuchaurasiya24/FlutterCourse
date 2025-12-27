import '../local/hive_service.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository_interface.dart';

/// Task repository implementation using Hive
class TaskRepositoryImpl implements TaskRepository {
  final HiveService _hiveService;

  TaskRepositoryImpl(this._hiveService);

  @override
  Future<List<Task>> getAllTasks() async {
    final models = _hiveService.getAllTasks();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final model = _hiveService.getTaskById(id);
    return model?.toEntity();
  }

  @override
  Future<void> createTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await _hiveService.addTask(model);
  }

  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await _hiveService.updateTask(model);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _hiveService.deleteTask(id);
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final allTasks = await getAllTasks();
    final lowerQuery = query.toLowerCase();

    return allTasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<List<Task>> filterByCategory(TaskCategory category) async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.category == category).toList();
  }

  @override
  Future<List<Task>> filterByStatus(bool isCompleted) async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.isCompleted == isCompleted).toList();
  }

  @override
  Future<List<Task>> getTasksDueToday() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.isDueToday).toList();
  }

  @override
  Future<List<Task>> getOverdueTasks() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.isOverdue).toList();
  }

  @override
  Stream<List<Task>> watchTasks() {
    return _hiveService.watchTasks().map((_) {
      final models = _hiveService.getAllTasks();
      return models.map((model) => model.toEntity()).toList();
    });
  }
}
