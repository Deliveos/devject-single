import 'dart:io';

class Settings {
  Settings({
    this.locale,
    this.isDarkTheme = true
  }); 

  final String? locale;
  final bool? isDarkTheme;

  Settings.fromMap(Map<String, dynamic> map):
  locale = map['locale'],
  isDarkTheme = map['is_dark_theme'] != 0 ? true : false;

  Settings.byDefault():
  locale = Platform.localeName,
  isDarkTheme = true;

  Map<String, dynamic> toMap() => {
    'locale': locale,
    'is_dark_theme': isDarkTheme
  };

  Settings copyWith({
    String? locale,
    bool? isDarkTheme
  }) => Settings(
    locale: locale ?? this.locale,
    isDarkTheme: isDarkTheme ?? this.isDarkTheme
  );

  @override
  String toString() {
    return 'Settings { '
    'locale:$locale '
    'isDarkTheme:$isDarkTheme }';
  }
}