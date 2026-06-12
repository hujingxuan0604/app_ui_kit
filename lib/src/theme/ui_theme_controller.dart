import 'dart:async';

import 'package:flutter/material.dart';

import 'ui_theme_mode_store.dart';

class UiThemeController extends ChangeNotifier {
  final UiThemeModeStore? store;

  ThemeMode _themeMode;
  bool _isLoaded = false;
  Future<void>? _loading;

  UiThemeController({
    this.store,
    ThemeMode initialMode = ThemeMode.system,
    @Deprecated('Use initialMode instead.') ThemeMode? initialThemeMode,
  }) : _themeMode = initialThemeMode ?? initialMode;

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;

  @Deprecated('Use isLoaded instead.')
  bool get initialized => isLoaded;

  set themeMode(ThemeMode mode) {
    unawaited(setThemeMode(mode));
  }

  Future<void> load() {
    return _loading ??= _load();
  }

  @Deprecated('Use load instead.')
  Future<void> initThemeMode() {
    return load();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();
    await store?.saveThemeMode(mode);
  }

  Future<void> setLight() {
    return setThemeMode(ThemeMode.light);
  }

  Future<void> setDark() {
    return setThemeMode(ThemeMode.dark);
  }

  Future<void> setSystem() {
    return setThemeMode(ThemeMode.system);
  }

  Future<void> _load() async {
    final savedMode = await store?.loadThemeMode();
    if (savedMode != null) {
      _themeMode = savedMode;
    }
    _isLoaded = true;
    notifyListeners();
  }
}
