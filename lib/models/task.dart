class Task {
  Task({
    this.id,
    required this.name, 
    this.description,
    this.parentId,
    required this.projectId,
    this.startDate, 
    this.endDate,
    this.progress = 0
  });

  final int? id;
  final String name;
  final String? description;
  final int projectId;
  final int? parentId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int progress;

  Task.fromMap(Map<String, dynamic> map):
  id = map['id'],
  name = map['name'], 
  description = map['description'],
  projectId = map['project_id'],
  parentId = map['parent_id'],
  startDate = map['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) : null,
  endDate = map['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
  progress = map['progress'];

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'project_id': projectId,
    'parent_id': parentId,
    'start_date': startDate?.millisecondsSinceEpoch ,
    'end_date': endDate?.millisecondsSinceEpoch,
    'progress': progress
  };

  Task copyWith({
    int? id,
    String? name,
    String? description,
    int? projectId,
    int? parentId,
    DateTime? startDate,
    DateTime? endDate,
    int? progress
  }) => Task(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    projectId: projectId ?? this.projectId,
    parentId: parentId ?? this.parentId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    progress: progress ?? this.progress
  );

  @override
  String toString() {
    return 'Task { id:$id, name:$name, description:$description, '
    'projectId:$projectId, parentId:$parentId, startDate:$startDate, '
    'endDate:$endDate, progress:$progress}';
  }
}