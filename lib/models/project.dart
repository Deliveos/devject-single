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
  /// Project development progress as a percentage
  final int progress;

  Project({
    this.id,
    required this.name, 
    this.description,
    this.startDate, 
    this.endDate, 
    this.progress = 0});

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
  progress = map['progress'];

  /// Convert `Project` instance to `Map<String, dynamic>`
  Map<String, dynamic> toMap() => <String, dynamic>{
    "id": id,
    "name": name,
    "description": description,
    "start_date": startDate?.millisecondsSinceEpoch ,
    "end_date": endDate?.millisecondsSinceEpoch,
    "progress": progress
  };

  /// Create copy of `Project` instance with new parameters
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