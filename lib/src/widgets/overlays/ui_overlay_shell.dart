import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';

class UiOverlayShell extends StatelessWidget {
  final VoidCallback onDismiss;
  final List<Widget> children;
  final Key? stackKey;

  const UiOverlayShell({
    super.key,
    required this.onDismiss,
    required this.children,
    this.stackKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stackKey,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
          ),
        ),
        ...children,
      ],
    );
  }
}

class UiFloatingPanel extends StatelessWidget {
  final double? width;
  final double? maxHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const UiFloatingPanel({
    super.key,
    this.width,
    this.maxHeight,
    this.padding = const EdgeInsets.symmetric(vertical: UiSpacing.space1),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          maxWidth: width ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: theme.surfaceElevated,
            borderRadius: BorderRadius.circular(UiRadii.md),
            border: Border.all(color: theme.border.withValues(alpha: 0.72)),
            boxShadow: theme.shadowMd,
          ),
          child: child,
        ),
      ),
    );
  }
}
