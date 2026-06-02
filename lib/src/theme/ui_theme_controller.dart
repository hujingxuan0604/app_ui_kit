import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui_theme.dart';
import 'ui_theme_data.dart';

abstract class UiThemeModeStorage {
  Future<ThemeMode?> readThemeMode();
  Future<void> writeThemeMode(ThemeMode themeMode);
}

class UiThemePreferencesStorage implements UiThemeModeStorage {
  static const defaultKey = 'app_ui_kit:theme_mode';

  final String key;
  final SharedPreferencesAsync _preferences;

  UiThemePreferencesStorage({
    this.key = defaultKey,
    SharedPreferencesAsync? preferences,
  }) : _preferences = preferences ?? SharedPreferencesAsync();

  @override
  Future<ThemeMode?> readThemeMode() async {
    final index = await _preferences.getInt(key);
    if (index == null || index < 0 || index >= ThemeMode.values.length) {
      return null;
    }
    return ThemeMode.values[index];
  }

  @override
  Future<void> writeThemeMode(ThemeMode themeMode) {
    return _preferences.setInt(key, themeMode.index);
  }
}

class UiThemeController extends ChangeNotifier {
  final UiThemeModeStorage storage;
  final bool persistMode;

  ThemeMode _themeMode;
  bool _initialized = false;
  Future<void>? _initializing;

  UiThemeController({
    ThemeMode initialThemeMode = ThemeMode.system,
    UiThemeModeStorage? storage,
    this.persistMode = true,
  }) : _themeMode = initialThemeMode,
       storage = storage ?? UiThemePreferencesStorage();

  ThemeMode get themeMode => _themeMode;
  bool get initialized => _initialized;

  set themeMode(ThemeMode value) => setThemeMode(value);

  Future<void> initThemeMode() {
    return _initializing ??= _loadThemeMode();
  }

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    notifyListeners();
    if (persistMode) {
      unawaited(storage.writeThemeMode(value));
    }
  }

  Future<void> _loadThemeMode() async {
    final storedMode = persistMode ? await storage.readThemeMode() : null;
    _initialized = true;
    if (storedMode != null && storedMode != _themeMode) {
      _themeMode = storedMode;
    }
    notifyListeners();
  }
}

class UiThemeScope extends StatefulWidget {
  final UiThemeController? controller;
  final bool loadPersistedMode;
  final Widget child;

  const UiThemeScope({
    super.key,
    this.controller,
    this.loadPersistedMode = true,
    required this.child,
  });

  static UiThemeController? maybeControllerOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_UiThemeControllerProvider>()
        ?.notifier;
  }

  static UiThemeController controllerOf(BuildContext context) {
    final controller = maybeControllerOf(context);
    if (controller == null) {
      throw FlutterError(
        'No UiThemeScope found. Wrap the app with UiThemeApp or UiThemeScope.',
      );
    }
    return controller;
  }

  @override
  State<UiThemeScope> createState() => _UiThemeScopeState();
}

class _UiThemeScopeState extends State<UiThemeScope> {
  late UiThemeController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _setController(widget.controller);
    _loadThemeMode();
  }

  @override
  void didUpdateWidget(covariant UiThemeScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _setController(widget.controller);
    }
    if (widget.loadPersistedMode && !oldWidget.loadPersistedMode) {
      _loadThemeMode();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _setController(UiThemeController? controller) {
    _ownsController = controller == null;
    _controller = controller ?? UiThemeController();
  }

  void _loadThemeMode() {
    if (widget.loadPersistedMode) {
      unawaited(_controller.initThemeMode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UiThemeControllerProvider(
      notifier: _controller,
      child: widget.child,
    );
  }
}

class _UiThemeControllerProvider extends InheritedNotifier<UiThemeController> {
  const _UiThemeControllerProvider({
    required super.notifier,
    required super.child,
  });
}

class UiThemeApp extends StatefulWidget {
  final UiThemeController? controller;
  final bool loadPersistedMode;
  final UiThemeData? lightTheme;
  final UiThemeData? darkTheme;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  final TransitionBuilder? builder;
  final bool debugShowCheckedModeBanner;

  const UiThemeApp({
    super.key,
    this.controller,
    this.loadPersistedMode = true,
    this.lightTheme,
    this.darkTheme,
    this.title = '',
    this.onGenerateTitle,
    this.home,
    this.routes = const {},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.builder,
    this.debugShowCheckedModeBanner = true,
  });

  @override
  State<UiThemeApp> createState() => _UiThemeAppState();
}

class _UiThemeAppState extends State<UiThemeApp> {
  late UiThemeController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _setController(widget.controller);
    _loadThemeMode();
  }

  @override
  void didUpdateWidget(covariant UiThemeApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _setController(widget.controller);
      _loadThemeMode();
    } else if (widget.loadPersistedMode && !oldWidget.loadPersistedMode) {
      _loadThemeMode();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _setController(UiThemeController? controller) {
    _ownsController = controller == null;
    _controller = controller ?? UiThemeController();
  }

  void _loadThemeMode() {
    if (widget.loadPersistedMode) {
      unawaited(_controller.initThemeMode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiThemeScope(
      controller: _controller,
      loadPersistedMode: false,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return MaterialApp(
            title: widget.title,
            onGenerateTitle: widget.onGenerateTitle,
            themeMode: _controller.themeMode,
            theme: (widget.lightTheme ?? UiTheme.light()).toThemeData(),
            darkTheme: (widget.darkTheme ?? UiTheme.dark()).toThemeData(),
            home: widget.home,
            routes: widget.routes,
            initialRoute: widget.initialRoute,
            onGenerateRoute: widget.onGenerateRoute,
            onUnknownRoute: widget.onUnknownRoute,
            navigatorKey: widget.navigatorKey,
            builder: widget.builder,
            debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          );
        },
      ),
    );
  }
}

extension UiThemeControllerBuildContext on BuildContext {
  UiThemeController get uiThemeController {
    return UiThemeScope.controllerOf(this);
  }

  UiThemeController? get maybeUiThemeController {
    return UiThemeScope.maybeControllerOf(this);
  }
}
