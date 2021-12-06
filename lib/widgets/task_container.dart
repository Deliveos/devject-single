import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/curret_tasks_cubit.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/status.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/task_page.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/system_info_item.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer(this.task, {Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.MMMEd(Platform.localeName);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ScreenSize.height(context, 1),
        horizontal: ScreenSize.width(context, 5)
      ),
      padding: EdgeInsets.all(ScreenSize.width(context, 5)),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kCardBorderRadius)
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.07),
            offset: Offset.zero,
            spreadRadius: 0
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (
                task.subtasksCount == 0 &&
                (
                  task.status == Status.inProcess.index ||
                  task.status == Status.completed.index ||
                  task.status == Status.expired.index
                )
              )
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
                    final slcdTskCubit = context.read<SelectedTaskCubit>();
                    final projectsCubit = context.read<ProjectsCubit>();
                    final slcdPrjctCubit = context.read<SelectedProjectCubit>();
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
                        await tasksProvider.update(
                          slcdTskCubit.state.copyWith(
                            complitedSubaskCount: slcdTskCubit.state.complitedSubaskCount + 1
                          )
                        );
                      } else {
                        projectsCubit.update(
                          slcdPrjctCubit.state!.copyWith(
                            complitedTaskCount: slcdPrjctCubit.state!.complitedTaskCount + 1
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
                        await tasksProvider.update(
                          slcdTskCubit.state.copyWith(
                            complitedSubaskCount: slcdTskCubit.state.complitedSubaskCount - 1
                          )
                        );
                      } else {
                        projectsCubit.update(
                          slcdPrjctCubit.state!.copyWith(
                            complitedTaskCount: slcdPrjctCubit.state!.complitedTaskCount - 1
                          )
                        );
                      }
                    }
                    // Reculculate complited task
                    if (task.parentId != null) {
                      await TasksProvider.instance.recalculateComplitedSubtasksCountFor(
                        await tasksProvider.getOne(task.parentId!)
                      );
                      // Update selected task state
                      slcdTskCubit.select(
                        await tasksProvider.getOne(task.parentId!)
                      );
                    } else {
                      await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
                        slcdPrjctCubit.state!.id!
                      );
                    }
                      
                    // Load updated tasks
                    await context.read<TasksCubit>().load(
                      slcdPrjctCubit.state!.id!,
                      id: task.parentId
                    );
                    // Load selected project
                    slcdPrjctCubit.select(
                      await ProjectsProvider.instance.getOne(
                        slcdPrjctCubit.state!.id!
                      )
                    );
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
                  child: task.isComplited 
                  ? Text(
                    task.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      decoration: TextDecoration.lineThrough
                    )
                  )
                  : Text(
                    task.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1!
                  ),
                ),
              ),
              /*
              * STATUS ICON
              */
              if (task.status == Status.expired.index)
                const Icon(
                  FluentIcons.arrow_counterclockwise_20_regular,
                  color: kExpiredColor,
                )
              else if (task.status == Status.inProcess.index)
                const Icon(
                  FluentIcons.arrow_clockwise_20_regular,
                  color: kInProcessColor,
                )
              else if (task.status == Status.locked.index)
                const Icon(
                  FluentIcons.lock_closed_20_regular,
                  color: kLockColor,
                )
              else if (task.status == Status.completed.index)
                const Icon(
                  FluentIcons.checkmark_20_regular,
                  color: kCompletedColor,
                )
            ],
          ),
          SizedBox(
            height: ScreenSize.height(context, 1)
          ),
          if (task.goal != null && task.goal!.isNotEmpty)
            Align(
              alignment: Alignment.topLeft,
              child: ExpandableText(
                task.goal!,
                expandText: '',
                maxLines: 1,
                expandOnTextTap: true,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontStyle: FontStyle.italic
                ),
                prefixText: AppLocalizations.of(context)!.goal + ": ",
                prefixStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontStyle: FontStyle.normal
                ),
                collapseOnTextTap: true,
              ),
            ),
          SizedBox(height: ScreenSize.height(context, 1)),
          Row(
            children: <Widget>[
              SystemInfoItem(
                iconData: FluentIcons.calendar_ltr_24_regular, 
                text: task.endDate != null 
                  ? dateFormat.format(task.endDate!)
                  : AppLocalizations.of(context)!.indefinite
              ),
              if (task.subtasksCount != 0)
              ...[
                Icon(
                FluentIcons.divider_tall_24_regular,
                color: Theme.of(context).iconTheme.color!.withOpacity(0.3)
                ),
                SystemInfoItem(
                  iconData: FluentIcons.branch_24_regular, 
                  text: task.subtasksCount.toString()
                ),
                Icon(
                  FluentIcons.divider_tall_24_regular,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.3)
                ),
                SystemInfoItem(
                  iconData: FluentIcons.checkmark_24_regular, 
                  text: task.complitedSubaskCount.toString()
                ),
              ]
            ]
          )
        ]
      )
    );
  }
}