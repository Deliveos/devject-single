import 'package:devject_single/widgets/main_bottom_nav_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/sizes.dart';
import '../cubit/selected_project_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../pages/add_task_page.dart';
import '../pages/edit_project_page.dart';
import '../widgets/project_info_card.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/task_container.dart';


class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  static const routeName = "ProjectPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedProjectCubit, Project?>(
      builder: (context, project) {
        return RefreshIndicator(
          onRefresh: () async {
            await BlocProvider.of<TasksCubit>(context).load(
              project!.id!
            );
          },
          child: Scaffold(
            appBar: buildAppBar(
              context,
              title: project!.name,
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
            body: buildBody(context),
            bottomNavigationBar: const MainBottomNavBar(),
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    final project = BlocProvider.of<SelectedProjectCubit>(context).state!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ProjectInfoCard(project: project),
        SizedBox(width: ScreenSize.width(context, 5)),
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
}