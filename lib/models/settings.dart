import 'dart:io';

class Settings {
  Settings({
    this.locale,
    this.useCheckBox = false,
    this.isDarkTheme = true
  }); 

  final String? locale;
  final bool useCheckBox;
  final bool isDarkTheme;

  Settings.fromMap(Map<String, dynamic> map):
  locale = map['locale'],
  useCheckBox = map['is_checkbox'] != 0 ? true : false,
  isDarkTheme = map['is_dark_theme'] != 0 ? true : false;

  Settings.byDefault():
  locale = Platform.localeName,
  useCheckBox = false,
  isDarkTheme = true;

  Map<String, dynamic> toMap() => {
    'locale': locale,
    'is_checkbox': useCheckBox,
    'is_dark_theme': isDarkTheme
  };

  Settings copyWith({
    String? locale,
    bool? useCheckBox,
    bool? isDarkTheme
  }) => Settings(
    locale: locale ?? this.locale,
    useCheckBox: useCheckBox ?? this.useCheckBox,
    isDarkTheme: isDarkTheme ?? this.isDarkTheme
  );

  @override
  String toString() {
    return 'Settings { '
    'locale:$locale '
    'useCheckBox:$useCheckBox, '
    'isDarkTheme:$isDarkTheme }';
  }
}