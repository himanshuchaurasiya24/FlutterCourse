import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../../domain/entities/task.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTasks = ref.watch(filteredTasksProvider);
    final stats = ref.watch(taskStatsProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
              ref.read(selectedFilterProvider.notifier).state = filter;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Text('All Tasks'),
              ),
              const PopupMenuItem(
                value: TaskFilter.active,
                child: Text('Active'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: TaskFilter.dueToday,
                child: Text('Due Today'),
              ),
              const PopupMenuItem(
                value: TaskFilter.overdue,
                child: Text('Overdue'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsBar(stats, selectedFilter),
          _buildCategoryFilter(ref),
          Expanded(
            child: filteredTasks.isEmpty
                ? _buildEmptyState(selectedFilter)
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(context, ref, task);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTask(context),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildStatsBar(Map<String, int> stats, TaskFilter selectedFilter) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF9FAFB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            stats['total']!,
            Colors.blue,
            selectedFilter == TaskFilter.all,
          ),
          _buildStatItem(
            'Active',
            stats['active']!,
            Colors.orange,
            selectedFilter == TaskFilter.active,
          ),
          _buildStatItem(
            'Done',
            stats['completed']!,
            Colors.green,
            selectedFilter == TaskFilter.completed,
          ),
          _buildStatItem(
            'Today',
            stats['dueToday']!,
            Colors.purple,
            selectedFilter == TaskFilter.dueToday,
          ),
          _buildStatItem(
            'Overdue',
            stats['overdue']!,
            Colors.red,
            selectedFilter == TaskFilter.overdue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? color : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildCategoryChip(ref, 'All', null, selectedCategory == null),
          const SizedBox(width: 8),
          ...TaskCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryChip(
                ref,
                category.displayName,
                category,
                selectedCategory == category,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    WidgetRef ref,
    String label,
    TaskCategory? category,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(selectedCategoryProvider.notifier).state = category;
      },
      selectedColor: const Color(0xFF6366F1),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, Task task) {
    final priorityColor = _getPriorityColor(task.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: Key(task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${task.title} deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Undo functionality will be added with undo/redo provider
                },
              ),
            ),
          );
        },
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              ref
                  .read(taskNotifierProvider.notifier)
                  .toggleTaskCompletion(task);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityBadge(task.priority, priorityColor),
                  const SizedBox(width: 8),
                  _buildCategoryBadge(task.category),
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 8),
                    _buildDueDateBadge(task),
                  ],
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditTask(context, task),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(TaskCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.displayName,
        style: const TextStyle(fontSize: 11, color: Color(0xFF6366F1)),
      ),
    );
  }

  Widget _buildDueDateBadge(Task task) {
    final color = task.isOverdue
        ? Colors.red
        : task.isDueToday
        ? Colors.orange
        : Colors.grey;

    final icon = task.isOverdue
        ? Icons.warning
        : task.isDueToday
        ? Icons.today
        : Icons.calendar_today;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(task.dueDate!),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: task.isOverdue || task.isDueToday
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TaskFilter filter) {
    String message;
    IconData icon;

    switch (filter) {
      case TaskFilter.completed:
        message = 'No completed tasks yet';
        icon = Icons.check_circle_outline;
        break;
      case TaskFilter.dueToday:
        message = 'No tasks due today';
        icon = Icons.today;
        break;
      case TaskFilter.overdue:
        message = 'No overdue tasks';
        icon = Icons.warning_amber;
        break;
      case TaskFilter.active:
        message = 'No active tasks';
        icon = Icons.task_alt;
        break;
      default:
        message = 'No tasks yet.\nTap + to create one!';
        icon = Icons.inbox;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${-difference}d ago';
    return '${difference}d';
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(searchQueryProvider.notifier).state = '';
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
    );
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
    );
  }
}
