import 'dart:async';

import 'package:flutter/material.dart';

import 'ui_theme.dart';
import 'ui_theme_controller.dart';
import 'ui_theme_data.dart';
import 'ui_theme_scope.dart';

class UiThemeApp extends StatefulWidget {
  final UiThemeController? controller;
  final bool loadThemeMode;
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
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final TransitionBuilder? builder;
  final bool debugShowCheckedModeBanner;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;

  const UiThemeApp({
    super.key,
    this.controller,
    bool loadThemeMode = true,
    @Deprecated('Use loadThemeMode instead.') bool? loadPersistedMode,
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
    this.scaffoldMessengerKey,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.builder,
    this.debugShowCheckedModeBanner = false,
    this.themeAnimationDuration = const Duration(milliseconds: 220),
    this.themeAnimationCurve = Curves.easeOutCubic,
  }) : loadThemeMode = loadPersistedMode ?? loadThemeMode;

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
    if (widget.loadThemeMode) {
      unawaited(_controller.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiThemeScope(
      controller: _controller,
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
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
            localizationsDelegates: widget.localizationsDelegates,
            supportedLocales: widget.supportedLocales,
            locale: widget.locale,
            builder: widget.builder,
            debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            themeAnimationDuration: widget.themeAnimationDuration,
            themeAnimationCurve: widget.themeAnimationCurve,
          );
        },
      ),
    );
  }
}
