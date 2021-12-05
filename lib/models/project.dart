class Project {
  /// Unique index for every project
  final int? id;
  /// Project name
  final String name;
  /// Can be used to supplement information about project
  final String? description;
  /// Start date of project development
  final DateTime? startDate;
  /// End date of project development
  final DateTime? endDate;
  /// Tasks count for the project
  final int tasksCount;
  /// Complited tasks count for the project
  final int complitedTaskCount;

  Project({
    this.id,
    required this.name, 
    this.description,
    this.startDate, 
    this.endDate,
    this.tasksCount = 0,
    this.complitedTaskCount = 0
  });

  /// Create `Project` instance from `Map<String, dynamic>`.
  /// Map example:
  /// ```
  /// {
  ///   "id": 1,  
  ///   "name": "Example",
  ///   "description": "Example project",
  ///   "start_date": null,
  ///   "end_date": null,
  ///   "progress": 100
  /// }
  /// ```
  Project.fromMap(Map<String, dynamic> map):
  id = map['id'],
  name = map['name'], 
  description = map['description'],
  startDate = map['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) : null,
  endDate = map['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
  tasksCount = map['task_count'],
  complitedTaskCount = map['complited_task_count'];

  /// Convert `Project` instance to `Map<String, dynamic>`
  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'start_date': startDate?.millisecondsSinceEpoch ,
    'end_date': endDate?.millisecondsSinceEpoch,
    'task_count': tasksCount,
    'complited_task_count': complitedTaskCount,
  };

  /// Create copy of `Project` instance with new parameters
  Project copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? tasksCount,
    int? complitedTaskCount,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    tasksCount: tasksCount ?? this.tasksCount,
    complitedTaskCount: complitedTaskCount ?? this.complitedTaskCount,
  );

  @override
  String toString() {
    return 'Project {'
    'id:$id, '
    'name=$name, '
    'description=$description, '
    'startDate=$startDate, '
    'endDate=$endDate, '
    'taskCount=$tasksCount, '
    'complitedTaskCount=$complitedTaskCount '
    '}';
  }
}