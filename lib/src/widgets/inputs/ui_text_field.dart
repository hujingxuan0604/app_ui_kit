import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';

enum UiTextFieldSize { compact, medium }

enum UiTextFieldLabelPosition { outside, floating }

enum UiTextFieldLayout { intrinsic, fill }

class UiTextField extends StatefulWidget {
  final String? label;
  final UiTextFieldLabelPosition labelPosition;
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
  final UiTextFieldSize size;
  final UiTextFieldLayout layout;

  const UiTextField({
    super.key,
    this.label,
    this.labelPosition = UiTextFieldLabelPosition.outside,
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
    this.size = UiTextFieldSize.medium,
    this.layout = UiTextFieldLayout.intrinsic,
  }) : assert(
         controller == null || initialValue == null,
         'Use either controller or initialValue, not both.',
       );

  @override
  State<UiTextField> createState() => _UiTextFieldState();
}

class _UiTextFieldState extends State<UiTextField> {
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
    final metrics = _UiTextFieldMetrics.forSize(widget.size, theme);
    final labelStyle = TextStyle(
      fontSize: metrics.labelFontSize,
      fontWeight: FontWeight.w600,
      color: hasError
          ? theme.error
          : (_focused ? theme.primary : theme.textSecondary),
    );
    final field = _buildField(context, theme, metrics, labelStyle);
    if (_layout == UiTextFieldLayout.fill) {
      return _FillLayout(
        field: field,
        outsideLabel: _showsOutsideLabel
            ? Text(widget.label!, style: labelStyle)
            : null,
        labelGap: metrics.labelGap,
        labelExtent: metrics.labelFontSize * 1.4,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showsOutsideLabel) ...[
          Text(widget.label!, style: labelStyle),
          SizedBox(height: metrics.labelGap),
        ],
        field,
      ],
    );
  }

  Widget _buildField(
    BuildContext context,
    UiThemeData theme,
    _UiTextFieldMetrics metrics,
    TextStyle labelStyle,
  ) {
    final hasError = _hasError;
    return AnimatedContainer(
      duration: UiMotion.normal,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.components.textField.radius),
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
        expands: _expandsTextField,
        minLines: _effectiveMinLines,
        maxLines: _effectiveMaxLines,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textAlignVertical: _expandsTextField ? TextAlignVertical.top : null,
        style: TextStyle(
          color: theme.textPrimary,
          fontSize: metrics.inputFontSize,
        ),
        decoration: InputDecoration(
          isDense: metrics.isDense,
          labelText: _showsFloatingLabel ? widget.label : null,
          labelStyle: labelStyle,
          floatingLabelStyle: labelStyle,
          floatingLabelBehavior: _showsFloatingLabel
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          hintText: widget.hintText,
          errorText: widget.errorText,
          hintStyle: TextStyle(
            color: theme.textTertiary,
            fontSize: metrics.inputFontSize,
          ),
          filled: true,
          fillColor: _focused ? theme.surface : theme.surfaceLight,
          constraints: BoxConstraints(minHeight: metrics.fieldMinHeight),
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
          prefixIconConstraints: BoxConstraints(
            minWidth: metrics.iconSlotSize,
            minHeight: metrics.fieldMinHeight,
          ),
          suffixIcon: _suffixIcon(theme, metrics),
          suffixIconConstraints: BoxConstraints(
            minWidth: metrics.iconSlotSize,
            minHeight: metrics.fieldMinHeight,
          ),
          contentPadding: metrics.contentPadding,
          border: _border(theme, theme.border),
          enabledBorder: _border(theme, theme.border),
          focusedBorder: _border(theme, theme.primary, width: 1.5),
          errorBorder: _border(theme, theme.error),
          focusedErrorBorder: _border(theme, theme.error, width: 1.5),
          errorStyle: TextStyle(color: theme.error),
        ),
      ),
    );
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  Widget? _suffixIcon(UiThemeData theme, _UiTextFieldMetrics metrics) {
    final icons = <Widget>[];
    if (_password) {
      icons.add(
        GestureDetector(
          onTap: () => setState(() => _obscure = !_obscure),
          child: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: metrics.iconSize,
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
      borderRadius: BorderRadius.circular(theme.components.textField.radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  bool get _password => widget.obscureText;

  UiTextFieldLayout get _layout => widget.layout;

  bool get _expandsTextField =>
      _layout == UiTextFieldLayout.fill && !_password && widget.maxLines != 1;

  int? get _effectiveMinLines => _expandsTextField ? null : widget.minLines;

  int? get _effectiveMaxLines => _expandsTextField ? null : widget.maxLines;

  Widget? get _prefixIcon => widget.prefix;
  Widget? get _suffixIconWidget => widget.suffix;

  bool get _showsOutsideLabel =>
      widget.label != null &&
      widget.labelPosition == UiTextFieldLabelPosition.outside;

  bool get _showsFloatingLabel =>
      widget.label != null &&
      widget.labelPosition == UiTextFieldLabelPosition.floating;

  void _handleSubmitted(String value) {
    final callback = widget.onSubmitted;
    if (callback is ValueChanged<String>) {
      callback(value);
    } else if (callback is VoidCallback) {
      callback();
    }
  }
}

class _FillLayout extends StatelessWidget {
  final Widget field;
  final Widget? outsideLabel;
  final double labelGap;
  final double labelExtent;

  const _FillLayout({
    required this.field,
    required this.outsideLabel,
    required this.labelGap,
    required this.labelExtent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boundedWidth = constraints.hasBoundedWidth;
        final boundedHeight = constraints.hasBoundedHeight;
        if (!boundedHeight) {
          return SizedBox(
            width: boundedWidth ? double.infinity : null,
            child: field,
          );
        }

        if (outsideLabel == null) {
          return SizedBox(
            width: boundedWidth ? double.infinity : null,
            height: double.infinity,
            child: field,
          );
        }

        final reservedTop = (labelExtent + labelGap).clamp(
          0.0,
          constraints.maxHeight,
        );
        return SizedBox(
          width: boundedWidth ? double.infinity : null,
          height: double.infinity,
          child: ClipRect(
            child: Stack(
              children: [
                Positioned(left: 0, top: 0, right: 0, child: outsideLabel!),
                Positioned.fill(top: reservedTop, child: field),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UiTextFieldMetrics {
  final double labelFontSize;
  final double inputFontSize;
  final double labelGap;
  final double iconSize;
  final double iconSlotSize;
  final double fieldMinHeight;
  final bool isDense;
  final EdgeInsetsGeometry contentPadding;

  const _UiTextFieldMetrics({
    required this.labelFontSize,
    required this.inputFontSize,
    required this.labelGap,
    required this.iconSize,
    required this.iconSlotSize,
    required this.fieldMinHeight,
    required this.isDense,
    required this.contentPadding,
  });

  factory _UiTextFieldMetrics.forSize(UiTextFieldSize size, UiThemeData theme) {
    switch (size) {
      case UiTextFieldSize.compact:
        return const _UiTextFieldMetrics(
          labelFontSize: 10,
          inputFontSize: 12,
          labelGap: 4,
          iconSize: 16,
          iconSlotSize: 32,
          fieldMinHeight: 32,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        );
      case UiTextFieldSize.medium:
        return _UiTextFieldMetrics(
          labelFontSize: 12,
          inputFontSize: 14,
          labelGap: 8,
          iconSize: 18,
          iconSlotSize: 40,
          fieldMinHeight: 42,
          isDense: false,
          contentPadding: theme.components.textField.contentPadding,
        );
    }
  }
}
