import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String city;

  @HiveField(3)
  final double temperature;

  TaskModel({
    required this.id,
    required this.title,
    required this.city,
    required this.temperature,
  });
}
