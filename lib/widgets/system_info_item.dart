import 'package:flutter/material.dart';

import '../utils/screen_size.dart';


class SystemInfoItem extends StatelessWidget {
  const SystemInfoItem({
    Key? key, 
    required this.iconData, 
    required this.text
  }) : super(key: key);

  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          color: Theme.of(context).iconTheme.color,
          size: Theme.of(context).iconTheme.size
        ),
        SizedBox(
          width: ScreenSize.width(context, 1)
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).iconTheme.color
          ),
        )
      ],
    );
  }
}