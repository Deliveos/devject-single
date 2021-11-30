import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/tasks_provider.dart';


class TasksCubit extends Cubit<List<Task>> {
  TasksCubit() : super([]);

  final TasksProvider _provider = TasksProvider.instance;

  Future load(int projectId, {int? parentId}) async {
    emit(await _provider.getFor(projectId, parentId: parentId));
  }

  Future add(Task task) async {
    await _provider.add(task);
    await load(
      task.projectId,
      parentId: task.parentId
    );
  }

  Future update(Task task) async {
    await _provider.update(task);
    await load(task.projectId, parentId: task.parentId);
  }
}
