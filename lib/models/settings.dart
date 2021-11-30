class Settings {
  Settings({
    required this.useCheckBox
  }); 

  final bool useCheckBox;

  Settings.fromMap(Map<String, dynamic> map): 
  useCheckBox = map['use_checkbox'] == 0 ? false : true;
  
  Map<String, dynamic> toMap() => {
    'use_checkbox': useCheckBox
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