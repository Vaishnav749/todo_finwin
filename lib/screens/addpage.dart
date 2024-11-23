import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/taskmodel.dart';
import '../provider/addpageprovider.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final String? initialPriority;
  final Task? task;
  final int? index;

  AddTaskPage({this.task, this.index, Key? key}) : initialPriority = task?.priority, super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set initial values if editing
    if (task != null) {
      titleController.text = task!.title;
      descriptionController.text = task!.description ?? '';
    }
    String selectedPriority = initialPriority ?? 'Low';

    return Scaffold(
      appBar: AppBar(title: Text(task == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                selectedPriority = newValue!;
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final newTask = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    priority: selectedPriority,
                    isCompleted: task?.isCompleted ?? false, // Preserve the completion state
                  );

                  final taskProvider = Provider.of<TaskProvider>(context, listen: false);

                  if (task == null) {
                    // Add new task
                    taskProvider.addTask(newTask);
                  } else if (index != null) {
                    // Edit existing task
                    taskProvider.editTask(index!, newTask);
                  }

                  Navigator.pop(context);
                },
                child: Text(task == null ? 'Save Task' : 'Update Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
