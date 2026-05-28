import 'package:flutter/material.dart';

import '../tokens/ui_colors.dart';
import '../tokens/ui_radii.dart';
import '../tokens/ui_shadows.dart';
import '../tokens/ui_typography.dart';
import 'ui_component_theme.dart';

class UiThemeData extends ThemeExtension<UiThemeData> {
  final Brightness brightness;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceLight;
  final Color surfaceLighter;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color borderHover;
  final String fontFamily;
  final UiComponentTheme components;

  const UiThemeData({
    required this.brightness,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceLight,
    required this.surfaceLighter,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderHover,
    this.fontFamily = UiTypography.fontFamily,
    this.components = const UiComponentTheme(),
  });

  factory UiThemeData.light({Color primary = UiColors.primary}) {
    return UiThemeData(
      brightness: Brightness.light,
      primary: primary,
      primaryLight: UiColors.primaryLight,
      primaryDark: UiColors.primaryDark,
      success: UiColors.success,
      warning: UiColors.warning,
      error: UiColors.error,
      info: UiColors.info,
      background: UiColors.lightBackground,
      surface: UiColors.lightSurface,
      surfaceElevated: UiColors.lightSurfaceElevated,
      surfaceLight: UiColors.lightSurfaceLight,
      surfaceLighter: UiColors.lightSurfaceLighter,
      textPrimary: UiColors.lightTextPrimary,
      textSecondary: UiColors.lightTextSecondary,
      textTertiary: UiColors.lightTextTertiary,
      border: UiColors.lightBorder,
      borderHover: UiColors.lightBorderHover,
    );
  }

  factory UiThemeData.dark({Color primary = UiColors.primary}) {
    return UiThemeData(
      brightness: Brightness.dark,
      primary: primary,
      primaryLight: UiColors.primaryLight,
      primaryDark: UiColors.primaryDark,
      success: UiColors.success,
      warning: UiColors.warning,
      error: UiColors.error,
      info: UiColors.info,
      background: UiColors.darkBackground,
      surface: UiColors.darkSurface,
      surfaceElevated: UiColors.darkSurfaceElevated,
      surfaceLight: UiColors.darkSurfaceLight,
      surfaceLighter: UiColors.darkSurfaceLighter,
      textPrimary: UiColors.darkTextPrimary,
      textSecondary: UiColors.darkTextSecondary,
      textTertiary: UiColors.darkTextTertiary,
      border: UiColors.darkBorder,
      borderHover: UiColors.darkBorderHover,
    );
  }

  bool get isDark => brightness == Brightness.dark;

  LinearGradient get primaryGradient {
    return LinearGradient(
      colors: isDark ? [primaryLight, primary] : [primary, primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient get surfaceGradient {
    return LinearGradient(
      colors: [surface, surfaceElevated],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  List<BoxShadow> get shadowXs => UiShadows.xs(isDark);
  List<BoxShadow> get shadowSm => UiShadows.sm(isDark);
  List<BoxShadow> get shadowMd => UiShadows.md(isDark);

  ThemeData toThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      surface: surface,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: fontFamily,
      textTheme: UiTypography.textTheme(
        fontFamily: fontFamily,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      dividerColor: border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiRadii.md),
          borderSide: BorderSide(color: border),
        ),
      ),
      extensions: [this],
    );
  }

  @override
  UiThemeData copyWith({
    Brightness? brightness,
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceLight,
    Color? surfaceLighter,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? borderHover,
    String? fontFamily,
    UiComponentTheme? components,
  }) {
    return UiThemeData(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      surfaceLighter: surfaceLighter ?? this.surfaceLighter,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      borderHover: borderHover ?? this.borderHover,
      fontFamily: fontFamily ?? this.fontFamily,
      components: components ?? this.components,
    );
  }

  @override
  UiThemeData lerp(ThemeExtension<UiThemeData>? other, double t) {
    if (other is! UiThemeData) {
      return this;
    }
    return UiThemeData(
      brightness: t < 0.5 ? brightness : other.brightness,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceLighter: Color.lerp(surfaceLighter, other.surfaceLighter, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      components: UiComponentTheme.lerp(components, other.components, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([
    brightness,
    primary,
    primaryLight,
    primaryDark,
    success,
    warning,
    error,
    info,
    background,
    surface,
    surfaceElevated,
    surfaceLight,
    surfaceLighter,
    textPrimary,
    textSecondary,
    textTertiary,
    border,
    borderHover,
    fontFamily,
    components,
  ]);

  @override
  bool operator ==(Object other) {
    return other is UiThemeData &&
        other.brightness == brightness &&
        other.primary == primary &&
        other.primaryLight == primaryLight &&
        other.primaryDark == primaryDark &&
        other.success == success &&
        other.warning == warning &&
        other.error == error &&
        other.info == info &&
        other.background == background &&
        other.surface == surface &&
        other.surfaceElevated == surfaceElevated &&
        other.surfaceLight == surfaceLight &&
        other.surfaceLighter == surfaceLighter &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary &&
        other.textTertiary == textTertiary &&
        other.border == border &&
        other.borderHover == borderHover &&
        other.fontFamily == fontFamily &&
        other.components == components;
  }
}

extension UiThemeDataExtension on BuildContext {
  UiThemeData get uiTheme {
    return Theme.of(this).extension<UiThemeData>() ??
        (Theme.of(this).brightness == Brightness.dark
            ? UiThemeData.dark()
            : UiThemeData.light());
  }
}
