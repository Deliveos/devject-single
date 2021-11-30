import 'package:devject_single/utils/screen_size.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({Key? key, required this.image}) : super(key: key);

  final Widget image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ScreenSize.width(context, 100)
      ),
      child: image
    );
  }
}