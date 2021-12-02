import 'package:devject_single/constants/colors.dart';
import 'package:flutter/material.dart';


final ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    toolbarHeight: 50,
    shadowColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: kPrimaryLightColor,
      size: 20
    )
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: kButtonTextColor
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: kInputFieldColor,
    errorStyle: TextStyle(
      color: kErrorTextColor
    )
  ),
  iconTheme: const IconThemeData(
    color: kTextColorForLightTheme,
    size: 20
  ),
  colorScheme: const ColorScheme(
    background: kBackgroundLightColorForLightTheme,
    brightness: Brightness.light,
    error: kErrorTextColor,
    onBackground: kBackgroundDarkColorForLightTheme,
    onError: kErrorTextColor,
    primary: kPrimaryLightColor,
    onPrimary: kPrimaryDarkColor,
    primaryVariant: kPrimaryLightColor,
    secondary: kPrimaryLightColor,
    onSecondary: kPrimaryLightColor,
    surface: kPrimaryLightColor,
    onSurface: kPrimaryLightColor,
    secondaryVariant: kPrimaryLightColor
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryLightColor,
    hoverColor: kPrimaryLightColor,
    focusColor: kPrimaryLightColor,
    enableFeedback: false,
    splashColor: kPrimaryDarkColor
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: kBackgroundLightColorForLightTheme
  ),
  primaryColor: kPrimaryLightColor,
  primaryColorLight: kPrimaryLightColor,
  primaryColorDark: kPrimaryDarkColor,
  backgroundColor: kBackgroundDarkColorForLightTheme,
  dividerTheme: const DividerThemeData(
      color: kPrimaryDarkColor
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 18.0
      ),
      subtitle2: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 14.0
      ),
      bodyText1: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 14.0,
        fontWeight: FontWeight.w300
      ),
      bodyText2: TextStyle(
        color: kPrimaryLightColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w700
      ),
      caption: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 36.0,
        fontWeight: FontWeight.w700
      ),
      button: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 20.0,
        fontWeight: FontWeight.w700
      ),
      headline2: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 16.0,
        fontWeight: FontWeight.w600
      ),
      headline4: TextStyle(
        color: kTextColorForLightTheme,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
      headline6: TextStyle(
        fontSize: 16.0,
        fontFamily: "NotoColorEmoji"
      ),
    )
);