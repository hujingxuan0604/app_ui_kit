import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';

class UiPageHero extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Widget title;
  final Widget? subtitle;
  final Widget? content;
  final Widget? trailing;
  final Gradient? backgroundGradient;
  final Gradient? iconGradient;
  final Color iconColor;
  final double iconSize;
  final double iconContainerSize;
  final double compactBreakpoint;
  final EdgeInsetsGeometry padding;

  const UiPageHero({
    super.key,
    this.icon,
    this.iconWidget,
    required this.title,
    this.subtitle,
    this.content,
    this.trailing,
    this.backgroundGradient,
    this.iconGradient,
    this.iconColor = Colors.white,
    this.iconSize = 34,
    this.iconContainerSize = 72,
    this.compactBreakpoint = 820,
    this.padding = const EdgeInsets.all(UiSpacing.space6),
  }) : assert(icon != null || iconWidget != null, '必须提供 icon 或 iconWidget');

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient:
            backgroundGradient ??
            LinearGradient(
              colors: [theme.primary.withAlpha(38), theme.info.withAlpha(22)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: BorderRadius.circular(UiRadii.xl),
        border: Border.all(color: theme.border),
        boxShadow: theme.shadowMd,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < compactBreakpoint;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: iconContainerSize,
                    height: iconContainerSize,
                    decoration: iconWidget == null
                        ? BoxDecoration(
                            gradient: iconGradient ?? theme.primaryGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          )
                        : null,
                    child:
                        iconWidget ??
                        Icon(icon, color: iconColor, size: iconSize),
                  ),
                  const SizedBox(width: UiSpacing.space5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        if (subtitle != null) ...[
                          const SizedBox(height: UiSpacing.space2),
                          subtitle!,
                        ],
                        if (content != null) ...[
                          const SizedBox(height: UiSpacing.space4),
                          content!,
                        ],
                      ],
                    ),
                  ),
                  if (!compact && trailing != null) ...[
                    const SizedBox(width: UiSpacing.space4),
                    trailing!,
                  ],
                ],
              ),
              if (compact && trailing != null) ...[
                const SizedBox(height: UiSpacing.space4),
                trailing!,
              ],
            ],
          );
        },
      ),
    );
  }
}
