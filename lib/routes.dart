import 'package:flutter/material.dart';
import 'pages/add_project_page.dart';
import 'pages/projects_page.dart';

Map<String, WidgetBuilder> routes = {
  ProjectsPage.routeName: (context) => const ProjectsPage(),
  AddProjectPage.routeName: (context) => const AddProjectPage()
};