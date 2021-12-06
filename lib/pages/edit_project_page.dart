import 'dart:io';
import 'package:devject_single/constants/sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/selected_project_cubit.dart';
import '../models/project.dart';
import '../pages/projects_page.dart';
import '../providers/projects_provider.dart';
import '../utils/pick_date_range.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import '../widgets/input_text_editing_controller.dart';


class EditProjectPage extends StatefulWidget {
  const EditProjectPage(this.project, {Key? key}) : super(key: key);

  final Project project;

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final InputTextEditingController _nameController = InputTextEditingController();
  final InputTextEditingController _descriptionController = InputTextEditingController();
  final InputTextEditingController _startDateController = InputTextEditingController();
  final InputTextEditingController _endDateController = InputTextEditingController();
  final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
  DateTimeRange? dateTimeRange;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.project.name;
    if (widget.project.description != null) {
      _descriptionController.text = widget.project.description!;
    }
    if (widget.project.startDate != null && widget.project.endDate != null) {
      dateTimeRange = DateTimeRange(start: widget.project.startDate!, end: widget.project.endDate!);
      _startDateController.text = dateFormat.format(widget.project.startDate!);
      _endDateController.text = dateFormat.format(widget.project.endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(
        context,
        title: AppLocalizations.of(context)!.editProject,
        actions: [
          PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: const EdgeInsets.only(left: 5),
                onTap: () {
                  showBottomSheet(
                    context: context, builder: showDeleteProjectDialog
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
                height: ScreenSize.height(context, 100),
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
                                await pickDateRangeForProject(context);
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
                              width: ScreenSize.width(context, 35),
                              controller: _endDateController,
                              hintText: AppLocalizations.of(context)!
                              .endDate,
                              onTap: () async {
                                await pickDateRangeForProject(context);
                              }
                            ),
                          ]
                        ),
                        SizedBox(
                          height: ScreenSize.height(context, 3),
                        ),
                        /*
                        * SAVE PROJECT BUTTON
                        */
                        PrimaryButton(
                          onTap: () async {
                            if (_nameController.text.trim() != '') {
                              Project project = Project(
                                id: widget.project.id,
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim().isNotEmpty 
                                ? _descriptionController.text.trim()
                                : null,
                                startDate: dateTimeRange?.start,
                                endDate: dateTimeRange?.end
                              );
                              await BlocProvider.of<ProjectsCubit>(context).update(project);
                              BlocProvider.of<SelectedProjectCubit>(context).select(project);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: kButtonTextColor
                            )
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30, 
                            vertical: 5
                          )
                        ),
                        SizedBox(height: ScreenSize.height(context, 3))
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

  Future pickDateRangeForProject(BuildContext context) async {
    await pickDateRange(
      context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
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

  Widget showDeleteProjectDialog(BuildContext context) {
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
                  text: BlocProvider.of<SelectedProjectCubit>(context).state!.name,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.red)
                ),
                TextSpan(
                  text: " " + AppLocalizations.of(context)!.toDeleteThisProject,
                  style: Theme.of(context).textTheme.bodyText1
                )
              ]
            )
          ),
          InputField(
            controller: _controller,
            hintText: AppLocalizations.of(context)!.projectName,
          ),
          SizedBox(
            height: ScreenSize.height(context, 3),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(kCardBorderRadius),
            onTap: () async {
              if (
                _controller.text.trim() == BlocProvider.of<SelectedProjectCubit>(context).state!.name
              ) {
                await ProjectsProvider.instance.remove(BlocProvider.of<SelectedProjectCubit>(context).state!.id!);
                await BlocProvider.of<ProjectsCubit>(context).load();
                Navigator.of(context).pushNamedAndRemoveUntil(ProjectsPage.routeName, (route) => false);
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
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
      )
    );
  }
}
