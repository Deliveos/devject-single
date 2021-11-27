import 'package:devject_single/models/project.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/services/database.dart';

class ProjectsProvider {
  static final _provider = DatabaseProvider.instance;

  static Future<int> add(Project project) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
        INSERT INTO projects(name, description, start_date, end_date)
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

  static Future<List<Project>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery('''
      SELECT * FROM projects ORDER BY name
    ''')).map((map) => Project.fromMap(map)).toList();
  }

  static Future<Project> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery('''
      SELECT * FROM projects
      WHERE id=?
    ''', [id]);
    return Project.fromMap(map.first);
  }

  static Future<int> update(Project project) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE projects
      SET name=?, description=?, start_date=?, end_date=?, progress=?
      WHERE id=?
      ''',
      [
        project.name,
        project.description,
        project.startDate?.millisecondsSinceEpoch,
        project.endDate?.millisecondsSinceEpoch,
        project.progress,
        project.id
      ]
    );
  }

  

  static Future<int> remove(int id) async {
    final db = await _provider.database;
    await db.rawDelete(
      '''
      DELETE FROM tasks WHERE project_id=?
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

  static Future<int> updateProgress(int id, int progress) async {
    final db = await _provider.database;
    return await db.rawUpdate('''
      UPDATE projects
      SET progress=?
      WHERE id=?
    ''',
    [ progress, id ]);
  }

  static Future recalculateProgressFor(int id) async {
    final tasks = await TaskProvider.get(id);
    int averageProgress = 0;
    for (var task in tasks) {
      averageProgress += task.progress;
    }
    averageProgress ~/= tasks.length;
    await updateProgress(id, averageProgress);
  }

}