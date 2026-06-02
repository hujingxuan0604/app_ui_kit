part of '../main.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiThemeApp(
      title: 'app_ui_kit example',
      debugShowCheckedModeBanner: false,
      home: ExampleHome(),
    );
  }
}
