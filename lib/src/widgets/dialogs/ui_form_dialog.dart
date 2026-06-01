import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';
import 'ui_dialog_shell.dart';

class UiFormDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback onConfirm;
  final double width;
  final EdgeInsetsGeometry contentPadding;

  const UiFormDialog({
    super.key,
    required this.title,
    required this.child,
    required this.onConfirm,
    this.description,
    this.cancelLabel = '取消',
    this.confirmLabel = '保存',
    this.onCancel,
    this.width = 360,
    this.contentPadding = const EdgeInsets.fromLTRB(20, 0, 20, 18),
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return UiDialogShell(
      title: UiDialogTitle(title: title),
      contentPadding: contentPadding,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_description.isNotEmpty) ...[
            UiDialogDescription(text: _description),
            const SizedBox(height: 12),
          ],
          SizedBox(width: _width(theme), child: child),
        ],
      ),
      actions: [
        SizedBox(
          width: _width(theme),
          child: Row(
            children: [
              Expanded(
                child: UiButton(
                  label: cancelLabel,
                  variant: UiButtonVariant.secondary,
                  size: UiButtonSize.small,
                  fullWidth: true,
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: UiButton(
                  label: confirmLabel,
                  size: UiButtonSize.small,
                  fullWidth: true,
                  onPressed: onConfirm,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _description => description ?? '';

  double _width(UiThemeData theme) =>
      width == 360 ? theme.components.dialog.width : width;
}
