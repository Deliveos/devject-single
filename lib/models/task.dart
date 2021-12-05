import 'package:devject_single/providers/tasks_provider.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable{
  /// Unique index for every task
  final int? id;
  /// Task name
  final String name;
  /// Goal of the task
  final String? goal;
  /// ID of project
  final int projectId;
  /// Parent task ID
  final int? parentId;
  /// Start date of the task
  final DateTime? startDate;
  /// End date of the task
  final DateTime? endDate;
  /// Priority of the task.
  /// 
  /// Can be:
  /// 
  /// |Name|Value|
  /// |---|---|
  /// |`Lock`|0|
  /// |`Waiting`|1|
  /// |`In process`|2|
  /// |`Done`|3|
  final int status;
  /// Status of the task.
  /// 
  /// Can be:
  /// 
  /// |Name|Value|
  /// |---|---|
  /// |`High`|2|
  /// |`Medium`|1|
  /// |`Low`|0|
  final int priority;
  /// Subtask count for the task
  final int subtasksCount;
  /// Complited subtask count for the task
  final int complitedSubaskCount;
  final bool isComplited;
  
  const Task({
    this.id,
    required this.name, 
    this.goal,
    this.parentId,
    required this.projectId,
    this.startDate, 
    this.endDate,
    this.priority = 0,
    this.status = 0,
    this.subtasksCount = 0,
    this.complitedSubaskCount = 0,
    this.isComplited = false,
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
  ///   "priority": 0,
  ///   "status": 1,
  ///   "progress": 100
  /// }
  /// ```
  Task.fromMap(Map<String, dynamic> map):
  id = map[TasksTableField.id],
  name = map[TasksTableField.name], 
  goal = map[TasksTableField.goal],
  projectId = map[TasksTableField.projectId],
  parentId = map[TasksTableField.parentId],
  startDate = map[TasksTableField.startDate] != null 
    ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) 
    : null,
  endDate = map[TasksTableField.endDate] != null 
    ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) 
    : null,
  priority = map[TasksTableField.priority],
  status = 0,
  subtasksCount = map[TasksTableField.subtaskCount],
  complitedSubaskCount = map[TasksTableField.complitedSubaskCount],
  isComplited = map[TasksTableField.isComplited] != 0 ? true : false;

  const Task.byDefault():
  id = null,
  name = '',
  goal = '',
  isComplited = false,
  subtasksCount = 0,
  complitedSubaskCount = 0,
  startDate = null,
  endDate = null,
  projectId = 0,
  parentId = null,
  status = 0,
  priority = 0;


  /// Convert `Task` instance to `Map<String, dynamic>`
  Map<String, dynamic> toMap() => <String, dynamic>{
    TasksTableField.id                   : id,
    TasksTableField.name                 : name,
    TasksTableField.goal                 : goal,
    TasksTableField.projectId            : projectId,
    TasksTableField.parentId             : parentId,
    TasksTableField.startDate            : startDate?.millisecondsSinceEpoch ,
    TasksTableField.endDate              : endDate?.millisecondsSinceEpoch,
    TasksTableField.priority             : priority,
    TasksTableField.subtaskCount         : subtasksCount,
    TasksTableField.complitedSubaskCount : complitedSubaskCount,
    TasksTableField.isComplited          : isComplited ? 1 : 0
  };

  /// Create copy of `Task` instance with new parameters
  Task copyWith({
    int? id,
    String? name,
    String? goal,
    int? projectId,
    int? parentId,
    DateTime? startDate,
    DateTime? endDate,
    int? priority,
    int? subtaskCount,
    int? complitedSubaskCount,
    int? status,
    bool? isComplited,
  }) => Task(
    id: id ?? this.id,
    name: name ?? this.name,
    goal: goal ?? this.goal,
    projectId: projectId ?? this.projectId,
    parentId: parentId ?? this.parentId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    priority: priority ?? this.priority,
    subtasksCount: subtaskCount ?? this.subtasksCount,
    complitedSubaskCount: complitedSubaskCount ?? this.complitedSubaskCount,
    status: status ?? this.status,
    isComplited: isComplited ?? this.isComplited
  );

  @override
  String toString() {
    return 'Task { '
    'id: $id, '
    'name: $name, '
    'description: $goal, '
    'projectId: $projectId, '
    'parentId: $parentId, '
    'startDate: $startDate, '
    'endDate: $endDate, '
    'priority: $priority, '
    'subtaskCount: $subtasksCount, '
    'complitedSubaskCount: $complitedSubaskCount, '
    'status: $status, '
    'isComplited: $isComplited '
    '}';
  }

  @override
  List<Object?> get props => [
    id, 
    name, 
    goal, 
    projectId, 
    parentId, 
    startDate, 
    endDate, 
    priority, 
    subtasksCount,
    complitedSubaskCount,
    status, 
    isComplited, 
  ];
}