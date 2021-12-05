import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cubit/projects_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../models/project.dart';
import '../utils/screen_size.dart';
import '../widgets/appbar.dart';
import '../widgets/main_bottom_nav_bar.dart';
import '../widgets/project_container.dart';
import 'add_project_page.dart';


class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  static const String routeName = "ProjectsPage";

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SettingsCubit>(context).load();
    return BlocBuilder<ProjectsCubit, List<Project>>(
      builder: (context, projects) {
        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<ProjectsCubit>(context).load();
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(
              context,
              title: AppLocalizations.of(context)!.projects,
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const AddProjectPage()
                    )
                  ),
                  icon: Icon(
                    FluentIcons.add_24_filled,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    size: 20
                  )
                )
              ]
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.width(context, 5)
              ),
              child: Column(
                children: [
                  projects.isNotEmpty 
                  ? Expanded(
                    flex: 4,
                    child: ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) => ProjectContainer(projects[index])
                    )
                  )
                  : Expanded(
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noProjects,
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ),
                    ),
                  )
                ]
              ),
            ),
            bottomNavigationBar: const MainBottomNavBar(),
          )
        );
      }
    );
  }
}
