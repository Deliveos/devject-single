import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/tasks_provider.dart';

class CurretTasksCubit extends Cubit<List<Task>> {
  CurretTasksCubit() : super([]);

  Future<void> load() async {
    emit(await TasksProvider.instance.getCurrentTask());
  }
}
