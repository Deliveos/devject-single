import 'package:bloc/bloc.dart';
import 'package:devject_single/models/project.dart';

class SelectedProjectCubit extends Cubit<Project?> {
  SelectedProjectCubit() : super(null);

  select(Project project) {
    emit(project);
  }

  unselect() {
    emit(null);
  }
}
