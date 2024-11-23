import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/taskmodel.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getString('tasks');
    final completedList = prefs.getString('completedTasks');

    if (taskList != null) {
      List<dynamic> taskJson = jsonDecode(taskList);
      _tasks = taskJson.map((task) => Task.fromJson(task)).toList();
    }

    if (completedList != null) {
      List<dynamic> completedJson = jsonDecode(completedList);
      _completedTasks =
          completedJson.map((task) => Task.fromJson(task)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'tasks', jsonEncode(_tasks.map((task) => task.toJson()).toList()));
    prefs.setString('completedTasks',
        jsonEncode(_completedTasks.map((task) => task.toJson()).toList()));
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void editTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  void deleteCompletedTask(int index) {
    _completedTasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  void markTaskCompleted(int index) {
    Task completedTask = _tasks.removeAt(index);
    completedTask.isCompleted = true;
    _completedTasks.add(completedTask);
    _saveTasks();
    notifyListeners();
  }

  List<Task> tasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }
}
