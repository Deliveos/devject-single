import 'dart:io';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/utils/pick_date_range.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/background.dart';
import 'package:devject_single/widgets/button.dart';
import 'package:devject_single/widgets/input_field.dart';
import 'package:devject_single/widgets/input_text_editing_controller.dart';
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
  final InputTextEditingController _description = InputTextEditingController();
  final InputTextEditingController _startDateController = InputTextEditingController();
  final InputTextEditingController _endDateController = InputTextEditingController();
  final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
  DateTimeRange? dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(
        context,
        title: Text(
          AppLocalizations.of(context)!.newTask,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Background(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                controller: _description,
                                minLines: 1,
                                maxLines: 8,
                                hintText: AppLocalizations.of(context)!
                                    .description),
                            SizedBox(
                              height: ScreenSize.height(context, 3),
                            ),
                            /*
                            * DATES FIELDS
                            */
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                InputField(
                                  readOnly: true,
                                  width: ScreenSize.width(context, 40),
                                  controller: _startDateController,
                                  hintText: AppLocalizations.of(context)!
                                  .startDate,
                                  onTap: () async {
                                    await pickDateRangeForNewTask(context);
                                  }
                                ),
                                Text(
                                  "-",
                                  style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                ),
                                InputField(
                                  readOnly: true,
                                  width: ScreenSize.width(context, 40),
                                  controller: _endDateController,
                                  hintText: AppLocalizations.of(context)!
                                      .endDate,
                                  onTap: () async {
                                    await pickDateRangeForNewTask(context);
                                  }
                                ),
                                ]
                            ),
                            SizedBox(
                              height: ScreenSize.height(context, 3),
                            ),
                            /*
                            * CREATE NEW TASK BUTTON
                            */
                            PrimaryButton(
                              onTap: () async {
                                if (_nameController.isValid) {
                                  Task task = Task(
                                    name: _nameController.text.trim(), 
                                    description: _description.text.trim(),
                                    projectId: BlocProvider.of<SelectedProjectCubit>(context).state!.id!,
                                    parentId: widget.task?.id,
                                    startDate: dateTimeRange?.start,
                                    endDate: dateTimeRange?.end
                                  );
                                  await BlocProvider.of<TasksCubit>(context).add(task);
                                  if (task.parentId != null) {
                                    await TasksProvider.instance.recalculateProgressFor(
                                      await TasksProvider.instance.getOne(task.parentId!)
                                    );
                                  } else {
                                    await ProjectsProvider.instance.recalculateProgressFor(
                                      task.projectId
                                    );
                                  }
                                  final project = await ProjectsProvider.instance.getOne(task.projectId);
                                  BlocProvider.of<SelectedProjectCubit>(context).select(project);
                                  await BlocProvider.of<ProjectsCubit>(context).load();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.create.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyText1
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30, 
                                vertical: 5
                              ),
                            )
                          ]
                        )
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 3),
                      )
                    ]
                  )
                )
              )
            ])
          )
        ]
      )
    );
  }

    Future pickDateRangeForNewTask(BuildContext context) async {
    await pickDateRange(
      context,
      firstDate: BlocProvider.of<SelectedTaskCubit>(context).state?.startDate ??
        BlocProvider.of<SelectedProjectCubit>(context).state!.startDate!,
      lastDate: BlocProvider.of<SelectedTaskCubit>(context).state?.endDate ??
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
