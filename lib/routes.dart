import 'package:flutter/material.dart';
import 'pages/add_project_page.dart';
import 'pages/main_page.dart';

Map<String, WidgetBuilder> routes = {
  MainPage.routeName: (context) => const MainPage(),
  AddProjectPage.routeName: (context) => const AddProjectPage()
};