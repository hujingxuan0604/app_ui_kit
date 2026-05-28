import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';

class UiInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Object? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const UiInput({
    super.key,
    this.label,
    this.hintText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  }) : assert(
         controller == null || initialValue == null,
         'Use either controller or initialValue, not both.',
       );

  @override
  State<UiInput> createState() => _UiInputState();
}

class _UiInputState extends State<UiInput> {
  late final FocusNode _focusNode;
  bool _focused = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final hasError = _hasError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: hasError
                  ? theme.error
                  : (_focused ? theme.primary : theme.textSecondary),
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: UiMotion.normal,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.components.input.radius),
            boxShadow: _focused && !hasError
                ? [
                    BoxShadow(
                      color: theme.primary.withValues(
                        alpha: theme.isDark ? 0.24 : 0.12,
                      ),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onFieldSubmitted: _handleSubmitted,
            validator: widget.validator,
            obscureText: _password ? _obscure : false,
            minLines: _password ? 1 : _minLines,
            maxLines: _password ? 1 : _maxLines,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            style: TextStyle(color: theme.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText,
              hintStyle: TextStyle(color: theme.textTertiary),
              filled: true,
              fillColor: _focused ? theme.surface : theme.surfaceLight,
              prefixIcon: _prefixIcon == null
                  ? null
                  : IconTheme(
                      data: IconThemeData(
                        color: hasError
                            ? theme.error
                            : (_focused ? theme.primary : theme.textTertiary),
                      ),
                      child: _prefixIcon!,
                    ),
              suffixIcon: _suffixIcon(theme),
              contentPadding: theme.components.input.contentPadding,
              border: _border(theme, theme.border),
              enabledBorder: _border(theme, theme.border),
              focusedBorder: _border(theme, theme.primary, width: 1.5),
              errorBorder: _border(theme, theme.error),
              focusedErrorBorder: _border(theme, theme.error, width: 1.5),
              errorStyle: TextStyle(color: theme.error),
            ),
          ),
        ),
      ],
    );
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  Widget? _suffixIcon(UiThemeData theme) {
    final icons = <Widget>[];
    if (_password) {
      icons.add(
        GestureDetector(
          onTap: () => setState(() => _obscure = !_obscure),
          child: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18,
            color: _hasError
                ? theme.error
                : (_focused ? theme.primary : theme.textTertiary),
          ),
        ),
      );
    }
    if (_suffixIconWidget != null) {
      icons.add(
        IconTheme(
          data: IconThemeData(
            color: _hasError ? theme.error : theme.textTertiary,
          ),
          child: _suffixIconWidget!,
        ),
      );
    }
    if (icons.isEmpty) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < icons.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            icons[index],
          ],
        ],
      ),
    );
  }

  OutlineInputBorder _border(
    UiThemeData theme,
    Color color, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.components.input.radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  bool get _password => widget.obscureText;

  int get _minLines => widget.minLines;

  int get _maxLines => widget.maxLines;

  Widget? get _prefixIcon => widget.prefix;
  Widget? get _suffixIconWidget => widget.suffix;

  void _handleSubmitted(String value) {
    final callback = widget.onSubmitted;
    if (callback is ValueChanged<String>) {
      callback(value);
    } else if (callback is VoidCallback) {
      callback();
    }
  }
}
