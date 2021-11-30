import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/i_provider.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/services/database.dart';

/// Providing database operations for tasks
class TasksProvider implements IProvider<Task> {
  TasksProvider._privateConstructor();

  static final TasksProvider instance = TasksProvider._privateConstructor();
  static final DatabaseProvider _provider = DatabaseProvider.instance;

  @override
  Future<int> add(Task task) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
        INSERT INTO tasks(name, description, project_id, parent_id, start_date, end_date)
        VALUES(?, ?, ?, ?, ?, ?)
      ''', 
      [
        task.name, 
        task.description, 
        task.projectId,
        task.parentId,
        task.startDate?.millisecondsSinceEpoch, 
        task.endDate?.millisecondsSinceEpoch,
      ]
    );
  }

  @override
  Future<List<Task>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery(
      '''
      SELECT * FROM tasks
      '''
    )).map((map) => Task.fromMap(map)).toList();
  }
  
  Future<List<Task>> getFor(int projectId, {int? parentId}) async {
    final db = await _provider.database;
    if (parentId != null) {
      return (await db.rawQuery('''
        SELECT * FROM tasks WHERE project_id=? AND parent_id=?
      ''', [projectId, parentId])).map((map) => Task.fromMap(map)).toList();
    }
    final res = (await db.rawQuery('''
        SELECT * FROM tasks WHERE project_id=? AND parent_id IS NULL
      ''', [projectId])).map((map) => Task.fromMap(map)).toList();
    return res;
  }

  @override
  Future<Task> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery('''
        SELECT * FROM tasks WHERE id=?
      ''', [id]);
    return Task.fromMap(map.first);
  }

  @override
  Future<int> remove(int id) async {
    final db = await _provider.database;
    await db.rawDelete(
      '''
      DELETE FROM tasks WHERE parent_id=?
      ''',
      [id]
    );
    return await db.rawDelete(
      '''
      DELETE FROM tasks WHERE id=?
      ''',
      [id]
    );
  }

  @override
  Future<int> update(Task task) async {
    final db = await _provider.database;
    return await db.rawUpdate('''
      UPDATE tasks
      SET name=?, description=?, start_date=?, end_date=?
      WHERE id=?
    ''',
    [
      task.name,
      task.description,
      task.startDate?.millisecondsSinceEpoch,
      task.endDate?.millisecondsSinceEpoch,
      task.id
    ]);
  }

  Future<int> updateProgress(int id, int progress) async {
    final db = await _provider.database;
    return await db.rawUpdate('''
      UPDATE tasks
      SET progress=?
      WHERE id=?
    ''',
    [ progress, id ]);
  }

  Future recalculateProgressFor(Task task) async {
    final tasks = await getFor(
      task.projectId, parentId: task.id
    );
    int averageProgress = 0;
    for (var task in tasks) {
      averageProgress += task.progress;
    }
    averageProgress ~/= tasks.length;
    await updateProgress(task.id!, averageProgress);
    if (task.parentId != null) {
      await recalculateProgressFor(await getOne(task.parentId!));
    } else {
      await ProjectsProvider.instance.recalculateProgressFor(task.projectId);
    }
  }

  Future<Task?> getParent(Task task) async {
    final db = await _provider.database;
    return Task.fromMap((await db.rawQuery(
      '''
      SELECT * FROM tasks WHERE parent_id=?
      ''',
      [task.parentId]))[0]
    );
  }
}