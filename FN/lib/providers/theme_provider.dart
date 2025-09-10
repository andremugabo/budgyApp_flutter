import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void toggle(bool dark) {
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

ThemeData buildLightTheme() {
  const seed = Color(0xFF2F80ED);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[50],
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFF2F80ED);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}


