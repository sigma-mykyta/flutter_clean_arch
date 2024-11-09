import 'package:common/data/task_repository_impl.dart';
import 'package:dashboard/presentation/bloc/dashboard_task_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDashboardInjection() {
  getIt();
}

void configureDependencies() {
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
  getIt.registerFactory<DashboardTaskBloc>(() => DashboardTaskBloc(taskRepository: getIt<TaskRepository>()));
}