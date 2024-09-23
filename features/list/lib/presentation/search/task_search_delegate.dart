import 'package:flutter/material.dart';
import 'package:list/presentation/provider/task_list_provider.dart';
import 'package:list/presentation/widgets/task_card.dart';
import 'package:provider/provider.dart';
import 'package:common/data/task_repository_impl.dart';


class TaskSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final taskListProvider = Provider.of<TaskListProvider>(context);
    final results = taskListProvider.searchTasks(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return TaskCard(task: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}