import 'package:bloc/bloc.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/providers/projects_provider.dart';
class ProjectsCubit extends Cubit<List<Project>> {
  ProjectsCubit() : super([]) {
    load();
  }

  final ProjectsProvider _provider = ProjectsProvider.instance;

  Future<void> load() async {
    emit(await _provider.get());
  }

  Future<void> add(Project project) async {
    await _provider.add(project);
    await load();
  }

  Future<void> update(Project project) async {
    await _provider.update(project);
    await load();
  }
}
