import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';

class UiConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool destructive;
  final bool showCancel;
  final IconData? icon;

  const UiConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = '取消',
    this.confirmLabel = '确定',
    this.destructive = false,
    this.showCancel = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final accent = destructive ? theme.error : theme.primary;
    return AlertDialog(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.components.dialog.radius),
        side: BorderSide(color: theme.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: accent),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: theme.components.dialog.width,
        child: Text(
          message,
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: theme.components.dialog.width,
          child: Row(
            children: [
              if (showCancel) ...[
                Expanded(
                  child: UiButton(
                    label: cancelLabel,
                    variant: UiButtonVariant.secondary,
                    size: UiButtonSize.small,
                    fullWidth: true,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: UiButton(
                  label: confirmLabel,
                  variant: destructive
                      ? UiButtonVariant.danger
                      : UiButtonVariant.primary,
                  size: UiButtonSize.small,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
