import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';

class UiContentDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  final double width;
  final String? description;

  const UiContentDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.width = 420,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return AlertDialog(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.components.dialog.radius),
        side: BorderSide(color: theme.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: theme.textPrimary,
        ),
      ),
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null && description!.trim().isNotEmpty) ...[
              Text(
                description!,
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
      actions: actions,
    );
  }
}
