import 'package:flutter/cupertino.dart';

class AppSize {
  /// Get height with using the size factor
  static double height(BuildContext context, double number) => number * (MediaQuery.of(context).size.height / 667);

  /// Get width with using the size factor
  static double width(BuildContext context, double number) => number * (MediaQuery.of(context).size.width / 375);
}

class ScreenSize {
  /// Get height with using the size factor
  static double height(BuildContext context, double number) => number * (MediaQuery.of(context).size.height / 100);

  /// Get width with using the size factor
  static double width(BuildContext context, double number) => number * (MediaQuery.of(context).size.width / 100);
}