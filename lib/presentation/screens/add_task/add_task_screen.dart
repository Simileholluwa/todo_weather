// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_weather/core/config/env.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/task_provider.dart';
import '../../../data/models/task_model.dart';
import '../../../data/datasources/weather_api_service.dart';
import '../../../data/models/weather_model.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});
  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addTask() async {
    setState(
      () => _isLoading = true,
    );
    final apiService = WeatherApiService(Env.weatherApiKey);
    try {
      final WeatherModel weather = await apiService.fetchWeather(
        _cityController.text.trim(),
      );
      final task = TaskModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        city: _cityController.text.trim(),
        temperature: weather.temperature,
      );
      await ref.read(taskProvider.notifier).addTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'New task has been added.',
          ),
        ),
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to add task: $e',
            ),
          ),
        );
      }
    } finally {
      setState(
        () => _isLoading = false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addTask,
                    child: const Text(
                      'Add Task',
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
