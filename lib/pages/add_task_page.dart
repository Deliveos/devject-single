import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/utils/pick_date_range.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/button.dart';
import 'package:devject_single/widgets/input_field.dart';
import 'package:devject_single/widgets/input_text_editing_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key, this.task}) : super(key: key);

  static const String routeName = "AddTaskPage";
  final Task? task;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final InputTextEditingController _nameController = InputTextEditingController();
  final InputTextEditingController _goalController = InputTextEditingController();
  final InputTextEditingController _startDateController = InputTextEditingController();
  final InputTextEditingController _endDateController = InputTextEditingController();
  final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
  DateTimeRange? dateTimeRange;
  int selectedPriority = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: AppLocalizations.of(context)!.newTask,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              width: ScreenSize.width(context, 100),
              height: ScreenSize.height(context, 70),
              child: Center(
                child: Container(
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
                    children: <Widget>[
                      /*
                      * NAME FIELD
                      */
                      InputField(
                        controller: _nameController,
                        hintText: AppLocalizations.of(context)!.taskName,
                        validator: (String? value) {
                          if (value == null || value.isEmpty || value.trim() == "") {
                            return AppLocalizations.of(context)!.fieldCanNotBeEmpty;
                          }
                        }
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 2),
                      ),
                      /*
                      * GOAL FIELD
                      */
                      InputField(
                        controller: _goalController,
                        minLines: 1,
                        maxLines: 8,
                        hintText: AppLocalizations.of(context)!.goal
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 2),
                      ),
                      /*
                      * PRIORITY BUTTONS
                      */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: kLowPriorityColor,
                                visualDensity: VisualDensity.compact,
                                value: 0, 
                                groupValue: selectedPriority, 
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedPriority = value!;
                                  });
                                }
                              ),
                              const Icon(
                                FluentIcons.flag_24_filled,
                                color: kLowPriorityColor,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: kMediumPriorityColor,
                                visualDensity: VisualDensity.compact,
                                value: 1, 
                                groupValue: selectedPriority, 
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedPriority = value!;
                                  });
                                }
                              ),
                              const Icon(
                                FluentIcons.flag_24_filled,
                                color: kMediumPriorityColor,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: kHighPriorityColor,
                                visualDensity: VisualDensity.compact,
                                value: 2, 
                                groupValue: selectedPriority, 
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedPriority = value!;
                                  });
                                }
                              ),
                              const Icon(
                                FluentIcons.flag_24_filled,
                                color: kHighPriorityColor,
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 2),
                      ),
                      /*
                      * DATES FIELDS
                      */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          InputField(
                            readOnly: true,
                            width: ScreenSize.width(context, 35),
                            controller: _startDateController,
                            hintText: AppLocalizations.of(context)!.startDate,
                            onTap: () async {
                              await pickDateRangeForNewTask(context);
                            }
                          ),
                          const Icon(FluentIcons.timer_20_regular),
                          InputField(
                            readOnly: true,
                            width: ScreenSize.width(context, 35),
                            controller: _endDateController,
                            hintText: AppLocalizations.of(context)!.endDate,
                            onTap: () async {
                              await pickDateRangeForNewTask(context);
                            }
                          ),
                        ]
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 3),
                      ),
                      PrimaryButton(
                        onTap: () => addTask(context),
                        child: Text(
                          AppLocalizations.of(context)!.create.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ]))
      ]
    );
  }

  Future addTask(BuildContext context) async {
    final selectedProjectCubit = context.read<SelectedProjectCubit>();
    final selectedTaskCubit = context.read<SelectedTaskCubit>();
    if (_nameController.isValid) {
      Task task = Task(
        name: _nameController.text.trim(), 
        goal: _goalController.text.trim(),
        projectId: selectedProjectCubit.state!.id!,
        parentId: selectedTaskCubit.state.id,
        startDate: dateTimeRange?.start,
        priority: selectedPriority,
        status: 0,
        endDate: dateTimeRange?.end
      );
      // Add new task to database
      await BlocProvider.of<TasksCubit>(context).add(task);
      if (selectedTaskCubit.state.id == null) {
        // Update taskCount for selected project
        await context.read<ProjectsCubit>().update(
          selectedProjectCubit.state!.copyWith(
            tasksCount: selectedProjectCubit.state!.tasksCount + 1
          )
        );
        // // update
        // await TasksProvider.instance.recalculateComplitedSubtasksCountFor(
        //   selectedTaskCubit.state
        // );
      } else {
        // Update subtasksCount for selected task
        final updatedSelectedTask = selectedTaskCubit.state.copyWith(
          isComplited: false,
          subtaskCount: selectedTaskCubit.state.subtasksCount + 1
        );
        await context.read<TasksCubit>().update(
          updatedSelectedTask,
          updatedSelectedTask.id
        );
        selectedTaskCubit.select(
          updatedSelectedTask
        );
        // await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
        //   selectedProjectCubit.state!.id!
        // );
      }
      await context.read<TasksCubit>().load(
        selectedProjectCubit.state!.id!,
        id: selectedTaskCubit.state.id
      );
      final project = await ProjectsProvider.instance.getOne(
        selectedProjectCubit.state!.id!
      );
      selectedProjectCubit.select(project);
      await BlocProvider.of<ProjectsCubit>(context).load();
      Navigator.pop(context);
    }
  }

  Future pickDateRangeForNewTask(BuildContext context) async {
    await pickDateRange(
      context,
      firstDate: BlocProvider.of<SelectedTaskCubit>(context).state.startDate ??
        BlocProvider.of<SelectedProjectCubit>(context).state!.startDate!,
      lastDate: BlocProvider.of<SelectedTaskCubit>(context).state.endDate ??
        BlocProvider.of<SelectedProjectCubit>(context).state!.endDate!,
      callback: (DateTimeRange? dateRange) {
        if (dateRange == null) return;
        setState(() {
          dateTimeRange = dateRange;
          _startDateController.text = dateFormat.format(dateTimeRange!.start);
          _endDateController.text = dateFormat.format(dateTimeRange!.end);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              dateFormat.format(dateTimeRange!.start) +
              " - " +
              dateFormat.format(dateTimeRange!.end),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            duration: const Duration(milliseconds: 2000)
          )
        );
      }
    );
  }

  // Future pickDateRange(BuildContext context) async {
  //   final newDateRange = await showDateRangePicker(
  //     cancelText: AppLocalizations.of(context)!.done,
  //     builder: (context, Widget? child) => Theme(
  //       data: Theme.of(context).copyWith(
  //         appBarTheme: Theme.of(context).appBarTheme.copyWith(
  //           backgroundColor: Theme.of(context).backgroundColor,
  //           iconTheme: Theme.of(context)
  //           .appBarTheme
  //           .iconTheme!
  //           .copyWith(color: Colors.white)
  //         ),
  //       ),
  //       child: child!,
  //     ),
  //     context: context,
  //     firstDate: BlocProvider.of<SelectedTaskCubit>(context).state?.startDate ??
  //     BlocProvider.of<SelectedProjectCubit>(context).state!.startDate!,
  //     lastDate: BlocProvider.of<SelectedTaskCubit>(context).state?.endDate ??
  //     BlocProvider.of<SelectedProjectCubit>(context).state!.endDate!
  //   );
  //   if (newDateRange == null) return;
  //   setState(() {
  //     dateTimeRange = newDateRange;
  //     _startDateController.text = dateFormat.format(dateTimeRange!.start);
  //     _endDateController.text = dateFormat.format(dateTimeRange!.end);
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       dateFormat.format(dateTimeRange!.start) +
  //           " - " +
  //           dateFormat.format(dateTimeRange!.end),
  //       style: Theme.of(context).textTheme.bodyText1,
  //     ),
  //     backgroundColor: Theme.of(context).backgroundColor,
  //     duration: const Duration(milliseconds: 2000)
  //   ));
  // }
}
