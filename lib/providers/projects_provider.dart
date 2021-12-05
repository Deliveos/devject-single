import 'package:devject_single/models/project.dart';
import 'package:devject_single/providers/i_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/services/database.dart';

/// Providing database operations for projects
class ProjectsProvider implements IProvider<Project> {
  ProjectsProvider._privateConstructor();

  static final ProjectsProvider instance = ProjectsProvider._privateConstructor();
  static final DatabaseProvider _provider = DatabaseProvider.instance;

  static const tableName = 'projects';

  @override
  Future<int> add(Project project) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
        INSERT INTO $tableName(
          ${ProjectsTableField.name}, 
          ${ProjectsTableField.description}, 
          ${ProjectsTableField.startDate}, 
          ${ProjectsTableField.endDate}
        )
        VALUES(?, ?, ?, ?)
      ''', 
      [
        project.name, 
        project.description, 
        project.startDate?.millisecondsSinceEpoch, 
        project.endDate?.millisecondsSinceEpoch
      ]
    );
  }

  @override
  Future<List<Project>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery(
      '''
      SELECT * FROM $tableName 
      ORDER BY ${ProjectsTableField.startDate}
      '''
    )).map((map) => Project.fromMap(map)).toList();
  }

  @override
  Future<Project> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery(
      '''
      SELECT * FROM $tableName
      WHERE ${ProjectsTableField.id}=?
      ''', 
      [id]
    );
    return Project.fromMap(map.first);
  }

  @override
  Future<int> remove(int id) async {
    final db = await _provider.database;
    await db.rawDelete(
      '''
      DELETE FROM ${TasksProvider.tableName} 
      WHERE ${TasksTableField.projectId}=?
      ''', 
      [id]
    );
    return db.rawDelete(
      '''
      DELETE FROM projects WHERE id=?
      ''',
      [id]
    );
  }

  @override
  Future<int> update(Project project) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE ${ProjectsProvider.tableName} SET 
      ${ProjectsTableField.name}=?, 
      ${ProjectsTableField.description}=?, 
      ${ProjectsTableField.startDate}=?, 
      ${ProjectsTableField.endDate}=?,
      ${ProjectsTableField.taskCount}=?,
      ${ProjectsTableField.complitedTaskCount}=?
      WHERE ${ProjectsTableField.id}=?
      ''',
      [
        project.name,
        project.description,
        project.startDate?.millisecondsSinceEpoch,
        project.endDate?.millisecondsSinceEpoch,
        project.tasksCount,
        project.complitedTaskCount,
        project.id
      ]
    );
  }
  
  Future<int> updateComplitedTasks(int id, int complitedTasksCount) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE ${ProjectsProvider.tableName}
      SET ${ProjectsTableField.complitedTaskCount}=?
      WHERE ${ProjectsTableField.id}=?
      ''',
      [
        complitedTasksCount, 
        id
      ]
    );
  }

  Future recalculateComplitedTasksCountFor(int id) async {
    final tasks = await TasksProvider.instance.getFor(id);
    int complitedTasksCount = 0;
    for (var task in tasks) {
      if (task.isComplited) {
        complitedTasksCount += 1;
      }
    }
    await updateComplitedTasks(id, complitedTasksCount);
  }
}

class ProjectsTableField {
  static const id = 'id';
  static const name = 'name';
  static const description = 'description';
  static const startDate = 'start_date';
  static const endDate = 'end_date';
  static const taskCount = 'task_count';
  static const complitedTaskCount = 'complited_task_count';
}