import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import '../data/models/category_model.dart';
import '../data/repositories/task_repository.dart';

enum TaskViewMode { today, upcoming, all, done }

class TaskNotifier extends ChangeNotifier {
  final TaskRepository _repository;

  List<TaskModel> _tasks = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  TaskViewMode _currentView = TaskViewMode.today;

  TaskNotifier(this._repository);

  List<TaskModel> get tasks => _tasks;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskViewMode get currentView => _currentView;

  void setViewMode(TaskViewMode mode) {
    _currentView = mode;
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      switch (_currentView) {
        case TaskViewMode.today:
          _tasks = await _repository.getTodayTasks();
          break;
        case TaskViewMode.upcoming:
          _tasks = await _repository.getUpcomingTasks();
          break;
        case TaskViewMode.all:
          _tasks = await _repository.getAllTasks();
          break;
        case TaskViewMode.done:
          _tasks = await _repository.getDoneTasks();
          break;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat tugas: $e';
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    String? categoryId,
  }) async {
    try {
      await _repository.createTask(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        categoryId: categoryId,
      );
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal membuat tugas baru: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    try {
      await _repository.updateTaskStatus(taskId, newStatus);
      await fetchTasks();
    } catch (e) {
      _errorMessage = 'Gagal mengubah status tugas.';
      notifyListeners();
    }
  }

  Future<bool> updateTask({
    required String taskId,
    required String title,
    String? description,
    DateTime? dueDate,
    required TaskPriority priority,
    String? categoryId,
  }) async {
    try {
      await _repository.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        categoryId: categoryId,
      );
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui tugas.';
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
      await fetchTasks();
    } catch (e) {
      _errorMessage = 'Gagal menghapus tugas.';
      notifyListeners();
    }
  }
}
