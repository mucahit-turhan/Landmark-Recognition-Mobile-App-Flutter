import 'package:flutter/material.dart';
import 'package:landmarkrecognition/src/screens/settings_screen.dart';
import 'package:landmarkrecognition/src/screens/weather_screen.dart';

class Routes {

  static final mainRoute = <String, WidgetBuilder>{
    '/home': (context) => WeatherScreen(),
    '/settings': (context) => SettingsScreen(),
  };
}
