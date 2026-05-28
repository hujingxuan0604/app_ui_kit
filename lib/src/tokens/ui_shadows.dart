import 'package:flutter/material.dart';

class UiShadows {
  const UiShadows._();

  static const Color shadowColor = Color(0xFF000000);

  static List<BoxShadow> xs(bool dark) => [
    BoxShadow(
      color: shadowColor.withValues(alpha: dark ? 0.16 : 0.06),
      blurRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> sm(bool dark) => [
    BoxShadow(
      color: shadowColor.withValues(alpha: dark ? 0.2 : 0.08),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: shadowColor.withValues(alpha: dark ? 0.12 : 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> md(bool dark) => [
    BoxShadow(
      color: shadowColor.withValues(alpha: dark ? 0.24 : 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: shadowColor.withValues(alpha: dark ? 0.16 : 0.06),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
