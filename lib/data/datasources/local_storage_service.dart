import 'package:hive/hive.dart';
import '../models/task_model.dart';

class LocalStorageService {
  static const String taskBoxName = 'tasks';

  Future<void> saveTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(taskBoxName);
    await box.put(task.id, task);
  }

  Future<List<TaskModel>> getAllTasks() async {
    final box = await Hive.openBox<TaskModel>(taskBoxName);
    return box.values.toList();
  }

  Future<void> deleteTask(String id) async {
    final box = await Hive.openBox<TaskModel>(taskBoxName);
    await box.delete(id);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(taskBoxName);
    await box.put(task.id, task);
  }
}
