import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';


class SelectedTaskCubit extends Cubit<Task> {
  SelectedTaskCubit() : super(const Task.byDefault());

  select(Task task) {
    emit(task);
  }

  unselect() {
    emit(const Task.byDefault());
  }
}
