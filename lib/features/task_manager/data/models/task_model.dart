import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

/// Hive adapter for Task model
@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late bool isCompleted;

  @HiveField(4)
  late int priority; // 0: low, 1: medium, 2: high

  @HiveField(5)
  late int category; // 0: work, 1: personal, 2: shopping, 3: health, 4: other

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  DateTime? dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.dueDate,
  });

  /// Convert from domain entity to Hive model
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      priority: task.priority.index,
      category: task.category.index,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
    );
  }

  /// Convert from Hive model to domain entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: TaskPriority.values[priority],
      category: TaskCategory.values[category],
      createdAt: createdAt,
      dueDate: dueDate,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Convert from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      priority: json['priority'] as int,
      category: json['category'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }
}
