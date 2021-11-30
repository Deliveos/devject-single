class Task {
  /// Unique index for every task
  final int? id;
  /// Task name
  final String name;
  /// Can be used to supplement information about task
  final String? description;
  final int projectId;
  final int? parentId;
  /// Start date of the task
  final DateTime? startDate;
  /// End date of the task
  final DateTime? endDate;
  /// Task progress as a percentage
  final int progress;
  
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

  /// Create `Task` instance from `Map<String, dynamic>`.
  /// Map example:
  /// ```
  /// {
  ///   "id": 1,  
  ///   "name": "Example task",
  ///   "description": "Example task",
  ///   "start_date": null,
  ///   "end_date": null,
  ///   "progress": 100
  /// }
  /// ```
  Task.fromMap(Map<String, dynamic> map):
  id = map['id'],
  name = map['name'], 
  description = map['description'],
  projectId = map['project_id'],
  parentId = map['parent_id'],
  startDate = map['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) : null,
  endDate = map['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
  progress = map['progress'];

  /// Convert `Task` instance to `Map<String, dynamic>`
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

  /// Create copy of `Task` instance with new parameters
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