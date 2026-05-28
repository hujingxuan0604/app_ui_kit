import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';

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
    return AlertDialog(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.components.dialog.radius),
        side: BorderSide(color: theme.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      contentPadding: contentPadding,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: theme.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_description.isNotEmpty) ...[
            Text(
              _description,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
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
