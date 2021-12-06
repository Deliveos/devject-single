import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../cubit/projects_cubit.dart';
import '../models/project.dart';
import '../utils/pick_date_range.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import '../widgets/input_text_editing_controller.dart';


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
      appBar: buildAppBar(
        context,
        title: AppLocalizations.of(context)!.newProject,
      ),
      body: buildBody(context) 
    );
  }

  Widget buildBody(BuildContext context) {
    return CustomScrollView(
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
                                    width: ScreenSize.width(context, 35),
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
                                    width: ScreenSize.width(context, 35),
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
                                  if (
                                    _nameController.isValid 
                                  ) {
                                    Project project = Project(
                                      name: _nameController.text.trim(),
                                      description: _description.text.trim(),
                                      startDate: dateTimeRange?.start,
                                      endDate: dateTimeRange?.end
                                    );
                                    await BlocProvider.of<ProjectsCubit>(context).add(project);
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
                    ),
                  )
                ),
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