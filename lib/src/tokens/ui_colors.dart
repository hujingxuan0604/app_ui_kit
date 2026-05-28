import 'package:flutter/material.dart';

class UiColors {
  const UiColors._();

  static const Color primary = Color(0xFF3D38F5);
  static const Color primaryLight = Color(0xFF5A55F7);
  static const Color primaryDark = Color(0xFF2A26D4);

  static const Color success = Color(0xFF14AE5C);
  static const Color warning = Color(0xFFF7D15F);
  static const Color error = Color(0xFFD4183D);
  static const Color info = Color(0xFF007BE5);

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkBackgroundGradient = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF111111);
  static const Color darkSurfaceElevated = Color(0xFF1A1A1A);
  static const Color darkSurfaceLight = Color(0xFF222222);
  static const Color darkSurfaceLighter = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF888888);
  static const Color darkBorder = Color(0xFF222222);
  static const Color darkBorderHover = Color(0xFF333333);
  static const Color darkBorderActive = Color(0xFF444444);

  static const Color lightBackground = Color(0xFFF8F8FA);
  static const Color lightBackgroundGradient = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF8FAFC);
  static const Color lightSurfaceLight = Color(0xFFF1F5F9);
  static const Color lightSurfaceLighter = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF555567);
  static const Color lightTextTertiary = Color(0xFF717182);
  static const Color lightBorder = Color(0xFFE8E8EC);
  static const Color lightBorderHover = Color(0xFFD1D1D6);
  static const Color lightBorderActive = Color(0xFF9CA3AF);

  static const Color shadowColor = Color(0xFF000000);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color background(BuildContext context) {
    return isDark(context) ? darkBackground : lightBackground;
  }

  static Color surface(BuildContext context) {
    return isDark(context) ? darkSurface : lightSurface;
  }

  static Color surfaceLight(BuildContext context) {
    return isDark(context) ? darkSurfaceLight : lightSurfaceLight;
  }

  static Color surfaceLighter(BuildContext context) {
    return isDark(context) ? darkSurfaceLighter : lightSurfaceLighter;
  }

  static Color textPrimary(BuildContext context) {
    return isDark(context) ? darkTextPrimary : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return isDark(context) ? darkTextSecondary : lightTextSecondary;
  }

  static Color textTertiary(BuildContext context) {
    return isDark(context) ? darkTextTertiary : lightTextTertiary;
  }

  static Color border(BuildContext context) {
    return isDark(context) ? darkBorder : lightBorder;
  }

  static Color borderHover(BuildContext context) {
    return isDark(context) ? darkBorderHover : lightBorderHover;
  }

  static Color borderActive(BuildContext context) {
    return isDark(context) ? darkBorderActive : lightBorderActive;
  }

  static LinearGradient primaryGradient(BuildContext context) {
    return LinearGradient(
      colors: isDark(context)
          ? [primaryLight, primary]
          : [primary, primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient surfaceGradient(BuildContext context) {
    return LinearGradient(
      colors: isDark(context)
          ? [darkSurface, darkSurfaceElevated]
          : [lightSurface, lightSurfaceElevated],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient glassGradient(BuildContext context) {
    return LinearGradient(
      colors: isDark(context)
          ? [darkSurfaceElevated.withAlpha(238), darkSurface.withAlpha(212)]
          : [lightSurface.withAlpha(245), lightSurface.withAlpha(220)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static List<BoxShadow> shadowXs(BuildContext context) => [
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 40 : 15),
      blurRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowSm(BuildContext context) => [
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 50 : 20),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 30 : 10),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd(BuildContext context) => [
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 60 : 25),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 40 : 15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg(BuildContext context) => [
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 70 : 30),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 50 : 20),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowGlow(BuildContext context) => [
    BoxShadow(
      color: primaryLight.withAlpha(isDark(context) ? 110 : 60),
      blurRadius: 24,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: primary.withAlpha(isDark(context) ? 70 : 30),
      blurRadius: 48,
      spreadRadius: -8,
    ),
  ];

  static List<BoxShadow> shadowInner(BuildContext context) => [
    BoxShadow(
      color: shadowColor.withAlpha(isDark(context) ? 80 : 20),
      blurRadius: 4,
      offset: const Offset(0, 2),
      blurStyle: BlurStyle.inner,
    ),
  ];
}
