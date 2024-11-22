import 'package:flutter/material.dart';
import 'package:todo_finwin/screens/addpage.dart';

class Hometodo extends StatefulWidget {
  const Hometodo({super.key});

  @override
  State<Hometodo> createState() => _HometodoState();
}

class _HometodoState extends State<Hometodo> {
  // List to store tasks
  List<Map<String, String>> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Center(
          child: Text("Todo App"),
        ),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text("No tasks yet. Add a new task."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(task['title'] ?? ''),
                    subtitle: Text(task['description'] ?? ''),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to Addpage and wait for the result
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addpage()),
          );

          // Check if a task was returned
          if (newTask != null) {
            setState(() {
              tasks.add(newTask); // Add the new task to the list
            });
          }
        },
        label: const Text("ADD LEAD"),
      ),
    );
  }
}
