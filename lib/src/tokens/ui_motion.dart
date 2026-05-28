import 'package:flutter/animation.dart';

class UiMotion {
  const UiMotion._();

  static const Duration fast = Duration(milliseconds: 90);
  static const Duration normal = Duration(milliseconds: 160);
  static const Duration slow = Duration(milliseconds: 240);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
}
