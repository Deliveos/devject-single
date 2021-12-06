import 'package:devject_single/models/settings.dart';
import 'package:devject_single/providers/i_provider.dart';
import 'package:devject_single/services/database.dart';

class SettingProvider implements IProvider<Settings> {
  SettingProvider._privateConstructor();

  static final SettingProvider instance = SettingProvider._privateConstructor();
  static final DatabaseProvider _provider = DatabaseProvider.instance;

  static const tableName = 'settings';

  @override
  Future<int> add(Settings settings) async {
    final db = await _provider.database;
    return await db.rawInsert(
      '''
      INSERT INTO ${SettingProvider.tableName}(
        ${SettigsTableField.isDarkTheme}
      )
      VALUES(?)
      ''',
      [settings.isDarkTheme]
    );
  }

  @override
  Future<List<Settings>> get() async {
    final db = await _provider.database;
    return (await db.rawQuery(
      '''
      SELECT * FROM ${SettingProvider.tableName}
      '''
    )).map((map) => Settings.fromMap(map)).toList();
  }

  @override
  Future<Settings> getOne(int id) async {
    final db = await _provider.database;
    final map = await db.rawQuery(
      '''
      SELECT * FROM ${SettingProvider.tableName}
      '''
    );
    return Settings.fromMap(map.first);
  }

  @override
  Future<int> remove(int id) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE ${SettingProvider.tableName}
      SET ${SettigsTableField.isDarkTheme}=0
      '''
    );
  }

  @override
  Future<int> update(Settings settings) async {
    final db = await _provider.database;
    return await db.rawUpdate(
      '''
      UPDATE ${SettingProvider.tableName}
      SET ${SettigsTableField.isDarkTheme}=?
      ''',
      [
        settings.isDarkTheme! ? 1 : 0
      ]
    );
  }
}

class SettigsTableField {
  static const locale = 'locale';
  static const isDarkTheme = 'is_dark_theme';
}