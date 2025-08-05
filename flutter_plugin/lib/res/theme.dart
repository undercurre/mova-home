import 'package:flutter/material.dart';

final ThemeData themeDataBlue =
    ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.white);
final ThemeData themeDataBlack = ThemeData(
  primaryColor: Colors.black,
);
final ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent);
final ThemeData themeLight = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent);
List themeList = [themeLight, themeDark];
