import 'package:devject_single/constants/sizes.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/models/task.dart';
import 'package:devject_single/pages/add_task_page.dart';
import 'package:devject_single/pages/edit_project_page.dart';
import 'package:devject_single/pages/main_page.dart';
import 'package:devject_single/widgets/project_info_card.dart';
import 'package:devject_single/providers/projects_provider.dart';
import 'package:devject_single/utils/screen_size.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/input_field.dart';
import 'package:devject_single/widgets/input_text_editing_controller.dart';
import 'package:devject_single/widgets/task_container.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    showDeleteProjectDialog(BuildContext context) async {
    final InputTextEditingController _controller = InputTextEditingController();
    return await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(" asd"),
        content: Column(
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
          ),
        ]
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              if (_controller.text.trim() == BlocProvider.of<SelectedProjectCubit>(context).state!.name) {
                await ProjectsProvider.instance.remove(BlocProvider.of<SelectedProjectCubit>(context).state!.id!);
                await BlocProvider.of<ProjectsCubit>(context).load();
                Navigator.of(context).pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
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
        ],
      )
    );
    // return Container(
    //   margin: EdgeInsets.only(
    //     top: ScreenSize.height(context, 5)
    //   ),
    //   padding: EdgeInsets.all(ScreenSize.width(context, 3)),
    //   child: 
    //       SizedBox(
    //         height: ScreenSize.height(context, 3),
    //       ),
    //       InkWell(
    //         borderRadius: BorderRadius.circular(30),
    //         onTap: () async {
    //           if (_controller.text.trim() == BlocProvider.of<SelectedProjectCubit>(context).state!.name) {
    //             await ProjectsProvider.instance.remove(BlocProvider.of<SelectedProjectCubit>(context).state!.id!);
    //             await BlocProvider.of<ProjectsCubit>(context).load();
    //             Navigator.of(context).pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
    //           }
    //         },
    //         child: Container(
    //           height: 50,
    //           decoration: const BoxDecoration(
    //             borderRadius: BorderRadius.all(Radius.circular(30)),
    //             color: Colors.transparent,
    //             border: Border(
    //               top: BorderSide(color: Colors.red, width: 1),
    //               left: BorderSide(color: Colors.red, width: 1),
    //               right: BorderSide(color: Colors.red, width: 1),
    //               bottom: BorderSide(color: Colors.red, width: 1)
    //             )
    //           ),
    //           child: Center(
    //             child: Text(
    //               AppLocalizations.of(context)!.delete.toUpperCase(),
    //               style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
    //             )
    //           ),
    //         )
    //       ),
    //     ]
    //   )
    // );
  }
}