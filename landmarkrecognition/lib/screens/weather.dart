import 'package:flutter/material.dart';
import 'package:landmarkrecognition/src/screens/routes.dart';
import 'package:landmarkrecognition/src/screens/weather_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:landmarkrecognition/src/themes.dart';
import 'package:landmarkrecognition/src/utils/constants.dart';
import 'package:landmarkrecognition/src/utils/converters.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(AppStateContainer(child: WeatherApp()));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

// ignore: must_be_immutable
class WeatherApp extends StatelessWidget {
  String cityName;
  bool flag = false;
  WeatherApp({this.cityName,this.flag}) : assert(cityName != null);
  //WeatherApp({Key key, @required this.cityName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("");
    print(cityName);
    print("");
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: AppStateContainer.of(context).theme,
      home: WeatherScreen(cityName: cityName,flag: flag,),
      routes: Routes.mainRoute,
    );
  }
}

/// top level widget to hold application state
/// state is passed down with an inherited widget
class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({@required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {
  ThemeData _theme = Themes.getTheme(Themes.DARK_THEME_CODE);
  int themeCode = Themes.DARK_THEME_CODE;
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;


  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPref) {
      setState(() {
        themeCode = sharedPref.getInt(CONSTANTS.SHARED_PREF_KEY_THEME) ??
            Themes.DARK_THEME_CODE;
        temperatureUnit = TemperatureUnit.values[
        sharedPref.getInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT) ??
            TemperatureUnit.celsius.index];
        this._theme = Themes.getTheme(themeCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(theme.accentColor);
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  ThemeData get theme => _theme;

  updateTheme(int themeCode) {
    setState(() {
      _theme = Themes.getTheme(themeCode);
      this.themeCode = themeCode;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_THEME, themeCode);
    });
  }

  updateTemperatureUnit(TemperatureUnit unit) {
    setState(() {
      this.temperatureUnit = unit;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT, unit.index);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  const _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) => true;
}
