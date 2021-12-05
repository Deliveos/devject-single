import '../constants/sizes.dart';
import 'package:flutter/material.dart';

class ColorText extends StatelessWidget {
  const ColorText({
    Key? key,
    required this.color,
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            kBorderRadius
          )
        )
      ),
      child: child
    );
  }
}