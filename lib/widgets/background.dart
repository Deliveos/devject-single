import 'package:devject_single/utils/size.dart';
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
        color: Theme.of(context).colorScheme.background,
        // image: const DecorationImage(image: AssetImage("assets/images/avatar_example.jpg"), fit: BoxFit.fill)
        // gradient: LinearGradient(
        //   colors: [
        //     Theme.of(context).colorScheme.background,
        //     Theme.of(context).colorScheme.onBackground
        //   ],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter
        // )
      ),
      child: child,
    );
  }
}