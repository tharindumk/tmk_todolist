import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Text("No tasks found. Add a new task!",
                  style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: _getStatusColor(task.status),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    task.status,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
                          _showStatusUpdateDialog(context, task);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, task);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Start":
        return Colors.blue;
      case "In Progress":
        return Colors.orange;
      case "Done":
        return Colors.green;
      case "Will Do Later":
        return Colors.purple;
      case "Unable to Complete":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

void _showStatusUpdateDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Update Status"),
        content: DropdownButton<String>(
          value: task.status,
          items: <String>[
            "Start",
            "In Progress",
            "Done",
            "Will Do Later",
            "Unable to Complete"
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newStatus) {
            if (newStatus != null) {
              task.status = newStatus;
              Provider.of<TaskProvider>(context, listen: false)
                  .updateTask(task);
              Navigator.of(context).pop();
            }
          },
        ),
      );
    },
  );
}

void _showDeleteConfirmationDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              int id = task.id == null ? -999 : task.id!;
              Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
