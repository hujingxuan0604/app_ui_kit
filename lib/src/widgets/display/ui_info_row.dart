import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';

class UiInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? icon;
  final EdgeInsetsGeometry valuePadding;
  final double radius;

  const UiInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valuePadding = const EdgeInsets.all(12),
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    if (icon == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.textTertiary),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: valuePadding,
            decoration: BoxDecoration(
              color: theme.surfaceLight,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: theme.border),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: theme.textPrimary,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        IconTheme(
          data: IconThemeData(size: 14, color: theme.textTertiary),
          child: icon!,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(color: theme.textSecondary, fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.textPrimary, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
