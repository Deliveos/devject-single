import 'package:devject_single/models/project.dart';
import 'package:devject_single/models/status.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/i_provider.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/services/database.dart';

/// Providing database operations for tasks
class TasksProvider implements IProvider<Task> {
  TasksProvider._privateConstructor();

  static final TasksProvider instance = TasksProvider._privateConstructor();
  static final DatabaseProvider _provider = DatabaseProvider.instance;
  static const tableName = 'tasks';

  @override
  Future<int> add(Task task) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
        INSERT INTO $tableName(
          ${TasksTableField.name}, 
          ${TasksTableField.goal}, 
          ${TasksTableField.projectId}, 
          ${TasksTableField.parentId},
          ${TasksTableField.startDate}, 
          ${TasksTableField.endDate},
          ${TasksTableField.priority}
        )
        VALUES(?, ?, ?, ?, ?, ?, ?)
      ''', 
      [
        task.name, 
        task.goal, 
        task.projectId,
        task.parentId,
        task.startDate?.millisecondsSinceEpoch, 
        task.endDate?.millisecondsSinceEpoch,
        task.priority
      ]
    );
  }

  @override
  Future<List<Task>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery(
      '''
      SELECT * FROM $tableName
      '''
    )).map((map) => Task.fromMap(map)).toList();
  }
  
  Future<List<Task>> getFor(int projectId, {int? id}) async {
    final db = await _provider.database;
    List<Task> tasks;
    if (id != null) {
      tasks = (await db.rawQuery(
        '''
          SELECT * FROM $tableName 
          WHERE ${TasksTableField.projectId}=? 
          AND ${TasksTableField.parentId}=?
        ''', 
        [projectId, id]
      )).map((map) => Task.fromMap(map)).toList();
    } else {
      tasks = (await db.rawQuery(
        '''
          SELECT * FROM $tableName 
          WHERE ${TasksTableField.projectId}=? 
          AND ${TasksTableField.parentId} IS NULL
        ''', 
        [projectId]
      )).map((map) => Task.fromMap(map)).toList();
    }
    Project project = await ProjectsProvider.instance.getOne(projectId);
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].startDate == null) {
        if (i > 0) {
          tasks[i] = tasks[i].copyWith(
            startDate: tasks[i-1].startDate ?? project.startDate
          );
        } else {
          tasks[i] = tasks[i].copyWith(
            startDate: project.startDate
          );
        }
        if (i < tasks.length) {
          if (tasks[i].endDate == null) {
            if (i < tasks.length - 1) {
              tasks[i] = tasks[i].copyWith(
                endDate: tasks[i + 1].endDate 
              );
            }
          }
        }
      }
      if (tasks[i].isComplited) {
        tasks[i] = tasks[i].copyWith(
          status: Status.completed.index
        );
      } else if (
        tasks[i].endDate == null ||
        (
          DateTime.now().isAfter(tasks[i].startDate!) &&
          DateTime.now().isBefore(tasks[i].endDate!)
        )
      ) {
        tasks[i] = tasks[i].copyWith(
          status: Status.inProcess.index
        );
      } else if (DateTime.now().isBefore(tasks[i].endDate!)) {
        tasks[i] = tasks[i].copyWith(
          status: Status.locked.index
        );
      } else {
        tasks[i] = tasks[i].copyWith(
          status: Status.expired.index
        );
      }
    }
    tasks.sort((a, b) {
      if (a.startDate != null && b.startDate != null) {
        return a.startDate!.isBefore(b.startDate!) ? 0 : 1;
      } else {
        if (a.startDate == null) {
          return 0;
        } else {
          return 1;
        }
      }
    });
    return tasks;
  }

  @override
  Future<Task> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery(
      '''
      SELECT * FROM $tableName WHERE ${TasksTableField.id}=?
      ''', 
      [id]
    );
    Task task = Task.fromMap(map.first);
    if (task.isComplited) {
      task = task.copyWith(
        status: Status.completed.index
      );
    } else if (
      task.endDate == null ||
      (
        DateTime.now().isAfter(task.startDate!) &&
        DateTime.now().isBefore(task.endDate!)
      )
    ) {
      task = task.copyWith(
        status: Status.inProcess.index
      );
    } else {
      task = task.copyWith(
        status: Status.expired.index
      );
    }
    return task;
  }

  @override
  Future<int> remove(int id) async {
    final db = await _provider.database;
    await db.rawDelete(
      '''
      DELETE FROM $tableName 
      WHERE ${TasksTableField.id}=?
      ''',
      [id]
    );
    return await db.rawDelete(
      '''
      DELETE FROM $tableName 
      WHERE ${TasksTableField.id}=?
      ''',
      [id]
    );
  }

  @override
  Future<int> update(Task task) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
        UPDATE $tableName SET 
        ${TasksTableField.name}=?, 
        ${TasksTableField.goal}=?, 
        ${TasksTableField.startDate}=?, 
        ${TasksTableField.endDate}=?,
        ${TasksTableField.subtaskCount}=?,
        ${TasksTableField.complitedSubaskCount}=?,
        ${TasksTableField.priority}=?,
        ${TasksTableField.isComplited}=?
        WHERE ${TasksTableField.id}=?
    ''',
    [
      task.name,
      task.goal,
      task.startDate?.millisecondsSinceEpoch,
      task.endDate?.millisecondsSinceEpoch,
      task.subtasksCount,
      task.complitedSubaskCount,
      task.priority,
      task.isComplited ? 1 : 0,
      task.id
    ]);
  }

  Future<int> updateCopmlited(int id, int complitedSubaskCount) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
        UPDATE $tableName SET 
        ${TasksTableField.complitedSubaskCount}=?
        WHERE ${TasksTableField.id}=?
      ''',
      [
        complitedSubaskCount, 
        id 
      ]
    );
  }

  Future recalculateComplitedSubtasksCountFor(Task task) async {
    final tasks = await getFor(
      task.projectId, id: task.id
    );
    int complitedCount = 0;
    for (var task in tasks) {
      if (task.isComplited) {
        complitedCount += 1;
      }
    }
    await updateCopmlited(task.id!, complitedCount);
    if (complitedCount == tasks.length) {
      await update(task.copyWith(
        isComplited: true
      ));
    } else {
      await update(task.copyWith(
        isComplited: false
      ));
    }
    if (task.parentId != null) {
      await recalculateComplitedSubtasksCountFor(await getOne(task.parentId!));
    } else {
      await ProjectsProvider.instance.recalculateComplitedTasksCountFor(task.projectId);
    }
  }

  Future<Task?> getParent(Task task) async {
    final db = await _provider.database;
    return Task.fromMap((await db.rawQuery(
      '''
      SELECT * FROM $tableName 
      WHERE ${TasksTableField.parentId}=?
      ''',
      [task.parentId]
    ))[0]);
  }
}

class TasksTableField {
  static const id = 'id';
  static const name = 'name';
  static const goal = 'goal';
  static const projectId = 'project_id';
  static const parentId = 'parent_id';
  static const startDate = 'start_date';
  static const endDate = 'end_date';
  static const priority = 'priority';
  static const subtaskCount = 'subtask_count';
  static const complitedSubaskCount = 'complited_subtask_count';
  static const isComplited = 'is_complited';
}