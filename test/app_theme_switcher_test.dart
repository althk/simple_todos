import 'package:flutter/material.dart';
import 'package:simple_todo_manager/app_theme_switcher.dart';
import 'package:test/test.dart';

void main() {
  AppThemeSwitcher _switcher;
  setUp(() {
    _switcher = AppThemeSwitcher();
  });

  tearDown(() {
    _switcher = null;
  });

  group('toggleDarkMode', () {
    test('turns dark mode on/off', () {
      expect(_switcher.isDarkModeInUse, false);
      _switcher.toggleDarkMode();

      expect(_switcher.isDarkModeInUse, true);
      expect(_switcher.currentTheme, ThemeMode.dark);

      _switcher.toggleDarkMode();

      expect(_switcher.isDarkModeInUse, false);
      expect(_switcher.currentTheme, ThemeMode.light);
    });
  });
}
