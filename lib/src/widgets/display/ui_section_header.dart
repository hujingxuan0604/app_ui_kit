import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';

class UiSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double spacing;

  const UiSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).merge(titleStyle),
              ),
              if (subtitle != null) ...[
                SizedBox(height: spacing),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12,
                  ).merge(subtitleStyle),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
