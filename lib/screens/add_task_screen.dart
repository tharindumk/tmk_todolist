import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = "Start";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title")),
            TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description")),
            DropdownButton<String>(
              value: _status,
              items: [
                "Start",
                "In Progress",
                "Done",
                "Will Do Later",
                "Unable to Complete"
              ]
                  .map((status) =>
                      DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  status: _status,
                  dueDate: DateTime.now(),
                );
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(newTask);
                Navigator.pop(context);
              },
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
