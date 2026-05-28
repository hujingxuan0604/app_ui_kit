import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';

class UiSelectOption<T> {
  final T value;
  final String label;
  final Widget? icon;
  final bool enabled;

  const UiSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class UiSelect<T> extends StatefulWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<UiSelectOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? errorText;
  final bool enabled;
  final Widget? prefix;
  final double? menuMaxHeight;

  const UiSelect({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.options,
    this.onChanged,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.prefix,
    this.menuMaxHeight,
  });

  @override
  State<UiSelect<T>> createState() => _UiSelectState<T>();
}

class _UiSelectState<T> extends State<UiSelect<T>> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    assert(
      widget.value == null ||
          widget.options
                  .where((option) => option.value == widget.value)
                  .length ==
              1,
      'UiSelect value must match exactly one option.',
    );
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
        Focus(
          onFocusChange: (focused) => setState(() => _focused = focused),
          child: AnimatedContainer(
            duration: UiMotion.normal,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                theme.components.input.radius,
              ),
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
            child: DropdownButtonFormField<T>(
              initialValue: widget.value,
              items: widget.options.map(_item).toList(),
              selectedItemBuilder: (context) {
                return widget.options.map((option) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              onChanged: widget.enabled ? widget.onChanged : null,
              validator: widget.validator,
              menuMaxHeight: widget.menuMaxHeight,
              isExpanded: true,
              dropdownColor: theme.surface,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: theme.textTertiary,
              ),
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.hintText,
                errorText: widget.errorText,
                hintStyle: TextStyle(color: theme.textTertiary),
                filled: true,
                fillColor: _focused ? theme.surface : theme.surfaceLight,
                prefixIcon: widget.prefix == null
                    ? null
                    : IconTheme(
                        data: IconThemeData(
                          color: hasError
                              ? theme.error
                              : (_focused ? theme.primary : theme.textTertiary),
                        ),
                        child: widget.prefix!,
                      ),
                contentPadding: theme.components.input.contentPadding,
                border: _border(theme, theme.border),
                enabledBorder: _border(theme, theme.border),
                focusedBorder: _border(theme, theme.primary, width: 1.5),
                errorBorder: _border(theme, theme.error),
                focusedErrorBorder: _border(theme, theme.error, width: 1.5),
                disabledBorder: _border(theme, theme.border),
                errorStyle: TextStyle(color: theme.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  DropdownMenuItem<T> _item(UiSelectOption<T> option) {
    return DropdownMenuItem<T>(
      value: option.value,
      enabled: option.enabled,
      child: _UiSelectOptionContent(option: option),
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
}

class _UiSelectOptionContent<T> extends StatelessWidget {
  final UiSelectOption<T> option;

  const _UiSelectOptionContent({required this.option});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (option.icon != null) ...[
          IconTheme(
            data: IconThemeData(size: 16, color: theme.textTertiary),
            child: option.icon!,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
