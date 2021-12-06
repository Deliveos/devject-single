import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../cubit/curret_tasks_cubit.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/selected_task_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../models/status.dart';
import '../models/task.dart';
import '../pages/task_page.dart';
import '../providers/projects_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/screen_size.dart';
import '../widgets/system_info_item.dart';


class CurrentTaskContainer extends StatelessWidget {
  const CurrentTaskContainer(this.task, {
    Key? key
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.MEd(Platform.localeName);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ScreenSize.width(context, 2.5)
      ),
      padding: EdgeInsets.all(
        ScreenSize.width(context, 5)
      ),
      width: ScreenSize.width(context, 100),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kCardBorderRadius)
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Checkbox(
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Theme.of(context).textTheme.bodyText2!.color!,
                      width: 2
                    )
                  ),
                  checkColor: Theme.of(context).primaryColor,
                  activeColor: Theme.of(context).primaryColor,
                  splashRadius: 0,
                  visualDensity: VisualDensity.compact,
                  value: task.isComplited,
                  onChanged: (bool? value) async {
                    final tasksProvider = TasksProvider.instance;
                    final projectProvider = ProjectsProvider.instance;
                    final projectsCubit = context.read<ProjectsCubit>();
                    if (value!) {
                      // Update task
                      await tasksProvider.update(
                        task.copyWith(
                          isComplited: value,
                          status: Status.completed.index
                        )
                      );
                      // Update parent task if exists, else update project
                      if (task.parentId != null) {
                        final parent = await tasksProvider.getOne(task.parentId!);
                        await tasksProvider.update(
                          parent.copyWith(
                            complitedSubaskCount: parent.complitedSubaskCount + 1
                          )
                        );
                      } else {
                        final project = await projectProvider.getOne(task.projectId);
                        projectsCubit.update(
                          project.copyWith(
                            complitedTaskCount: project.complitedTaskCount + 1
                          )
                        );
                      }
                    } else {
                      int status = 0;
                      if (
                        task.endDate == null ||
                        (
                          DateTime.now().isAfter(task.startDate!) &&
                          DateTime.now().isBefore(task.endDate!)
                        ) ||
                        DateTime.now() == task.startDate!
                      ) {
                        status = Status.inProcess.index;
                      } else {
                        status = Status.expired.index;
                      }
                      // Update task
                      tasksProvider.update(
                        task.copyWith(
                          isComplited: value,
                          status: status
                        )
                      );
                      // Update parent task if exists, else update project
                      if (task.parentId != null) {
                        final parent = await tasksProvider.getOne(task.parentId!);
                        await tasksProvider.update(
                          parent.copyWith(
                            complitedSubaskCount: parent.complitedSubaskCount - 1
                          )
                        );
                      } else {
                        final project = await projectProvider.getOne(task.projectId);
                        projectsCubit.update(
                          project.copyWith(
                            complitedTaskCount: project.complitedTaskCount - 1
                          )
                        );
                      }
                    }
                    // Reculculate complited task
                    if (task.parentId != null) {
                      await TasksProvider.instance.recalculateComplitedSubtasksCountFor(
                        await tasksProvider.getOne(task.parentId!)
                      );
                    } else {
                      await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
                        task.projectId
                      );
                    }
                    // Load updated projects
                    await context.read<ProjectsCubit>().load();
                    // Load updated current tasks
                    await context.read<CurretTasksCubit>().load();
                  },
              ),
              /*
              * TASK NAME
              */
              Expanded(
                child: InkWell(
                  onTap: () async {
                    BlocProvider.of<SelectedTaskCubit>(context).select(task);
                    await BlocProvider.of<TasksCubit>(context).load(
                      task.projectId, 
                      id: task.id
                    );
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<SelectedTaskCubit>(context),
                          child: BlocProvider.value(
                            value: BlocProvider.of<TasksCubit>(context),
                            child: const TaskPage(),
                          ),
                        )
                      )
                    );
                  },
                  child: Text(
                    task.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1!
                  ),
                ),
              ),
              // Flag
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).textTheme.bodyText2!.color!,
                    width: kBorderWidth
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      kBorderRadius
                    )
                  )
                ),
                child: Icon(
                  FluentIcons.flag_20_filled,
                  size: kIconSize,
                  color: _getPiorityColor(task.priority),
                ),
              )
            ]
          ),
          SizedBox(
            height: ScreenSize.height(context, 2),
          ),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.project,
                style: Theme.of(context).textTheme.bodyText2
              ),
              SizedBox(
                width: ScreenSize.width(context, 1),
              ),
              Text(
                context.read<ProjectsCubit>().state.firstWhere(
                  (element) => element.id == task.projectId
                ).name,
                style: Theme.of(context).textTheme.bodyText1
              )
            ]
          ),
          if (task.goal != null && task.goal!.isNotEmpty)
          ...[
            SizedBox(
              height: ScreenSize.height(context, 1),
            ),
            Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.goal,
                  style: Theme.of(context).textTheme.bodyText2
                ),
                SizedBox(
                  width: ScreenSize.width(context, 1),
                ),
                Text(
                  task.goal!,
                  style: Theme.of(context).textTheme.bodyText1
                )
              ]
            ),
          ],
          SizedBox(
            height: ScreenSize.height(context, 2),
          ),
          Row(
            children: <Widget>[
              SystemInfoItem(
                iconData: FluentIcons.calendar_ltr_24_regular, 
                text: task.endDate != null 
                ? dateFormat.format(task.endDate!)
                : AppLocalizations.of(context)!.indefinite
              )
            ]
          )
        ]
      )
    );
  }

  Color _getPiorityColor(int priority) {
    Color color = kLowPriorityColor;
    switch (priority) {
      case 0:
        color = kLowPriorityColor;
        break;
      case 1:
        color = kMediumPriorityColor;
        break;
      case 2:
        color = kHighPriorityColor;
        break;
    }
    return color;
  }
}