import 'package:devject_single/cubit/curret_tasks_cubit.dart';
import 'package:devject_single/cubit/selected_project_cubit.dart';
import 'package:devject_single/cubit/selected_task_cubit.dart';
import 'package:devject_single/cubit/settings_cubit.dart';
import 'package:devject_single/cubit/tasks_cubit.dart';
import 'package:devject_single/models/settings.dart';
import 'package:devject_single/pages/add_project_page.dart';
import 'package:devject_single/pages/add_task_page.dart';
import 'package:devject_single/pages/home_page.dart';
import 'package:devject_single/pages/project_page.dart';
import 'package:devject_single/pages/settings_page.dart';
import 'package:devject_single/pages/task_page.dart';
import 'package:devject_single/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'cubit/projects_cubit.dart';
import 'l10n/l10n.dart';
import 'pages/projects_page.dart';
import 'themes/dark_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurretTasksCubit()),
        BlocProvider(create: (context) => TasksCubit()),
        BlocProvider(create: (context) => SelectedTaskCubit()),
        BlocProvider(create: (context) => ProjectsCubit()),
        BlocProvider(create: (context) => SelectedProjectCubit()),
        BlocProvider(create: (context) => SettingsCubit())
      ],
      child: BlocBuilder<SettingsCubit, Settings>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Devject Single',
            debugShowCheckedModeBanner: false,
            themeMode: getThemeMode(settingsState.isDarkTheme),
            theme: lightTheme,
            darkTheme: darkTheme,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              ProjectsPage.routeName: (context) => const ProjectsPage(),
              ProjectPage.routeName: (context) => const ProjectPage(),
              TaskPage.routeName: (context) => const TaskPage(),
              SettingsPage.routeName: (context) => const SettingsPage(),
              AddProjectPage.routeName: (context) => const AddProjectPage(),
              AddTaskPage.routeName: (context) => const AddTaskPage()
            },
          );
        },
      ),
    );
  }

  ThemeMode getThemeMode(bool? isDarkTheme) {
    ThemeMode themeMode = ThemeMode.system;
    switch(isDarkTheme) {
      case null:
        themeMode = ThemeMode.system;
        break;
      case false:
        themeMode = ThemeMode.light;
        break;
      case true:
        themeMode = ThemeMode.dark;
        break;
    }
    return themeMode;
  }
}
