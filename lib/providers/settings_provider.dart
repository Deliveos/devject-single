import 'package:devject_single/models/settings.dart';
import 'package:devject_single/providers/i_provider.dart';
import 'package:devject_single/services/database.dart';

class SettingProvider implements IProvider<Settings> {
  SettingProvider._privateConstructor();

  static final SettingProvider instance = SettingProvider._privateConstructor();
  static final DatabaseProvider _provider = DatabaseProvider.instance;

  @override
  Future<int> add(Settings settings) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
      INSERT INTO settings(is_checkbox)
      VALUE(?)
      ''',
      [settings.useCheckBox]
    );
  }

  @override
  Future<List<Settings>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery(
      '''
      SELECT * FROM settings
      '''
    )).map((map) => Settings.fromMap(map)).toList();
  }

  @override
  Future<Settings> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery(
      '''
      SELECT * FROM settings
      '''
    );
    return Settings.fromMap(map.first);
  }

  @override
  Future<int> remove(int id) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE settings
      SET is_checkbox=0
      '''
    );
  }

  @override
  Future<int> update(Settings settings) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE settings
      SET is_checkbox=?
      ''',
      [
        settings.useCheckBox ? 1 : 0
      ]
    );
  }
}