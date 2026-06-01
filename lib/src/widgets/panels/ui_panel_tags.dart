import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../display/ui_badge.dart';

enum UiPanelTagStyle { primary, secondary, outlined }

class UiPanelTag extends StatelessWidget {
  final IconData? icon;
  final String label;
  final UiPanelTagStyle style;
  final VoidCallback? onTap;

  const UiPanelTag({
    super.key,
    this.icon,
    required this.label,
    this.style = UiPanelTagStyle.secondary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return GestureDetector(
      onTap: onTap,
      child: UiBadge(
        label: label,
        icon: icon,
        style: UiBadgeStyle(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: _backgroundColor(theme),
            borderRadius: BorderRadius.circular(uiBadgeRadius),
            border: Border.all(color: _borderColor(theme)),
          ),
          foregroundColor: _foregroundColor(theme),
          iconColor: _foregroundColor(theme),
          iconSize: 10,
          gap: 3,
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: style == UiPanelTagStyle.primary
                ? FontWeight.w500
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary.withValues(alpha: 0.1);
      case UiPanelTagStyle.secondary:
        return theme.surfaceLight.withValues(alpha: 0.6);
      case UiPanelTagStyle.outlined:
        return Colors.transparent;
    }
  }

  Color _borderColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary.withValues(alpha: 0.3);
      case UiPanelTagStyle.secondary:
        return theme.border.withValues(alpha: 0.5);
      case UiPanelTagStyle.outlined:
        return theme.border;
    }
  }

  Color _foregroundColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary;
      case UiPanelTagStyle.secondary:
      case UiPanelTagStyle.outlined:
        return theme.textSecondary;
    }
  }
}

class UiPanelTagRow extends StatelessWidget {
  final List<UiPanelTag> tags;
  final double spacing;
  final Widget? trailing;

  const UiPanelTagRow({
    super.key,
    required this.tags,
    this.spacing = 6,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...tags.map(
          (tag) => Padding(
            padding: EdgeInsets.only(right: spacing),
            child: tag,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class UiPanelStatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const UiPanelStatBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return UiBadge(
      label: '$label: $value',
      icon: icon,
      style: UiBadgeStyle(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(uiBadgeRadius),
          border: Border.all(color: theme.border.withValues(alpha: 0.5)),
        ),
        foregroundColor: theme.textPrimary,
        iconColor: theme.textSecondary,
        iconSize: 12,
        gap: 4,
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
