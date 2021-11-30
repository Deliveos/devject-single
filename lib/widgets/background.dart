import 'package:devject_single/utils/screen_size.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: ScreenSize.width(context, 3),
        left: ScreenSize.width(context, 3),
        top: ScreenSize.width(context, 3)
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background
      ),
      child: child,
    );
  }
}