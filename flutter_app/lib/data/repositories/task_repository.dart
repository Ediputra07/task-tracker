import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';

class TaskRepository {
  final SupabaseClient _client;

  TaskRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  // Fetch Today Tasks (due_date <= end of today AND status != done)
  Future<List<TaskModel>> getTodayTasks() async {
    if (_userId == null) return [];

    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', _userId!)
        .neq('status', 'done')
        .lte('due_date', endOfToday.toIso8601String())
        .order('due_date', ascending: true);

    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  // Fetch Upcoming Tasks (next 7 days)
  Future<List<TaskModel>> getUpcomingTasks() async {
    if (_userId == null) return [];

    final now = DateTime.now();
    final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
    final in7Days = startOfTomorrow.add(const Duration(days: 7));

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', _userId!)
        .neq('status', 'done')
        .gte('due_date', startOfTomorrow.toIso8601String())
        .lte('due_date', in7Days.toIso8601String())
        .order('due_date', ascending: true);

    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  // Fetch All Tasks
  Future<List<TaskModel>> getAllTasks() async {
    if (_userId == null) return [];

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', _userId!)
        .order('created_at', ascending: false);

    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  // Fetch Completed Tasks (status == done)
  Future<List<TaskModel>> getDoneTasks() async {
    if (_userId == null) return [];

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', _userId!)
        .eq('status', 'done')
        .order('completed_at', ascending: false);

    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  // Create Task
  Future<TaskModel> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    String? categoryId,
  }) async {
    if (_userId == null) throw Exception('User not authenticated');

    final payload = {
      'user_id': _userId,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'status': 'todo',
      'priority': priority.toValue(),
      'category_id': categoryId,
    };

    final response = await _client
        .from('tasks')
        .insert(payload)
        .select()
        .single();

    return TaskModel.fromJson(response);
  }

  // Update Task Status
  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    if (_userId == null) return;

    final updateData = <String, dynamic>{
      'status': newStatus.toValue(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (newStatus == TaskStatus.done) {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    } else {
      updateData['completed_at'] = null;
    }

    await _client
        .from('tasks')
        .update(updateData)
        .eq('id', taskId)
        .eq('user_id', _userId!);
  }

  // Update Full Task
  Future<void> updateTask({
    required String taskId,
    required String title,
    String? description,
    DateTime? dueDate,
    required TaskPriority priority,
    String? categoryId,
  }) async {
    if (_userId == null) return;

    await _client
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'due_date': dueDate?.toIso8601String(),
          'priority': priority.toValue(),
          'category_id': categoryId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', taskId)
        .eq('user_id', _userId!);
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    if (_userId == null) return;

    await _client
        .from('tasks')
        .delete()
        .eq('id', taskId)
        .eq('user_id', _userId!);
  }

  // Fetch Categories
  Future<List<CategoryModel>> getCategories() async {
    if (_userId == null) return [];

    final response = await _client
        .from('categories')
        .select()
        .eq('user_id', _userId!)
        .order('name');

    return (response as List).map((json) => CategoryModel.fromJson(json)).toList();
  }
}
