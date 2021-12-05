import 'dart:io';
import 'package:expandable_text/expandable_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/selected_project_cubit.dart';
import '../cubit/selected_task_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../models/settings.dart';
import '../models/status.dart';
import '../models/task.dart';
import '../pages/edit_task_page.dart';
import '../providers/projects_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/main_bottom_nav_bar.dart';
import '../widgets/task_container.dart';
import 'add_task_page.dart';


class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  static const String routeName = "TaskPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, Settings>(
      builder: (context, settingsState) {
        return BlocBuilder<SelectedTaskCubit, Task?>(
          builder: (context, activeTask) {
            return BlocBuilder<TasksCubit, List<Task>>(
              builder: (context, tasks) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await BlocProvider.of<TasksCubit>(context).load(
                      activeTask!.projectId,
                      id: activeTask.id
                    );
                  },
                  child: WillPopScope(
                    onWillPop: () async {
                      final selectedTaskCubit = BlocProvider.of<SelectedTaskCubit>(context);
                      if (selectedTaskCubit.state.parentId != null) {
                        selectedTaskCubit.select(
                          await TasksProvider.instance.getOne(selectedTaskCubit.state.parentId!)
                        );
                        await BlocProvider.of<TasksCubit>(context).load(
                          BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                          id: selectedTaskCubit.state.id
                        );
                      } else {
                        selectedTaskCubit.unselect();
                        await BlocProvider.of<TasksCubit>(context).load(
                          BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                        );
                      }
                      return true;
                    },
                    child: Scaffold(
                      appBar: buildAppBar(
                        context,
                        title: activeTask!.name,
                        actions: [
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskPage(activeTask)
                              )
                            ),
                            icon: Icon(FluentIcons.edit_20_regular,
                              color: Theme.of(context).textTheme.bodyText1!.color,
                              size: 20
                            )
                          )
                        ]
                      ),
                      body: buildBody(context),
                      bottomNavigationBar: const MainBottomNavBar(),
                    )
                  )
                );
              }
            );
          }
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    final DateFormat dateFormat = DateFormat.MEd(Platform.localeName);
    final selectedTaskCubit = context.read<SelectedTaskCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(context, 5),
            vertical: ScreenSize.width(context, 2.5)
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(context, 5)
          ),
          width: ScreenSize.width(context, 100),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
            )
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /*
                  * PRIORITY
                  */
                  Column(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.priority,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: kSystemTextColorForLightTheme
                        ),
                      ),
                      Icon(
                        FluentIcons.flag_24_filled,
                        color: _getPiorityColor(selectedTaskCubit.state.priority),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: ScreenSize.height(context, 1)
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.width(context, 3),
                      vertical: ScreenSize.width(context, 3)
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24)
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 50,
                          color: Colors.black.withOpacity(0.07),
                          offset: Offset.zero,
                          spreadRadius: 1
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        if (
                          context.read<TasksCubit>().state.isEmpty &&
                          (
                            selectedTaskCubit.state.status == Status.inProcess.index ||
                            selectedTaskCubit.state.status == Status.completed.index ||
                            selectedTaskCubit.state.status == Status.expired.index
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
                            value: selectedTaskCubit.state.isComplited,
                            onChanged: (bool? value) async {
                              final tasksProvider = TasksProvider.instance;
                              final projectsCubit = context.read<ProjectsCubit>();
                              final slcdPrjctCubit = context.read<SelectedProjectCubit>();
                              if (value!) {
                                // Update selected task
                                await tasksProvider.update(
                                  selectedTaskCubit.state.copyWith(
                                    isComplited: value,
                                    status: Status.completed.index
                                  )
                                );
                                selectedTaskCubit.select(
                                  selectedTaskCubit.state.copyWith(
                                    isComplited: value,
                                    status: Status.completed.index
                                  )
                                );
                                // Update parent task if exists, else update project
                                if (selectedTaskCubit.state.parentId != null) {
                                  await tasksProvider.update(
                                    selectedTaskCubit.state.copyWith(
                                      complitedSubaskCount: selectedTaskCubit.state.complitedSubaskCount + 1
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
                                  selectedTaskCubit.state.endDate == null ||
                                  (
                                    DateTime.now().isAfter(selectedTaskCubit.state.startDate!) &&
                                    DateTime.now().isBefore(selectedTaskCubit.state.endDate!)
                                  )
                                ) {
                                  status = Status.inProcess.index;
                                } else {
                                  status = Status.expired.index;
                                }
                                // Update seleted task
                                await tasksProvider.update(
                                  selectedTaskCubit.state.copyWith(
                                    isComplited: value,
                                    status: status
                                  )
                                );
                                selectedTaskCubit.select(
                                  selectedTaskCubit.state.copyWith(
                                    isComplited: value,
                                    status: status
                                  )
                                );
                                // Update parent task if exists, else update project
                                if (selectedTaskCubit.state.parentId != null) {
                                  await tasksProvider.update(
                                    selectedTaskCubit.state.copyWith(
                                      complitedSubaskCount: selectedTaskCubit.state.complitedSubaskCount - 1
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
                              if (selectedTaskCubit.state.parentId != null) {
                                await TasksProvider.instance.recalculateComplitedSubtasksCountFor(
                                  await tasksProvider.getOne(selectedTaskCubit.state.parentId!)
                                );
                                // Update selected task state
                                selectedTaskCubit.select(
                                  await tasksProvider.getOne(selectedTaskCubit.state.id!)
                                );
                              } else {
                                await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
                                  slcdPrjctCubit.state!.id!
                                );
                              }
                              // Load selected project
                              slcdPrjctCubit.select(
                                await ProjectsProvider.instance.getOne(
                                  slcdPrjctCubit.state!.id!
                                )
                              );
                              // Load updated projects
                              await context.read<ProjectsCubit>().load();
                            },
                          )
                        else SizedBox(
                          height: ScreenSize.height(context, 6),
                        )
                      ],
                    ),
                  ),
                  /*
                  * STATUS
                  */
                  Column(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.status,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: kSystemTextColorForLightTheme
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenSize.width(context, 1),
                          ),
                          if (selectedTaskCubit.state.status == Status.expired.index)
                          ...[
                            const Icon(
                              FluentIcons.arrow_counterclockwise_20_regular,
                              color: kExpiredColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.expired,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: kExpiredColor
                              ),
                            )
                          ]
                          else if (selectedTaskCubit.state.status == Status.inProcess.index)
                          ...[
                            const Icon(
                              FluentIcons.arrow_clockwise_20_regular,
                              color: kInProcessColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.inProcess,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: kInProcessColor
                              ),
                            )
                          ]
                          else if (selectedTaskCubit.state.status == Status.locked.index)
                          ...[
                            const Icon(
                              FluentIcons.lock_closed_20_regular,
                              color: kLockColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.locked,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: kLockColor
                              ),
                            )
                          ]
                          else if (selectedTaskCubit.state.status == Status.completed.index)
                          ...[
                            const Icon(
                              FluentIcons.checkmark_20_regular,
                              color: kCompletedColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.complited,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: kCompletedColor
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        /*
         *  DATES 
         */
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(context, 5),
            vertical: ScreenSize.width(context, 2.5),
          ),
          padding: EdgeInsets.all(
            ScreenSize.width(context, 3)
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
            )
          ),
          child: Container(
            padding: EdgeInsets.all(
              ScreenSize.width(context, 5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (selectedTaskCubit.state.startDate != null)
                      Row(
                        children: <Widget>[
                          const Icon(
                            FluentIcons.calendar_ltr_20_regular
                          ),
                          Text(
                            dateFormat.format(selectedTaskCubit.state.startDate!),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      )
                    else
                      InkWell(
                        onTap: () {
                          // TODO: add handler
                        },
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              FluentIcons.calendar_add_20_regular
                            ),
                            Text(
                              AppLocalizations.of(context)!.startDate,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
                Row(
                  children: <Widget>[
                    if (selectedTaskCubit.state.endDate != null)
                      Row(
                        children: <Widget>[
                          const Icon(
                            FluentIcons.calendar_ltr_20_regular
                          ),
                          Text(
                            dateFormat.format(selectedTaskCubit.state.endDate!),
                            style: Theme.of(context).textTheme.bodyText1, 
                          ),
                        ],
                      )
                    else
                      InkWell(
                        onTap: () {
                          // TODO: add handler
                        },
                        child: Row(
                          children: <Widget>[
                            const Icon(FluentIcons.calendar_add_20_regular),
                            Text(
                              AppLocalizations.of(context)!.endDate,
                              style: Theme.of(context).textTheme.bodyText2
                            ),
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
        if (
          selectedTaskCubit.state.subtasksCount == 0 &&
          selectedTaskCubit.state.goal == null
        )
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(context, 5),
            vertical: ScreenSize.width(context, 2.5),
          ),
          padding: EdgeInsets.all(
            ScreenSize.width(context, 3)
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
            )
          ),
          child: Container(
            padding: EdgeInsets.all(
              ScreenSize.width(context, 5)
            ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*
              * PROGRESS 
              */
              if (selectedTaskCubit.state.subtasksCount != 0)
              CircularPercentIndicator(
                radius: ScreenSize.width(context, 20),
                lineWidth: 12,
                backgroundColor: Theme.of(context).textTheme.bodyText2!.color!,
                progressColor: Theme.of(context).primaryColor,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                center: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: selectedTaskCubit.state.complitedSubaskCount.toString() + '/',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor
                        )
                      ),
                      TextSpan(
                        text: selectedTaskCubit.state.subtasksCount.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).textTheme.bodyText2!.color
                        )
                      )
                    ]
                  ),
                ),
                percent: selectedTaskCubit.state.subtasksCount != 0 
                  ? selectedTaskCubit.state.complitedSubaskCount 
                    / selectedTaskCubit.state.subtasksCount
                  : 0,
              ),
              if (
                selectedTaskCubit.state.subtasksCount != 0 &&
                selectedTaskCubit.state.goal != null && 
                selectedTaskCubit.state.goal!.isNotEmpty
              )
              SizedBox(
                height: ScreenSize.height(context, 2),
              ),
              /*
              * GOAL 
              */
              if (
                selectedTaskCubit.state.goal != null && 
                selectedTaskCubit.state.goal!.isNotEmpty
              )
              Align(
                alignment: Alignment.topLeft,
                child: ExpandableText(
                  selectedTaskCubit.state.goal!,
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
              )
            ],
              ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenSize.width(context, 5)
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
            ),
            width: ScreenSize.width(context, 100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenSize.width(context, 5)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.subtasks,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          if (
                            !selectedTaskCubit.state.isComplited &&
                            selectedTaskCubit.state.subtasksCount == 0
                          )
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(kBorderRadius)
                                ),
                                border: Border.all(
                                  color: Theme.of(context).backgroundColor,
                                  width: kBorderWidth
                                )
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: BlocProvider.of<SelectedProjectCubit>(context),
                                        child: const AddTaskPage(),
                                      )
                                    )
                                  );
                                }, 
                                icon: const Icon(FluentIcons.add_24_regular)
                              ),
                            )
                        ],
                      )
                    ] 
                  ),
                ),
                BlocBuilder<TasksCubit, List<Task>>(
                  builder: (context, tasks) {
                    if (tasks.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) => TaskContainer(tasks[index])
                        ),
                      );
                    } else {
                      return Expanded(
                        child: SizedBox(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.noTasks,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ),
                        ),
                      );
                    }
                  }
                ),
              ],
            ),
          ),
        )
      ],
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