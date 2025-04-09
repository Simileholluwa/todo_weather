import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_weather/core/config/env.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../data/datasources/weather_api_service.dart';
import '../data/datasources/local_storage_service.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final weatherApi = WeatherApiService(Env.weatherApiKey);
  final localStorage = LocalStorageService();
  return TaskRepository(weatherApi, localStorage);
});

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository repository;

  TaskNotifier(this.repository) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await repository.getTasks();
    state = tasks;
  }

  Future<void> addTask(TaskModel task) async {
    await repository.addTask(task);
    state = [...state, task];
  }

  Future<void> deleteTask(TaskModel task) async {
    await repository.removeTask(task.id);
    state = state.where((t) => t.id != task.id).toList();
  }

  Future<void> refreshWeather() async {
    final updated = await repository.refreshAllTaskWeather(state);
    state = updated;
  }
}
