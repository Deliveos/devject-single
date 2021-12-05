import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';


class SelectedTaskCubit extends Cubit<Task> {
  SelectedTaskCubit() : super(const Task.byDefault());

  select(Task task) {
    print(task);
    emit(task);
  }

  unselect() {
    print(const Task.byDefault());
    emit(const Task.byDefault());
  }
}
