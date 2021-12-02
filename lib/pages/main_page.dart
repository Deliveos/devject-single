import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/cubit/projects_cubit.dart';
import 'package:devject_single/cubit/settings_cubit.dart';
import 'package:devject_single/models/project.dart';
import 'package:devject_single/widgets/appbar.dart';
import 'package:devject_single/widgets/background.dart';
import 'package:devject_single/widgets/project_container.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'add_project_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String routeName = "/";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

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
              title: Text(
                AppLocalizations.of(context)!.projects,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage()
                    )
                  ),
                  icon: Icon(FluentIcons.settings_24_regular,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    size: 20
                  )
                )
              ]
            ),
            body: Background(
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
              ) 
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add, 
                size: 30, 
                color: kButtonTextColor
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProjectPage()));
              }
            )
          )
        );
      }
    );
  }
}
