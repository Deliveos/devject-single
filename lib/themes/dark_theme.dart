import 'package:devject_single/constants/colors.dart';
import 'package:devject_single/constants/font.dart';
import 'package:flutter/material.dart';


final ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    shadowColor: Colors.transparent,
    color: Colors.transparent,
    iconTheme: IconThemeData(
      color: kTextColorForDarkTheme,
      size: 20
    ),
    titleTextStyle: TextStyle(
      fontSize: kCaptionSize,
      fontWeight: FontWeight.bold,
      color: kTextColorForDarkTheme
    ),
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
    color: kTextColorForDarkTheme,
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

  backgroundColor: kBackgroundDarkColorForDarkTheme,

  dividerTheme: const DividerThemeData(
      color: kSystemTextColorForLightTheme
  ),
  textTheme: const TextTheme(
    caption: TextStyle(
      fontSize: kCaptionSize,
      fontWeight: FontWeight.bold
    ),
    subtitle1: TextStyle(
      color: kTextColorForDarkTheme,
      fontSize: 18.0
    ),
    subtitle2: TextStyle(
      color: kSystemTextColorForDarkTheme,
      fontSize: 14.0
    ),
    bodyText1: TextStyle(
      color: kTextColorForDarkTheme,
      fontSize: 14.0,
    ),
    bodyText2: TextStyle(
      color: kSystemTextColorForLightTheme,
      fontSize: 14.0,
    ),

    button: TextStyle(
      color: kTextColorForDarkTheme,
      fontSize: 20.0,
      fontWeight: FontWeight.w700
    ),
    headline2: TextStyle(
      color: kTextColorForDarkTheme,
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
  ),

  scaffoldBackgroundColor: kBackgroundLightColorForDarkTheme
);