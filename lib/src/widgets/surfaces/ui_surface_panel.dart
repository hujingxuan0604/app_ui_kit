import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';

class UiSurfacePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;

  const UiSurfacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? theme.surfaceLight,
        border: border ?? Border.all(color: theme.border),
        borderRadius: borderRadius ?? BorderRadius.circular(UiRadii.lg),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
