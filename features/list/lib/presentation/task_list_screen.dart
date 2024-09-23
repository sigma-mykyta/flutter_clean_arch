import 'package:flutter/material.dart';
import 'package:list/presentation/search/task_search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:common/domain/entities/task.dart';
import 'widgets/task_card.dart';
import 'provider/task_list_provider.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TaskSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: taskListProvider.selectedFilter,
                  onChanged: (value) {
                    taskListProvider.setFilter(value!);
                  },
                  items: <String>['All', 'Completed', 'Pending']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: taskListProvider.selectedSortOption,
                  onChanged: (value) {
                    taskListProvider.setSortOption(value!);
                  },
                  items: <String>['Due Date', 'Alphabetical']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: taskListProvider.filteredAndSortedTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: taskListProvider.filteredAndSortedTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }


  
}