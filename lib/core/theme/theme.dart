import 'package:flutter/material.dart';
import '../config/config.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: AppConfig.primaryColor as MaterialColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: AppConfig.primaryColor as MaterialColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);