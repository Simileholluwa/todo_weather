import '../datasources/weather_api_service.dart';
import '../datasources/local_storage_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  final WeatherApiService apiService;
  final LocalStorageService localService;

  TaskRepository(this.apiService, this.localService);

  Future<void> addTask(TaskModel task) => localService.saveTask(task);
  Future<List<TaskModel>> getTasks() => localService.getAllTasks();
  Future<void> removeTask(String id) => localService.deleteTask(id);

  Future<List<TaskModel>> refreshAllTaskWeather(List<TaskModel> tasks) async {
    final List<TaskModel> updated = [];
    for (var task in tasks) {
      try {
        final weather = await apiService.fetchWeather(task.city);
        final newTask = TaskModel(
          id: task.id,
          title: task.title,
          city: task.city,
          temperature: weather.temperature,
        );
        await localService.updateTask(newTask);
        updated.add(newTask);
      } catch (_) {
        updated.add(task);
      }
    }
    return updated;
  }
}
