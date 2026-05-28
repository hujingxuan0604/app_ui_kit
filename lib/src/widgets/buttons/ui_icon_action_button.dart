import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';

class UiIconActionButton extends StatelessWidget {
  final Object icon;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final double? iconSize;
  final bool selected;
  final Color? color;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;

  const UiIconActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onTap,
    this.tooltip,
    this.size = 32,
    this.iconSize,
    this.selected = false,
    this.color,
    this.radius = UiRadii.lg,
    this.backgroundColor,
    this.borderColor,
  });

  factory UiIconActionButton.search({
    Key? key,
    required VoidCallback? onTap,
    String tooltip = '搜索',
    double size = 32,
  }) {
    return UiIconActionButton(
      key: key,
      tooltip: tooltip,
      icon: Icons.search_rounded,
      onTap: onTap,
      size: size,
      iconSize: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final callback = onPressed ?? onTap;
    final child = SizedBox.square(
      dimension: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: iconSize ?? size * 0.52,
        tooltip: tooltip,
        onPressed: callback,
        style: IconButton.styleFrom(
          backgroundColor: selected
              ? theme.primary
              : backgroundColor ?? theme.surfaceLight,
          foregroundColor: selected
              ? Colors.white
              : color ?? theme.textSecondary,
          disabledForegroundColor: theme.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: selected ? theme.primary : borderColor ?? theme.border,
            ),
          ),
        ),
        icon: icon is IconData ? Icon(icon as IconData) : icon as Widget,
      ),
    );
    return child;
  }
}
