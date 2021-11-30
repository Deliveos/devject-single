import 'package:flutter/cupertino.dart';

/// Sets the dimensions as a percentage relative to the width and height of the screen
class ScreenSize {
  /// Get height by percentage of the screen
  static double height(BuildContext context, double number) => 
    number * (MediaQuery.of(context).size.height / 100);

  /// Get width by percentage of the screen
  static double width(BuildContext context, double number) => 
    number * (MediaQuery.of(context).size.width / 100);
}