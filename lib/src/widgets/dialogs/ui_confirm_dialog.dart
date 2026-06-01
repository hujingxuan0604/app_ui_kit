import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';
import 'ui_dialog_shell.dart';

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
    return UiDialogShell(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: UiDialogTitle(title: title, icon: icon, iconColor: accent),
      content: SizedBox(
        width: theme.components.dialog.width,
        child: UiDialogDescription(text: message, fontSize: 13, height: 1.5),
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
