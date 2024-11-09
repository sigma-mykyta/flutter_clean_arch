import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:common/data/task_repository_impl.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDetailsInjection() {
  getIt();
}

void configureDependencies() {
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
}