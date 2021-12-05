import 'package:flutter/material.dart';
import '../utils/screen_size.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.items,
    required this.index
  }) : super(key: key);

  final List<BottomNavBarItem> items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.all(ScreenSize.width(context, 5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    Key? key,
    required this.icon,
    this.onTap
  }) : super(key: key);

  final Icon icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: icon,
    );
  }
}