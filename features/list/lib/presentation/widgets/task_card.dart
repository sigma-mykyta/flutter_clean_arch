import 'package:flutter/material.dart';
import 'package:common/domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text('Due: ${task.dueDate.toLocal()}'.split(' ')[0]),
        trailing: Icon(
          task.isCompleted ? Icons.check_circle : Icons.pending,
          color: task.isCompleted ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}