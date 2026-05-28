import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';

enum UiButtonVariant { primary, secondary, ghost, danger }

enum UiButtonSize { small, medium, large }

class UiButton extends StatefulWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final UiButtonVariant variant;
  final UiButtonSize size;
  final bool loading;
  final bool fullWidth;
  final Color? foregroundColor;

  const UiButton({
    super.key,
    this.label,
    this.icon,
    this.onPressed,
    this.variant = UiButtonVariant.primary,
    this.size = UiButtonSize.medium,
    this.loading = false,
    this.fullWidth = false,
    this.foregroundColor,
  }) : assert(
         label != null || icon != null,
         'UiButton needs a label, text, or icon.',
       );

  @override
  State<UiButton> createState() => _UiButtonState();
}

class _UiButtonState extends State<UiButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: widget.onPressed == null || _loading
            ? null
            : (_) => setState(() => _pressed = true),
        onTapUp: widget.onPressed == null || _loading
            ? null
            : (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _loading ? null : widget.onPressed,
        child: AnimatedScale(
          duration: UiMotion.fast,
          curve: UiMotion.standard,
          scale: _pressed ? 0.985 : 1,
          child: AnimatedContainer(
            duration: UiMotion.normal,
            curve: UiMotion.standard,
            padding: _padding(context),
            decoration: _decoration(context),
            child: Center(
              widthFactor: _fullWidth ? null : 1,
              heightFactor: 1,
              child: AnimatedDefaultTextStyle(
                duration: UiMotion.normal,
                style: TextStyle(
                  color: _foreground(context),
                  fontSize: widget.size == UiButtonSize.small ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
                child: _content(context),
              ),
            ),
          ),
        ),
      ),
    );

    if (_fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  String? get _label => widget.label;
  bool get _loading => widget.loading;
  bool get _fullWidth => widget.fullWidth;
  UiButtonVariant get _variant => widget.variant;

  Widget _content(BuildContext context) {
    if (_loading) {
      return SizedBox(
        width: widget.size == UiButtonSize.small ? 14 : 16,
        height: widget.size == UiButtonSize.small ? 14 : 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _foreground(context),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              size: widget.size == UiButtonSize.small ? 14 : 16,
              color: _foreground(context),
            ),
            child: widget.icon!,
          ),
          if (_label != null) const SizedBox(width: 8),
        ],
        if (_label != null) Text(_label!),
      ],
    );
  }

  EdgeInsetsGeometry _padding(BuildContext context) {
    final buttonTheme = context.uiTheme.components.button;
    switch (widget.size) {
      case UiButtonSize.small:
        return buttonTheme.smallPadding;
      case UiButtonSize.large:
        return buttonTheme.largePadding;
      case UiButtonSize.medium:
        return buttonTheme.mediumPadding;
    }
  }

  BoxDecoration _decoration(BuildContext context) {
    final theme = context.uiTheme;
    final radius = BorderRadius.circular(theme.components.button.radius);
    final disabled = widget.onPressed == null || _loading;
    final hover = _hovered && !disabled;

    switch (_variant) {
      case UiButtonVariant.primary:
        return BoxDecoration(
          gradient: disabled ? null : theme.primaryGradient,
          color: disabled ? theme.surfaceLighter : null,
          borderRadius: radius,
          boxShadow: _pressed
              ? theme.shadowXs
              : (hover ? theme.shadowMd : theme.shadowSm),
        );
      case UiButtonVariant.danger:
        return BoxDecoration(
          color: disabled ? theme.surfaceLighter : theme.error,
          borderRadius: radius,
          boxShadow: hover ? theme.shadowMd : theme.shadowSm,
        );
      case UiButtonVariant.secondary:
        return BoxDecoration(
          color: hover ? theme.surfaceLight : theme.surface,
          borderRadius: radius,
          border: Border.all(color: hover ? theme.borderHover : theme.border),
          boxShadow: hover ? theme.shadowMd : theme.shadowXs,
        );
      case UiButtonVariant.ghost:
        return BoxDecoration(
          color: hover
              ? theme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: radius,
        );
    }
  }

  Color _foreground(BuildContext context) {
    final theme = context.uiTheme;
    final disabled = widget.onPressed == null || _loading;
    if (disabled) {
      return theme.textTertiary;
    }
    final override = widget.foregroundColor;
    if (override != null) {
      return override;
    }
    switch (_variant) {
      case UiButtonVariant.primary:
      case UiButtonVariant.danger:
        return Colors.white;
      case UiButtonVariant.secondary:
        return theme.textPrimary;
      case UiButtonVariant.ghost:
        return theme.primary;
    }
  }
}
