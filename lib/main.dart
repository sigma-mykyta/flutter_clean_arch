import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:list/presentation/provider/task_list_provider.dart';
import 'package:list/presentation/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/presentation/bloc/task_bloc.dart';
import 'package:dashboard/presentation/screens/dashboard_screen.dart';
import 'package:common/data/task_repository_impl.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configureDependencies();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inject TaskRepository via GetIt
        Provider<TaskRepository>(
          create: (_) => GetIt.I<TaskRepository>(),
        ),
        // BlocProvider for Dashboard feature
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            taskRepository: context.read<TaskRepository>(),
          )..add(FetchTasksEvent()),
        ),
        // TaskListProvider now injects TaskRepository using GetIt internally
        ChangeNotifierProvider<TaskListProvider>(
          create: (context) => TaskListProvider(), 
        ),
      ],
      child: MaterialApp(
        title: 'Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DashboardScreen(),
          '/task_list': (context) => TaskListScreen(),
        },
      ),
    );
  }
}