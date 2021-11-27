import 'package:bloc/bloc.dart';
import 'package:devject_single/models/task.dart';

class SelectedTaskCubit extends Cubit<Task?> {
  SelectedTaskCubit() : super(null);

  select(Task task) {
    emit(task);
  }
}
