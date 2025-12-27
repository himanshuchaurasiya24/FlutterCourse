import 'package:equatable/equatable.dart';

/// Task priority levels
enum TaskPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

/// Task categories
enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  other;

  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.other:
        return 'Other';
    }
  }
}

/// Task entity - domain model
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime? dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.dueDate,
  });

  /// Create a copy with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    priority,
    category,
    createdAt,
    dueDate,
  ];

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted, priority: $priority)';
  }
}
