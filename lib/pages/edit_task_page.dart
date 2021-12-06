import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/selected_project_cubit.dart';
import '../cubit/selected_task_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../models/task.dart';
import '../providers/projects_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/pick_date_range.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import '../widgets/input_text_editing_controller.dart';


class EditTaskPage extends StatefulWidget {
  const EditTaskPage(this.task, {Key? key}) : super(key: key);

  final Task task;

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final InputTextEditingController _nameController = InputTextEditingController();
  final InputTextEditingController _descriptionController = InputTextEditingController();
  final InputTextEditingController _startDateController = InputTextEditingController();
  final InputTextEditingController _endDateController = InputTextEditingController();
  final DateFormat dateFormat = DateFormat.yMMMd(Platform.localeName);
  DateTimeRange? dateTimeRange;
  int selectedPriority = 0;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.task.name;
    if (widget.task.goal != null) {
      _descriptionController.text = widget.task.goal!;
    }
    if (widget.task.startDate != null && widget.task.endDate != null) {
      dateTimeRange = DateTimeRange(start: widget.task.startDate!, end: widget.task.endDate!);
      _startDateController.text = dateFormat.format(widget.task.startDate!);
      _endDateController.text = dateFormat.format(widget.task.endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: AppLocalizations.of(context)!.editTask,
        actions: [
          PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: const EdgeInsets.only(left: 5),
                onTap: () {
                  showBottomSheet(
                    context: context, builder: showDeleteTaskDialog
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      FluentIcons.delete_24_regular,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 3),
                    Text(AppLocalizations.of(context)!.delete, )
                  ]
                )
              )
            ]
          )
        ]
      ),
      body: CustomScrollView(
        slivers: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InputField(
                          controller: _nameController,
                          hintText: AppLocalizations.of(context)!.projectName,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || value.trim() == "") {
                              return AppLocalizations.of(context)!
                              .fieldCanNotBeEmpty;
                            }
                          }
                        ),
                        SizedBox(
                          height: ScreenSize.height(context, 3),
                        ),
                        /*
                        * DESCRIPTON FIELD
                        */
                        InputField(
                          controller: _descriptionController,
                          minLines: 1,
                          maxLines: 8,
                          hintText: AppLocalizations.of(context)!.description
                        ),
                        SizedBox(
                          height: ScreenSize.height(context, 3),
                        ),
                        /*
                        * PRIORITY 
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
                                hintText: AppLocalizations.of(context)!
                                    .startDate,
                                onTap: () async {
                                  await pickDateRangeForTask(context);
                                }
                              ),
                              Text("-",
                                style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                              ),
                              InputField(
                                readOnly: true,
                                width: ScreenSize.width(context, 35),
                                controller: _endDateController,
                                hintText: AppLocalizations.of(context)!
                                    .endDate,
                                onTap: () async {
                                  await pickDateRangeForTask(context);
                                }
                              ),
                            ]),
                        SizedBox(
                          height: ScreenSize.height(context, 3),
                        ),
                        /*
                        * SAVE TASK BUTTON
                        */
                        PrimaryButton(
                          onTap: () async {
                            if (_nameController.text.trim() != '') {
                              Task task = Task(
                                id: widget.task.id,
                                name: _nameController.text.trim(),
                                goal: _descriptionController.text.trim().isNotEmpty
                                ? _descriptionController.text.trim()
                                : null,
                                startDate: dateTimeRange?.start,
                                endDate: dateTimeRange?.end,
                                priority: selectedPriority,
                                projectId: widget.task.projectId,
                                parentId: widget.task.parentId
                              );
                              await BlocProvider.of<TasksCubit>(context).update(
                                task,
                                task.id
                              );
                              BlocProvider.of<SelectedTaskCubit>(context).select(task);
                              await BlocProvider.of<TasksCubit>(context).load(
                                BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                                id: BlocProvider.of<SelectedTaskCubit>(context).state.id
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.create.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: kButtonTextColor
                            )
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30, 
                            vertical: 5
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height(context, 3),
                        )
                      ]
                    ),
                  )
                ),
              )
            ])
          )
        ]
      )
    );
  }

  Future pickDateRangeForTask(BuildContext context) async {
    Task? parent;
    if (BlocProvider.of<SelectedTaskCubit>(context).state.parentId != null) {
      parent = await TasksProvider.instance.getOne(
        BlocProvider.of<SelectedTaskCubit>(context).state.parentId!
      );
    }
    await pickDateRange(
      context,
      firstDate: 
        BlocProvider.of<SelectedTaskCubit>(context).state.startDate ??
        parent?.startDate ??
        BlocProvider.of<SelectedProjectCubit>(context).state!.startDate ??
        DateTime.now(),
      lastDate: BlocProvider.of<SelectedTaskCubit>(context).state.endDate ??
        parent?.endDate ??
        BlocProvider.of<SelectedProjectCubit>(context).state!.endDate ??
        DateTime(DateTime.now().year + 10),
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

    Widget showDeleteTaskDialog(BuildContext context) {
    final InputTextEditingController _controller = InputTextEditingController();
    return Container(
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
      padding: EdgeInsets.all(ScreenSize.width(context, 5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.enter + " ",
                  style: Theme.of(context).textTheme.bodyText1
                ),
                TextSpan(
                  text: BlocProvider.of<SelectedTaskCubit>(context).state.name,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red)
                ),
                TextSpan(
                  text: " " + AppLocalizations.of(context)!.toDeleteThisTask,
                  style: Theme.of(context).textTheme.bodyText1
                ),
              ]
            )
          ),
          /*
          * TASK NAME 
          */
          InputField(
            controller: _controller,
            hintText: AppLocalizations.of(context)!.taskName,
          ),
          SizedBox(
            height: ScreenSize.height(context, 3),
          ),
          InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () async {
            if (_controller.text.trim() == BlocProvider.of<SelectedTaskCubit>(context).state.name) {
              final selectedTaskCubit = context.read<SelectedTaskCubit>();
              final selectedProjectCubit = context.read<SelectedProjectCubit>();
              final tasksProvider = TasksProvider.instance;
              if (selectedTaskCubit.state.parentId != null) {
                final parent = await tasksProvider.getOne(selectedTaskCubit.state.parentId!);
                await context.read<TasksCubit>().update(
                  parent.copyWith(
                    subtasksCount: parent.subtasksCount - 1,
                    complitedSubaskCount: selectedTaskCubit.state.isComplited 
                    ? parent.complitedSubaskCount - 1
                    : parent.complitedSubaskCount
                  ),
                  parent.id
                );
              } else {
                await context.read<ProjectsCubit>().update(
                  selectedProjectCubit.state!.copyWith(
                    tasksCount: selectedProjectCubit.state!.tasksCount - 1,
                    complitedTaskCount: selectedTaskCubit.state.isComplited 
                    ? selectedProjectCubit.state!.complitedTaskCount - 1
                    : selectedProjectCubit.state!.complitedTaskCount
                  )
                );
              }
              await tasksProvider.remove(BlocProvider.of<SelectedTaskCubit>(context).state.id!);
              if (selectedTaskCubit.state.parentId != null) {
                selectedTaskCubit.select(
                  await tasksProvider.getOne(selectedTaskCubit.state.parentId!)
                );
                await BlocProvider.of<TasksCubit>(context).load(
                  BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                  id: selectedTaskCubit.state.id
                );
              } else {
                await BlocProvider.of<TasksCubit>(context).load(
                  BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                );
              }
              if (selectedTaskCubit.state.parentId != null) {
                context.read<TasksCubit>().update(
                  selectedTaskCubit.state.copyWith(
                    subtasksCount: selectedTaskCubit.state.subtasksCount - 1
                  ),
                  selectedTaskCubit.state.id
                );
                await tasksProvider.recalculateComplitedSubtasksCountFor(
                  await tasksProvider.getOne(selectedTaskCubit.state.parentId!)
                );
              } else {
                await ProjectsProvider.instance.recalculateComplitedTasksCountFor(
                  BlocProvider.of<SelectedProjectCubit>(context).state!.id!
                );
              }
              await BlocProvider.of<SelectedProjectCubit>(context).select(
                await ProjectsProvider.instance.getOne(
                  selectedTaskCubit.state.projectId
                )
              );
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Container(
            height: 50,
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
              color: Colors.transparent,
              border: Border.all(
                color: Colors.red,
                width: 1
              )
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.delete.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
              )
            ),
          )
        ),
        ]
      ),
    );
  }
}
