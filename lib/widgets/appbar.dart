import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, {Text? title, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.3),
    title: title,
    centerTitle: true,
    actions: actions,
  );
}