import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';

class UiSidebarItem extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Widget? leading;
  final String? countLabel;
  final bool selected;
  final VoidCallback? onTap;
  final List<Widget> trailingActions;
  final Color? activeColor;
  final EdgeInsetsGeometry padding;

  const UiSidebarItem({
    super.key,
    required this.label,
    this.icon,
    this.leading,
    this.countLabel,
    this.selected = false,
    this.onTap,
    this.trailingActions = const [],
    this.activeColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final selectedColor = activeColor ?? theme.primary;
    final leadingWidget = leading ?? icon ?? const SizedBox.shrink();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UiRadii.lg),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(UiRadii.lg),
        ),
        child: Row(
          children: [
            IconTheme(
              data: IconThemeData(
                size: 18,
                color: selected ? selectedColor : theme.textSecondary,
              ),
              child: leadingWidget,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? selectedColor : theme.textPrimary,
                ),
              ),
            ),
            ...trailingActions,
            if (countLabel != null)
              Text(
                countLabel!,
                style: TextStyle(
                  fontSize: 11,
                  color: selected
                      ? selectedColor.withValues(alpha: 0.8)
                      : theme.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
