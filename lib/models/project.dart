class Project {
  final int? id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final int progress;

  Project({
    this.id,
    required this.name, 
    this.description,
    this.startDate, 
    this.endDate, 
    this.progress = 0});

  Project.fromMap(Map<String, dynamic> map):
  id = map['id'],
  name = map['name'], 
  description = map['description'],
  startDate = map['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) : null,
  endDate = map['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
  progress = map['progress'];

  Map<String, dynamic> toMap() => <String, dynamic>{
    "id": id,
    "name": name,
    "description": description,
    "start_date": startDate?.millisecondsSinceEpoch ,
    "end_date": endDate?.millisecondsSinceEpoch,
    "progress": progress
  };

  Project copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? progress
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    progress: progress ?? this.progress
  );

  @override
  String toString() {
    return 'Project {id:$id, name=$name, description=$description, startDate=$startDate, endDate=$endDate, progress=$progress}';
  }
}