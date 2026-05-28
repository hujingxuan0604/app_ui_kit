import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_state_layer.dart';

class UiSelectableCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double borderWidth;
  final double selectedBorderWidth;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? selectedBoxShadow;

  const UiSelectableCard({
    super.key,
    required this.child,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = 12,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 1,
    this.selectedBorderWidth = 1.5,
    this.boxShadow,
    this.selectedBoxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final cardBg = backgroundColor ?? theme.surfaceLight;
    final selectedBg = selectedBackgroundColor ?? theme.surfaceLighter;
    final radius = BorderRadius.circular(borderRadius);

    return GestureDetector(
      onSecondaryTapDown: onSecondaryTapDown,
      onDoubleTap: onDoubleTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: UiMotion.normal,
          curve: UiMotion.standard,
          padding: padding,
          decoration: BoxDecoration(
            color: selected ? selectedBg : cardBg,
            borderRadius: radius,
            border: selected
                ? Border.all(
                    color:
                        selectedBorderColor ??
                        theme.primary.withValues(
                          alpha: UiStateLayer.strongBorder,
                        ),
                    width: selectedBorderWidth,
                  )
                : borderColor == null
                ? null
                : Border.all(color: borderColor!, width: borderWidth),
            boxShadow: selected ? selectedBoxShadow ?? boxShadow : boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
