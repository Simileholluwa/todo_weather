import 'package:flutter/material.dart';
import '../../presentation/screens/add_task/add_task_screen.dart';
import '../../presentation/screens/task_list/task_list_screen.dart';

class AppRouter {
  static const String taskList = '/';
  static const String addTask = '/addTask';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskList:
        return MaterialPageRoute(
          builder: (_) => const TaskListScreen(),
        );
      case addTask:
        return MaterialPageRoute(
          builder: (_) => const AddTaskScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
