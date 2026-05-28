import 'package:flutter/material.dart';

import 'ui_theme_data.dart';

class UiTheme {
  const UiTheme._();

  static UiThemeData light({Color primary = const Color(0xFF3D38F5)}) {
    return UiThemeData.light(primary: primary);
  }

  static UiThemeData dark({Color primary = const Color(0xFF3D38F5)}) {
    return UiThemeData.dark(primary: primary);
  }

  static UiThemeData of(BuildContext context) => context.uiTheme;
}
