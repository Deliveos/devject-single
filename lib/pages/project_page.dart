import 'dart:io';
import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/add_task_page.dart';
import 'package:devject_single/pages/edit_project_page.dart';
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

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  static const routeName = "ProjectPage";

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMd(Platform.localeName);
    return BlocBuilder<SelectedProjectCubit, Project?>(
      builder: (context, project) {
        return RefreshIndicator(
          onRefresh: () async {
            await BlocProvider.of<TasksCubit>(context).load(
              project!.id!
            );
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(
              context,
              title: Text(
                project!.name,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).primaryColor
                )
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProjectPage(project)
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
                  SizedBox(height: kAppBarHeight + ScreenSize.height(context, 3),),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
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
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: LinearProgressIndicator(
                                      minHeight: 10,
                                      value: project.progress.toDouble() / 100,
                                      backgroundColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.5),
                                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ScreenSize.width(context, 2)),
                                Text(
                                  project.progress.toString() + "%",
                                  style: Theme.of(context).textTheme.bodyText1
                                )
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                  if(project.startDate != null && project.endDate != null) 
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
                                text: dateFormat.format(project.startDate!),
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
                                text: dateFormat.format(project.endDate!),
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
                  if (project.description != null && project.description!.isNotEmpty)
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
                        project.description!,
                        style: Theme.of(context).textTheme.bodyText1!
                        .copyWith(fontStyle: FontStyle.italic)
                        ,
                        softWrap: true, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis
                      ),
                      expanded: Text(
                        project.description!, 
                        style: Theme.of(context).textTheme.bodyText1!
                        .copyWith(fontStyle: FontStyle.italic),
                        softWrap: true
                      ),
                    ),
                    const Divider(),
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
                    )
                ],
              ),
            ),
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
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<SelectedProjectCubit>(context),
                      child: const AddTaskPage(),
                    )
                  )
                );
              }
            )
          ),
        );
      },
    );
  }
}