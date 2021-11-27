import 'package:bloc/bloc.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/providers/projects_provider.dart';
class ProjectsCubit extends Cubit<List<Project>> {
  ProjectsCubit() : super([]) {
    load();
  }

  Future<void> load() async {
    emit(await ProjectsProvider.get());
  }

  Future<void> add(Project project) async {
    await ProjectsProvider.add(project);
    await load();
  }

  Future<void> update(Project project) async {
    await ProjectsProvider.update(project);
    await load();
  }
}
