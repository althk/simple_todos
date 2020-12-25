import 'package:flutter/material.dart';

class AppThemeSwitcher extends ChangeNotifier {
  bool _darkMode = false;
  bool get isDarkModeInUse => _darkMode;
  ThemeMode get currentTheme => _darkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
