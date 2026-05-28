import 'package:flutter/material.dart';

import '../../models/ui_models.dart';
import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../buttons/ui_button.dart';
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(maxHeight: 560),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(UiRadii.xl),
          border: Border.all(color: theme.border),
          boxShadow: theme.shadowMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(height: 1, color: theme.border),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 96,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final selected = option.id == _selectedId;
                  return InkWell(
                    borderRadius: BorderRadius.circular(UiRadii.lg),
                    onTap: () => setState(() => _selectedId = option.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.primary.withValues(alpha: 0.12)
                            : theme.surfaceLight,
                        borderRadius: BorderRadius.circular(UiRadii.lg),
                        border: Border.all(
                          color: selected ? theme.primary : theme.border,
                        ),
                      ),
                      child: Center(
                        child: UiAvatar(
                          image: option.image,
                          label: option.label,
                          size: 56,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, color: theme.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
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
        ),
      ),
    );
  }
}
