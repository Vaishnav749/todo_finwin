import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../provider/addpageprovider.dart';
import 'addpage.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String searchQuery = ''; // Tracks the current search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Todo List',
            style: TextStyle(fontSize: 28),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return ListView(
                  children: [
                    _buildTaskSection(taskProvider, 'High'),
                    _buildTaskSection(taskProvider, 'Medium'),
                    _buildTaskSection(taskProvider, 'Low'),
                    _buildCompletedTasksSection(taskProvider),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()),
            );
          },
          child: const Text('Add Task'),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase(); // Update search query
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search Tasks',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection(TaskProvider taskProvider, String priority) {
    final tasks = taskProvider.tasksByPriority(priority).where((task) {
      return task.title.toLowerCase().contains(searchQuery) ||
          (task.description?.toLowerCase().contains(searchQuery) ?? false);
    }).toList();

    if (tasks.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: Text('$priority Priority'),
      children: tasks.map((task) {
        return Slidable(
          key: ValueKey(task), // Add key for uniqueness
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  taskProvider.deleteTask(taskProvider.tasks.indexOf(task));
                },
                backgroundColor: const Color.fromARGB(255, 157, 43, 35),
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskPage(
                        task: task, // Pass the task to be edited
                        index:
                            taskProvider.tasks.indexOf(task), // Pass the index
                      ),
                    ),
                  );
                },
                backgroundColor: const Color.fromARGB(255, 74, 119, 156),
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                taskProvider
                    .markTaskCompleted(taskProvider.tasks.indexOf(task));
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.description ?? ''),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompletedTasksSection(TaskProvider taskProvider) {
    final completedTasks = taskProvider.completedTasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery) ||
          (task.description?.toLowerCase().contains(searchQuery) ?? false);
    }).toList();

    if (completedTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Completed Tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...completedTasks.map((task) {
          return Slidable(
            key: ValueKey(task), // Add key for uniqueness
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    taskProvider.deleteTask(taskProvider.tasks.indexOf(task));
                  },
                  backgroundColor: const Color.fromARGB(255, 157, 43, 35),
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              child: ListTile(
                title: Text(
                  task.title,
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                subtitle: Text(task.description ?? ''),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
