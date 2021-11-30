import 'dart:io';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/providers/tasks_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/background.dart';
import 'package:devject_single/widgets/button.dart';
import 'package:devject_single/widgets/input_field.dart';
import 'package:devject_single/widgets/input_text_editing_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';


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
  final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
  DateTimeRange? dateTimeRange;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.task.name;
    if (widget.task.description != null) {
      _descriptionController.text = widget.task.description!;
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
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(
        context,
        title: Text(
        AppLocalizations.of(context)!.editTask,
        style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).backgroundColor.withOpacity(0.5),
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
                                        await pickDateRange(context);
                                      }),
                                  Text("-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  InputField(
                                    readOnly: true,
                                    width: ScreenSize.width(context, 40),
                                    controller: _endDateController,
                                    hintText: AppLocalizations.of(context)!
                                        .endDate,
                                    onTap: () async {
                                      await pickDateRange(context);
                                    }
                                  ),
                                ]),
                            SizedBox(
                              height: ScreenSize.height(context, 3),
                            ),
                            /*
                            * CREATE NEW PROJECT BUTTON
                            */
                            PrimaryButton(
                              onTap: () async {
                                if (_nameController.text.trim() != '') {
                                  Task task = Task(
                                    id: widget.task.id,
                                    name: _nameController.text.trim(),
                                    description: _descriptionController.text.trim().isNotEmpty
                                    ? _descriptionController.text.trim()
                                    : null,
                                    projectId: widget.task.projectId,
                                    parentId: widget.task.parentId
                                  );
                                  await BlocProvider.of<TasksCubit>(context).update(task);
                                  BlocProvider.of<SelectedTaskCubit>(context).select(task);
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

  Future pickDateRange(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
        cancelText: AppLocalizations.of(context)!.done,
        builder: (context, Widget? child) => Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: Theme.of(context).backgroundColor,
              iconTheme: Theme.of(context)
              .appBarTheme
              .iconTheme!
              .copyWith(color: Colors.white)
            ),
          ),
          child: child!,
        ),
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 10));
    if (newDateRange == null) return;
    setState(() {
      dateTimeRange = newDateRange;
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

    Widget showDeleteTaskDialog(BuildContext context) {
    final InputTextEditingController _controller = InputTextEditingController();
    return Container(
      padding: EdgeInsets.all(ScreenSize.width(context, 3)),
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
                  text: BlocProvider.of<SelectedTaskCubit>(context).state!.name,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red)
                ),
                TextSpan(
                  text: " " + AppLocalizations.of(context)!.toDeleteThisTask,
                  style: Theme.of(context).textTheme.bodyText1
                ),
              ]
            )
          ),
          InputField(
            controller: _controller,
          ),
          SizedBox(
            height: ScreenSize.height(context, 3),
          ),
          InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () async {
            if (_controller.text.trim() == BlocProvider.of<SelectedTaskCubit>(context).state!.name) {
              final TasksProvider _tasksProvider = TasksProvider.instance;
              await _tasksProvider.remove(BlocProvider.of<SelectedTaskCubit>(context).state!.id!);
              final selectedTaskCubit = BlocProvider.of<SelectedTaskCubit>(context);
              if (selectedTaskCubit.state?.parentId != null) {
                selectedTaskCubit.select(
                  await _tasksProvider.getOne(selectedTaskCubit.state!.parentId!)
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
              if (selectedTaskCubit.state?.parentId != null) {
                await _tasksProvider.recalculateProgressFor(
                  await _tasksProvider.getOne(selectedTaskCubit.state!.parentId!)
                );
              } else {
                await ProjectsProvider.instance.recalculateProgressFor(
                  BlocProvider.of<SelectedProjectCubit>(context).state!.id!
                );
              }
              await BlocProvider.of<SelectedProjectCubit>(context).select(
                await ProjectsProvider.instance.getOne(
                  BlocProvider.of<SelectedProjectCubit>(context).state!.id!
                )
              );
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.transparent,
              border: Border(
                top: BorderSide(color: Colors.red, width: 1),
                left: BorderSide(color: Colors.red, width: 1),
                right: BorderSide(color: Colors.red, width: 1),
                bottom: BorderSide(color: Colors.red, width: 1)
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
