import 'package:flutter/material.dart';

import '../../models/ui_models.dart';
import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../buttons/ui_button.dart';
import '../dialogs/ui_dialog_shell.dart';
import '../surfaces/ui_selectable_card.dart';
import 'ui_avatar.dart';

class UiAvatarPickerDialog extends StatefulWidget {
  final List<UiAvatarOption> options;
  final String? selectedId;
  final String title;
  final String cancelLabel;
  final String confirmLabel;

  const UiAvatarPickerDialog({
    super.key,
    required this.options,
    this.selectedId,
    this.title = '选择头像',
    this.cancelLabel = '取消',
    this.confirmLabel = '保存',
  });

  @override
  State<UiAvatarPickerDialog> createState() => _UiAvatarPickerDialogState();
}

class _UiAvatarPickerDialogState extends State<UiAvatarPickerDialog> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return UiDialogShell(
      title: UiDialogTitle(title: widget.title),
      content: SizedBox(
        width: 480,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 88,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              final option = widget.options[index];
              final selected = option.id == _selectedId;
              return UiSelectableCard(
                selected: selected,
                onTap: () => setState(() => _selectedId = option.id),
                padding: EdgeInsets.zero,
                borderRadius: UiRadii.lg,
                backgroundColor: theme.surfaceLight,
                selectedBackgroundColor: theme.primary.withValues(alpha: 0.12),
                borderColor: theme.border,
                selectedBorderColor: theme.primary,
                child: Center(
                  child: UiAvatar(
                    image: option.image,
                    label: option.label,
                    size: 56,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 480,
          child: Row(
            children: [
              Expanded(
                child: UiButton(
                  label: widget.cancelLabel,
                  variant: UiButtonVariant.secondary,
                  size: UiButtonSize.small,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: UiButton(
                  label: widget.confirmLabel,
                  size: UiButtonSize.small,
                  fullWidth: true,
                  onPressed: () {
                    UiAvatarOption? selected;
                    for (final option in widget.options) {
                      if (option.id == _selectedId) {
                        selected = option;
                        break;
                      }
                    }
                    Navigator.of(context).pop(selected);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
