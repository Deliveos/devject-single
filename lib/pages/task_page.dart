import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/settings_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/settings.dart';
import 'package:devject_single/models/status.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/edit_task_page.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/task_container.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      body: buildBody(context)
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
                        // if (
                        //   context.read<TasksCubit>().state.isEmpty &&
                        //   (
                        //     selectedTaskCubit.state.status == Status.inProcess.index ||
                        //     selectedTaskCubit.state.status == Status.completed.index ||
                        //     selectedTaskCubit.state.status == Status.expired.index
                        //   )
                        // )
                        //   Checkbox(
                        //     shape: CircleBorder(
                        //       side: BorderSide(
                        //         color: Theme.of(context).textTheme.bodyText2!.color!,
                        //         width: 2
                        //       )
                        //     ),
                        //     checkColor: Theme.of(context).primaryColor,
                        //     activeColor: Theme.of(context).primaryColor,
                        //     splashRadius: 0,
                        //     visualDensity: VisualDensity.compact,
                        //     value: selectedTaskCubit.state.isComplited,
                        //     onChanged: (bool? value) async {
                        //       final complidedTask = selectedTaskCubit.state.copyWith(
                        //         isComplited: value,
                        //         status: value!
                        //           ? Status.completed.index
                        //           : null
                        //       );
                        //       if (!value) {
                        //         if (selectedTaskCubit.state.parentId != null) {
                        //           final parent = await TasksProvider.instance.getOne(
                        //             selectedTaskCubit.state.parentId!
                        //           );
                        //           await context.read<TasksCubit>().update(
                        //             parent.copyWith(
                        //               complitedSubaskCount: parent.complitedSubaskCount - 1
                        //             )
                        //           );
                        //           selectedTaskCubit.select(complidedTask);
                        //           await TasksProvider.instance.recalculateComplitedSubtasksCountFor(
                        //             await TasksProvider.instance.getOne(selectedTaskCubit.state.parentId!)
                        //           );
                        //         } else {
                        //           await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
                        //             context.read<SelectedProjectCubit>().state!.id!
                        //           );
                        //         }
                        //       }
                        //       await context.read<TasksCubit>().update(complidedTask);
                        //       await context.read<TasksCubit>().load(
                        //         context.read<SelectedProjectCubit>().state!.id!,
                        //         parentId: selectedTaskCubit.state.id!
                        //       );
                        //     },
                        //   )
                        // else SizedBox(
                        //   height: ScreenSize.height(context, 5),
                        // )
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
                          // Text(
                          //   "In Process",
                          //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          //     color: kInProcessColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
              
            ],
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: ScreenSize.width(context, 5),
                right: ScreenSize.width(context, 5),
                top: ScreenSize.width(context, 2.5),
                bottom: ScreenSize.width(context, 5)
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.width(context, 5)
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20)
                )
              ),
              /*
              * DATES
              */
              child: Container(
                padding: EdgeInsets.all(
                  ScreenSize.width(context, 5)
                ),
                child: Column(
                  children: <Widget>[
                    Column(
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
                        const Icon(
                          FluentIcons.arrow_down_20_regular
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
                    )
                  ],
                ),
              ),
            ),
          ],
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
            // height: ScreenSize.height(context, 40),
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