import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../pages/projects_page.dart';
import '../pages/settings_page.dart';
import '../pages/home_page.dart';
import '../widgets/bottom_nav_bar.dart';


class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      items: <BottomNavBarItem>[
        BottomNavBarItem(
          icon: Icon(
            FluentIcons.home_24_regular,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onTap: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.routeName, (route) => false
            );
          },
        ),
        BottomNavBarItem(
          icon: Icon(
            FluentIcons.list_24_regular,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onTap: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
              ProjectsPage.routeName, (route) => false
            );
          },
        ),
        BottomNavBarItem(
          icon: Icon(
            FluentIcons.settings_24_regular,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onTap: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SettingsPage.routeName, (route) => false
            );
          },
        ),
      ], 
      index: 0
    );
  }
}