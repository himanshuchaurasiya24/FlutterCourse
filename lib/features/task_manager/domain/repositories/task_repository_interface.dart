import '../../domain/entities/task.dart';

/// Abstract repository interface
abstract class TaskRepository {
  /// Get all tasks
  Future<List<Task>> getAllTasks();

  /// Get task by ID
  Future<Task?> getTaskById(String id);

  /// Create task
  Future<void> createTask(Task task);

  /// Update task
  Future<void> updateTask(Task task);

  /// Delete task
  Future<void> deleteTask(String id);

  /// Search tasks by title or description
  Future<List<Task>> searchTasks(String query);

  /// Filter tasks by category
  Future<List<Task>> filterByCategory(TaskCategory category);

  /// Filter tasks by completion status
  Future<List<Task>> filterByStatus(bool isCompleted);

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday();

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks();

  /// Watch for task changes
  Stream<List<Task>> watchTasks();
}
