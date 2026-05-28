import 'package:flutter/material.dart';

import 'ui_icon_action_button.dart';

class UiPreviewActionButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;

  const UiPreviewActionButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return UiIconActionButton(
      icon: Icon(icon),
      onPressed: onPressed ?? onTap,
      tooltip: tooltip,
      size: 36,
    );
  }
}
