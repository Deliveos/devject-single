import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/models/project.dart';
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

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  static const String routeName = "AddProjectPage";

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
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
          AppLocalizations.of(context)!.newProject,
          style: Theme.of(context).textTheme.subtitle1,
        )
      ),
      body: buildBody(context) 
    );
  }

  Widget buildBody(BuildContext context) {
    return CustomScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                InputField(
                                  readOnly: true,
                                  width: ScreenSize.width(context, 40),
                                  controller: _startDateController,
                                  hintText: AppLocalizations.of(context)!
                                  .startDate,
                                  onTap: () async {
                                    await pickDateRangeForNewProject(context);
                                  }
                                ),
                                Text(
                                  "-",
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                                InputField(
                                  readOnly: true,
                                  width: ScreenSize.width(context, 40),
                                  controller: _endDateController,
                                  hintText: AppLocalizations.of(context)!
                                  .endDate,
                                  onTap: () async {
                                    await pickDateRangeForNewProject(context);
                                  }
                                )
                              ]
                            ),
                            SizedBox(
                              height: ScreenSize.height(context, 3),
                            ),
                            /*
                            * CREATE NEW PROJECT BUTTON
                            */
                            PrimaryButton(
                              onTap: () async {
                                if (_nameController.isValid) {
                                  Project project = Project(
                                    name: _nameController.text.trim(),
                                    description: _description.text.trim(),
                                    startDate: dateTimeRange?.start,
                                    endDate: dateTimeRange?.end
                                  );
                                  BlocProvider.of<ProjectsCubit>(context).add(project);
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
                              )
                            )
                          ]
                        )
                      ),
                      SizedBox(
                        height: ScreenSize.height(context, 3)
                      )
                    ]
                  )
                )
              )
            ])
          )
        ]
      );
  }

  Future pickDateRangeForNewProject(BuildContext context) async {
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
}