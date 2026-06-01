import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';
import '../display/ui_badge.dart';
import '../inputs/ui_dropdown.dart';
import '../inputs/ui_text_field.dart';

class UiPanelInput extends StatefulWidget {
  final String label;
  final String initialValue;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const UiPanelInput({
    super.key,
    required this.label,
    required this.initialValue,
    this.hint = '',
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<UiPanelInput> createState() => _UiPanelInputState();
}

class _UiPanelInputState extends State<UiPanelInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue)
      ..selection = TextSelection.collapsed(offset: widget.initialValue.length);
  }

  @override
  void didUpdateWidget(covariant UiPanelInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(
        offset: widget.initialValue.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UiTextField(
      label: widget.label,
      hintText: widget.hint,
      controller: _controller,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      size: UiTextFieldSize.compact,
    );
  }
}

class UiPanelDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const UiPanelDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return UiDropdown<String>(
      label: label,
      value: value,
      options: [
        for (final item in items) UiDropdownOption(value: item, label: item),
      ],
      onChanged: onChanged,
      size: UiDropdownSize.compact,
    );
  }
}

class UiPanelUnsavedIndicator extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;

  const UiPanelUnsavedIndicator({super.key, this.text = '未保存', this.margin});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: margin ?? const EdgeInsets.only(right: 8),
      child: UiBadge(
        label: text,
        icon: Icons.edit,
        color: theme.warning,
        style: const UiBadgeStyle(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          iconSize: 10,
          gap: 4,
          textStyle: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

class UiPanelEditArea extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const UiPanelEditArea({super.key, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class UiPanelFormRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const UiPanelFormRow({super.key, required this.children, this.spacing = 8});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((child) => Expanded(child: child))
          .toList()
          .expand((widget) => [widget, SizedBox(width: spacing)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

class UiPanelSaveRow extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback onSave;

  const UiPanelSaveRow({
    super.key,
    required this.hasChanges,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (hasChanges) const UiPanelUnsavedIndicator(),
        UiButton(
          label: '保存',
          icon: const Icon(Icons.check),
          size: UiButtonSize.small,
          onPressed: onSave,
        ),
      ],
    );
  }
}
