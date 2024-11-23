import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/taskmodel.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getString('tasks');
    if (taskList != null) {
      final taskJson = jsonDecode(taskList) as List;
      _tasks = taskJson.map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    prefs.setString('tasks', jsonEncode(tasksJson));
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
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      _saveTasks();
      notifyListeners();
    }
  }

  void markTaskCompleted(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _saveTasks();
      notifyListeners();
    }
  }

  List<Task> tasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.isCompleted);
    _saveTasks();
    notifyListeners();
  }
}
