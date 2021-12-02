import 'dart:io';
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
    await database.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        start_date TIMESTAMP,
        end_date TIMESTAMP,
        progress INTEGER DEFAULT 0
      );
    ''');
    await database.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        start_date TIMESTAMP,
        start_when_finished_id INT,
        end_date TIMESTAMP,
        time_execution TIMESTAMP,
        project_id INTEGER NOT NULL,
        parent_id INTEGER,
        progress INTEGER DEFAULT 0,
        FOREIGN KEY(project_id) REFERENCES projects(id),
        FOREIGN KEY(parent_id) REFERENCES tasks(id),
        FOREIGN KEY(start_when_finished_id) REFERENCES tasks(id)
      );
    ''');
    await database.execute('''
      CREATE TABLE settings (
        locale VARCHAR(4)
        is_checkbox INTEGER NOT NULL,
        is_dark_theme INTEGER NOT NULL
      );
    ''');
    await database.execute('''
      INSERT INTO settings(is_checkbox, is_dark_theme)
      VALUES(0, 1);
    ''');
  }
}