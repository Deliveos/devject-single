import 'dart:io';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/settings_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static const String _dbName = "devject_single.db";
  static const int _dbVersion = 1;

  static final DatabaseProvider instance = DatabaseProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase () async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database database, int version) async {
    await database.execute(
      '''
      CREATE TABLE ${ProjectsProvider.tableName}(
        ${ProjectsTableField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProjectsTableField.name} VARCHAR(255) NOT NULL,
        ${ProjectsTableField.description} TEXT,
        ${ProjectsTableField.startDate} TIMESTAMP,
        ${ProjectsTableField.endDate} TIMESTAMP,
        ${ProjectsTableField.taskCount} INTEGER DEFAULT 0,
        ${ProjectsTableField.complitedTaskCount} INTEGER DEFAULT 0
      );
    ''');
    await database.execute('''
      CREATE TABLE ${TasksProvider.tableName} (
        ${TasksTableField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TasksTableField.name} VARCHAR(255) NOT NULL,
        ${TasksTableField.goal} TEXT,
        ${TasksTableField.priority} INTEGER DEFAULT 0,
        ${TasksTableField.startDate} TIMESTAMP,
        ${TasksTableField.endDate} TIMESTAMP,
        ${TasksTableField.projectId} INTEGER NOT NULL,
        ${TasksTableField.parentId} INTEGER,
        ${TasksTableField.subtaskCount} INTEGER DEFAULT 0,
        ${TasksTableField.complitedSubaskCount} INTEGER DEFAULT 0,
        ${TasksTableField.isComplited} INTEGER DEFAULT 0,
        FOREIGN KEY(${TasksTableField.projectId}) 
          REFERENCES ${ProjectsProvider.tableName}(${ProjectsTableField.id}),
        FOREIGN KEY(${TasksTableField.parentId}) 
          REFERENCES ${TasksProvider.tableName}(${TasksTableField.id})
      );
    ''');
    await database.execute('''
      CREATE TABLE ${SettingProvider.tableName} (
        ${SettigsTableField.locale} VARCHAR(10),
        ${SettigsTableField.isDarkTheme} INTEGER
      );
    ''');
    await database.execute(
      '''
      INSERT INTO ${SettingProvider.tableName}(
        ${SettigsTableField.isDarkTheme}
      )
      VALUES(0)
      '''
    );
  }
}