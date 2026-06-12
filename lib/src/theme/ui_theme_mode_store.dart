import 'package:flutter/material.dart';

abstract class UiThemeModeStore {
  Future<ThemeMode?> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

class UiMemoryThemeModeStore implements UiThemeModeStore {
  ThemeMode? _mode;

  UiMemoryThemeModeStore([this._mode]);

  @override
  Future<ThemeMode?> loadThemeMode() async {
    return _mode;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _mode = mode;
  }
}
