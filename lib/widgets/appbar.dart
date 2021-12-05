import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, {String? title, List<Widget>? actions}) {
  return AppBar(
    title: Text(
      title ?? '',
    ),
    centerTitle: true,
    actions: actions,
  );
}