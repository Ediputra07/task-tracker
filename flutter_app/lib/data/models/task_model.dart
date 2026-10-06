enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

extension TaskStatusExtension on TaskStatus {
  String toValue() {
    switch (this) {
      case TaskStatus.todo:
        return 'todo';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
    }
  }

  static TaskStatus fromString(String value) {
    switch (value) {
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      case 'todo':
      default:
        return TaskStatus.todo;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String toValue() {
    switch (this) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
    }
  }

  static TaskPriority fromString(String value) {
    switch (value) {
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }

  String get label {
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

class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final String? categoryId;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.dueDate,
    required this.status,
    required this.priority,
    this.categoryId,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      status: TaskStatusExtension.fromString(json['status'] as String? ?? 'todo'),
      priority: TaskPriorityExtension.fromString(json['priority'] as String? ?? 'medium'),
      categoryId: json['category_id'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'status': status.toValue(),
      'priority': priority.toValue(),
      'category_id': categoryId,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
    String? categoryId,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
