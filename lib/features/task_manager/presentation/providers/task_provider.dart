import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/hive_service.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository_interface.dart';

/// UUID generator provider
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

/// Hive service provider
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return TaskRepositoryImpl(hiveService);
});

/// Task list provider - streams all tasks
final taskListProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks();
});

/// Filter options
enum TaskFilter { all, active, completed, dueToday, overdue }

/// Category filter provider
final selectedCategoryProvider = StateProvider<TaskCategory?>((ref) => null);

/// Status filter provider
final selectedFilterProvider = StateProvider<TaskFilter>(
  (ref) => TaskFilter.all,
);

/// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered tasks provider
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final category = ref.watch(selectedCategoryProvider);
  final filter = ref.watch(selectedFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return tasksAsync.when(
    data: (tasks) {
      var filtered = tasks;

      // Apply category filter
      if (category != null) {
        filtered = filtered.where((task) => task.category == category).toList();
      }

      // Apply status filter
      switch (filter) {
        case TaskFilter.active:
          filtered = filtered.where((task) => !task.isCompleted).toList();
          break;
        case TaskFilter.completed:
          filtered = filtered.where((task) => task.isCompleted).toList();
          break;
        case TaskFilter.dueToday:
          filtered = filtered.where((task) => task.isDueToday).toList();
          break;
        case TaskFilter.overdue:
          filtered = filtered.where((task) => task.isOverdue).toList();
          break;
        case TaskFilter.all:
          // No additional filtering
          break;
      }

      // Apply search filter
      if (searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        filtered = filtered.where((task) {
          return task.title.toLowerCase().contains(lowerQuery) ||
              task.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Sort by priority (high to low) and then by creation date
      filtered.sort((a, b) {
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;
        return b.createdAt.compareTo(a.createdAt);
      });

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Task statistics provider
final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.when(
    data: (tasks) {
      return {
        'total': tasks.length,
        'active': tasks.where((t) => !t.isCompleted).length,
        'completed': tasks.where((t) => t.isCompleted).length,
        'dueToday': tasks.where((t) => t.isDueToday).length,
        'overdue': tasks.where((t) => t.isOverdue).length,
      };
    },
    loading: () => {
      'total': 0,
      'active': 0,
      'completed': 0,
      'dueToday': 0,
      'overdue': 0,
    },
    error: (_, __) => {
      'total': 0,
      'active': 0,
      'completed': 0,
      'dueToday': 0,
      'overdue': 0,
    },
  );
});

/// Task notifier for CRUD operations
class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;
  final Ref _ref;

  TaskNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  /// Create a new task
  Future<void> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
    required TaskCategory category,
    DateTime? dueDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final uuid = _ref.read(uuidProvider);
      final task = Task(
        id: uuid.v4(),
        title: title,
        description: description,
        isCompleted: false,
        priority: priority,
        category: category,
        createdAt: DateTime.now(),
        dueDate: dueDate,
      );

      await _repository.createTask(task);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateTask(task);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();

    try {
      await _repository.deleteTask(id);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Task notifier provider
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(taskRepositoryProvider);
      return TaskNotifier(repository, ref);
    });
