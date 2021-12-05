import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/tasks_provider.dart';


class TasksCubit extends Cubit<List<Task>> {
  TasksCubit() : super([]);

  final TasksProvider _provider = TasksProvider.instance;

  Future load(int projectId, {int? id}) async {
    emit(await _provider.getFor(projectId, id: id));
  }

  Future add(Task task) async {
    await _provider.add(task);
    await load(
      task.projectId,
      id: task.parentId
    );
  }

  Future update(Task task, int? id) async {
    await _provider.update(task);
    await load(task.projectId, id: id);
  }
}
