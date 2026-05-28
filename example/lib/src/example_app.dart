part of '../main.dart';

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_ui_kit example',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: UiTheme.light().toThemeData(),
      darkTheme: UiTheme.dark().toThemeData(),
      home: ExampleHome(
        themeMode: _themeMode,
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}
