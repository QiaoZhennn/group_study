import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Palette {
  static final ThemeData lightModeTheme = ThemeData(
    colorSchemeSeed: Colors.lightGreen,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static final ThemeData darkModeTheme = ThemeData(
    colorSchemeSeed: Colors.lightGreen,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}

var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(
    brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
  ),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeMode mode;

  ThemeMode get getMode => mode;

  ThemeNotifier(this.mode) : super(mode) {
    getThemeMode();
  }
  void getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString('theme');
    if (theme == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.dark) {
      state = ThemeMode.light;
      mode = ThemeMode.light;
      prefs.setString('theme', 'light');
    } else {
      state = ThemeMode.dark;
      mode = ThemeMode.dark;
      prefs.setString('theme', 'dark');
    }
  }
}
