import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/taskmodel.dart';
import '../provider/addpageprovider.dart';

class AddTaskPage extends StatelessWidget {
  final Task? task;
  final int? index;

  AddTaskPage({this.task, this.index});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'Low';

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      titleController.text = task!.title;
      descriptionController.text = task!.description ?? '';
      selectedPriority = task!.priority;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add/Edit Task")),
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
                alignLabelWithHint: true,
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
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
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
                  );

                  if (task == null) {
                    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                  } else {
                    Provider.of<TaskProvider>(context, listen: false).editTask(index!, newTask);
                  }

                  Navigator.pop(context);
                },
                child: const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
