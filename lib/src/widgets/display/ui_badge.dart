import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../buttons/ui_icon_action_button.dart';

const double uiBadgeRadius = UiRadii.sm;

@immutable
class UiBadgeStyle {
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final Color? foregroundColor;
  final Color? iconColor;
  final double iconSize;
  final double gap;

  const UiBadgeStyle({
    this.padding = const EdgeInsets.symmetric(
      horizontal: UiSpacing.space2,
      vertical: 4,
    ),
    this.decoration,
    this.textStyle,
    this.foregroundColor,
    this.iconColor,
    this.iconSize = 14,
    this.gap = UiSpacing.space2,
  });

  UiBadgeStyle copyWith({
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    TextStyle? textStyle,
    Color? foregroundColor,
    Color? iconColor,
    double? iconSize,
    double? gap,
  }) {
    return UiBadgeStyle(
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      textStyle: textStyle ?? this.textStyle,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
    );
  }
}

class UiBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Object? icon;
  final UiBadgeStyle style;

  const UiBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.style = const UiBadgeStyle(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final accent = color ?? theme.primary;
    final resolvedTextStyle =
        (style.textStyle ??
                TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ))
            .copyWith(
              color:
                  style.foregroundColor ??
                  style.textStyle?.color ??
                  (style.decoration == null ? accent : Colors.white),
            );
    final resolvedDecoration =
        style.decoration ??
        BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(uiBadgeRadius),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
        );

    return Container(
      padding: style.padding,
      decoration: resolvedDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            _buildIcon(resolvedTextStyle),
            SizedBox(width: style.gap),
          ],
          Text(label, style: resolvedTextStyle),
        ],
      ),
    );
  }

  Widget _buildIcon(TextStyle textStyle) {
    final iconColor = style.iconColor ?? textStyle.color;
    if (icon is IconData) {
      return Icon(icon as IconData, size: style.iconSize, color: iconColor);
    }
    return IconTheme(
      data: IconThemeData(size: style.iconSize, color: iconColor),
      child: icon! as Widget,
    );
  }
}

class UiColorBadge extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const UiColorBadge({
    super.key,
    required this.label,
    required this.color,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final badge = UiBadge(
      label: label,
      color: color,
      style: UiBadgeStyle(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(uiBadgeRadius),
          border: Border.all(color: color.withValues(alpha: 0.24)),
        ),
        foregroundColor: color,
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );

    if (onTap == null) {
      return badge;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(uiBadgeRadius),
      child: badge,
    );
  }
}

class UiSelectionBadge extends StatelessWidget {
  final String label;
  final bool selected;

  const UiSelectionBadge({
    super.key,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final color = selected ? theme.primary : theme.textTertiary;
    return UiColorBadge(label: label, color: color);
  }
}

class UiSelectionToggleBadge extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color iconColor;

  const UiSelectionToggleBadge({
    super.key,
    this.selected = false,
    required this.onTap,
    this.size = 20,
    this.iconSize = 12,
    this.selectedIcon = Icons.check,
    this.unselectedIcon = Icons.add,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final fillColor = selected
        ? selectedColor ?? theme.primary
        : unselectedColor ?? Colors.black.withValues(alpha: 0.38);
    final borderColor = selected
        ? selectedBorderColor ?? theme.primary
        : unselectedBorderColor ?? Colors.white.withValues(alpha: 0.8);

    return UiIconActionButton(
      icon: selected ? selectedIcon : unselectedIcon,
      onTap: onTap,
      size: size,
      iconSize: iconSize,
      radius: uiBadgeRadius,
      color: iconColor,
      backgroundColor: fillColor,
      borderColor: borderColor,
    );
  }
}
