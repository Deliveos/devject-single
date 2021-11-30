class Settings {
  Settings({
    required this.useCheckBox
  }); 

  final bool useCheckBox;

  Settings.fromMap(Map<String, dynamic> map): 
  useCheckBox = map['is_checkbox'] != 0 ? true : false;
  
  Map<String, dynamic> toMap() => {
    'is_checkbox': useCheckBox
  };

  Settings copyWith({
    bool? useCheckBox
  }) => Settings(
    useCheckBox: useCheckBox ?? this.useCheckBox
  );

  @override
  String toString() {
    return 'Settings { useCheckBox:$useCheckBox }';
  }
}