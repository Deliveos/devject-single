import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/settings_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/settings.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/edit_task_page.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/background.dart';
import 'package:devject_single/widgets/task_container.dart';
import 'package:expandable/expandable.dart';
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
    final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
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
                      parentId: activeTask.id
                    );
                  },
                  child: WillPopScope(
                    onWillPop: () async {
                      final selectedTaskCubit = BlocProvider.of<SelectedTaskCubit>(context);
                      if (selectedTaskCubit.state?.parentId != null) {
                        selectedTaskCubit.select(
                          await TasksProvider.instance.getOne(selectedTaskCubit.state!.parentId!)
                        );
                        await BlocProvider.of<TasksCubit>(context).load(
                          BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                          parentId: selectedTaskCubit.state?.id
                        );
                      } else {
                        await BlocProvider.of<TasksCubit>(context).load(
                          BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                        );
                      }
                      return true;
                    },
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: buildAppBar(
                        context,
                        title: Text(
                          activeTask!.name,
                          style: Theme.of(context).textTheme.subtitle1
                        ),
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
                      body: Background(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: kAppBarHeight + ScreenSize.height(context, 3)
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: ScreenSize.height(context, 3),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (tasks.isEmpty) 
                                          if (settingsState.useCheckBox)
                                            Checkbox(
                                              activeColor: Theme.of(context).primaryColor,
                                              shape: CircleBorder(
                                                side: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color!)
                                              ),
                                              value: activeTask.progress == 100, 
                                              onChanged: (bool? value) async {
                                                final TasksProvider _tasksProvider = TasksProvider.instance;
                                                if (value != null && value) {
                                                  final withProgress = activeTask.copyWith(
                                                  progress: 100
                                                  );
                                                  BlocProvider.of<SelectedTaskCubit>(context)
                                                  .select(withProgress);
                                                  await _tasksProvider.updateProgress(
                                                    activeTask.id!, 
                                                    100
                                                  );
                                                }
                                                else {
                                                  final withProgress = activeTask.copyWith(
                                                  progress: 0
                                                  );
                                                  BlocProvider.of<SelectedTaskCubit>(context)
                                                  .select(withProgress);
                                                  await _tasksProvider.updateProgress(
                                                    activeTask.id!, 
                                                    0
                                                  );
                                                }
                                                if (activeTask.parentId != null) {
                                                  await _tasksProvider.recalculateProgressFor(
                                                    await _tasksProvider.getOne(activeTask.parentId!)
                                                  );
                                                } else {
                                                  await ProjectsProvider.instance.recalculateProgressFor(
                                                    activeTask.projectId
                                                  );
                                                }
                                                final project = await ProjectsProvider.instance.getOne(activeTask.projectId);
                                                BlocProvider.of<SelectedProjectCubit>(context).select(project);
                                                await BlocProvider.of<ProjectsCubit>(context).load();
                                              }
                                            )
                                          else
                                            ...[ 
                                              Slider(
                                                onChangeEnd: (double value) async {
                                                  final TasksProvider _tasksProvider = TasksProvider.instance;
                                                  await _tasksProvider.updateProgress(
                                                    activeTask.id!, 
                                                    (value* 100).toInt()
                                                  );
                                                  if (activeTask.parentId != null) {
                                                    await _tasksProvider.recalculateProgressFor(
                                                      await _tasksProvider.getOne(activeTask.parentId!)
                                                    );
                                                  } else {
                                                    await ProjectsProvider.instance.recalculateProgressFor(
                                                      activeTask.projectId
                                                    );
                                                  }
                                                  final project = await ProjectsProvider.instance.getOne(activeTask.projectId);
                                                  BlocProvider.of<SelectedProjectCubit>(context).select(project);
                                                  await BlocProvider.of<ProjectsCubit>(context).load();
                                                },
                                                onChanged: (double value) async {
                                                  final withProgress = activeTask.copyWith(
                                                    progress: (value* 100).toInt()
                                                  );
                                                  BlocProvider.of<SelectedTaskCubit>(context)
                                                  .select(withProgress);
                                                },
                                                value: activeTask.progress / 100,
                                              ),
                                              SizedBox(width: ScreenSize.width(context, 2)),
                                              Text(
                                                activeTask.progress.toString() + "%",
                                                style: Theme.of(context).textTheme.bodyText1
                                              )
                                            ]
                                      ],
                                    ),
                                  )
                                ]
                              ),
                            ),
                            if(activeTask.startDate != null && activeTask.endDate != null) 
                              ...[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.start + ": ",
                                          style: Theme.of(context).textTheme.bodyText2
                                        ),
                                        TextSpan(
                                          text: dateFormat.format(activeTask.startDate!),
                                          style: Theme.of(context).textTheme.bodyText1
                                        ),
                                      ]
                                    )
                                  ),
                                ),
                                SizedBox(height: ScreenSize.height(context, 1)),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!.end + ": ",
                                          style: Theme.of(context).textTheme.bodyText2
                                        ),
                                        TextSpan(
                                          text: dateFormat.format(activeTask.endDate!),
                                          style: Theme.of(context).textTheme.bodyText1
                                        ),
                                      ]
                                    )
                                  ),
                                ),
                                SizedBox(height: ScreenSize.height(context, 1))
                              ]
                            else
                              Text(
                                AppLocalizations.of(context)!.timeToExecute + ": " +
                                AppLocalizations.of(context)!.indefinite.toLowerCase(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            /*
                            * DESCRIPTION 
                            */
                            if (activeTask.description != null && activeTask.description!.isNotEmpty)
                              ExpandablePanel(
                                theme: ExpandableThemeData(
                                  iconColor: Theme.of(context).textTheme.bodyText2!.color,
                                  iconPadding: const EdgeInsets.all(0)
                                ),
                                header: Text(
                                  AppLocalizations.of(context)!.description,
                                  style: Theme.of(context).textTheme.bodyText2
                                ),
                                collapsed: Text(
                                  activeTask.description!,
                                  style: Theme.of(context).textTheme.bodyText1!
                                  .copyWith(fontStyle: FontStyle.italic)
                                  ,
                                  softWrap: true, 
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis
                                ),
                                expanded: Text(
                                  activeTask.description!, 
                                  style: Theme.of(context).textTheme.bodyText1!
                                  .copyWith(fontStyle: FontStyle.italic),
                                  softWrap: true
                                ),
                              ),
                              const Divider(),
                              /*
                              * TASKS LIST
                              */
                            if (tasks.isNotEmpty)
                              Expanded(
                                child: ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) => TaskContainer(tasks[index])
                                ),
                              )
                            else
                              Expanded(
                                child: SizedBox(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noTasks,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    )
                                  ),
                                ),
                              )
                          ]
                        )
                      ),
                      /*
                      * ADD NEW TASK BUTTON
                      */
                      floatingActionButton: FloatingActionButton(
                        child: const Icon(
                          Icons.add, 
                          size: 30, 
                          color: kButtonTextColor
                        ),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => AddTaskPage(task: activeTask)
                            )
                          );
                        }
                      )
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
}