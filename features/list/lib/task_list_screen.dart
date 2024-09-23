import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:common/domain/entities/task.dart';
import 'package:your_project/presentation/widgets/task_card.dart';
import 'package:your_project/presentation/provider/task_list_provider.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskListProvider>(context);
  }


  
}