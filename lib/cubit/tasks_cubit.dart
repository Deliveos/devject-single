import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/tasks_provider.dart';


class TasksCubit extends Cubit<List<Task>> {
  TasksCubit() : super([]);

  Future load(int projectId, {int? parentId}) async {
    emit(await TaskProvider.get(projectId, parentId: parentId));
  }

  Future add(Task task) async {
    await TaskProvider.add(task);
    await load(
      task.projectId,
      parentId: task.parentId
    );
  }

  Future update(Task task) async {
    await TaskProvider.update(task);
    await load(task.projectId, parentId: task.parentId);
  }
}
