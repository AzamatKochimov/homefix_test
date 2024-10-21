import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';

class TaskRepository {
  static const String _tasksKey = 'tasks_key';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List decoded = jsonDecode(tasksString) as List;
      return decoded.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final tasks = await getTasks();
    final updatedTasks = tasks.map((t) {
      if (t.title == task.title) {
        return t.copyWith(isCompleted: !task.isCompleted);
      }
      return t;
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, jsonEncode(updatedTasks));
  }
}
