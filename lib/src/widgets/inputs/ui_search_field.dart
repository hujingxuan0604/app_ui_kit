import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_icon_action_button.dart';
import 'ui_text_field.dart';

class UiSearchField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;
  final bool clearable;
  final UiTextFieldSize size;
  final UiTextFieldLayout layout;

  const UiSearchField({
    super.key,
    this.hintText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
    this.clearable = true,
    this.size = UiTextFieldSize.medium,
    this.layout = UiTextFieldLayout.intrinsic,
  }) : assert(
         controller == null || initialValue == null,
         'Use either controller or initialValue, not both.',
       );

  @override
  State<UiSearchField> createState() => _UiSearchFieldState();
}

class _UiSearchFieldState extends State<UiSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant UiSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChanged);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
      _controller.addListener(_handleTextChanged);
    } else if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return UiTextField(
      controller: _controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      size: widget.size,
      layout: widget.layout,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      prefix: const Icon(Icons.search_rounded),
      suffix: _showClearButton
          ? UiIconActionButton(
              icon: Icons.close_rounded,
              size: widget.size == UiTextFieldSize.compact ? 18 : 22,
              iconSize: widget.size == UiTextFieldSize.compact ? 12 : 14,
              radius: 999,
              color: theme.textTertiary,
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              onPressed: _clear,
            )
          : null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }

  bool get _showClearButton =>
      widget.clearable && widget.enabled && _controller.text.isNotEmpty;

  void _clear() {
    if (_controller.text.isEmpty) {
      return;
    }
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }
}
