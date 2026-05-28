import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_radii.dart';
import '../navigation/ui_menu.dart';

class UiMenuButton extends StatefulWidget {
  final Object icon;
  final List<UiMenuItem> items;
  final String? tooltip;
  final bool enabled;
  final bool selected;
  final double size;
  final double? iconSize;
  final double radius;
  final double menuWidth;
  final double submenuWidth;
  final Offset offset;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedColor;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;

  const UiMenuButton({
    super.key,
    this.icon = Icons.more_horiz_rounded,
    required this.items,
    this.tooltip,
    this.enabled = true,
    this.selected = false,
    this.size = 32,
    this.iconSize,
    this.radius = UiRadii.lg,
    this.menuWidth = 220,
    this.submenuWidth = 260,
    this.offset = const Offset(0, 6),
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.selectedColor,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
  });

  factory UiMenuButton.filter({
    Key? key,
    required List<UiMenuItem> items,
    String tooltip = '筛选',
    bool enabled = true,
    bool selected = false,
    double size = 32,
    double? iconSize,
    double radius = UiRadii.lg,
    double menuWidth = 220,
    double submenuWidth = 260,
    Offset offset = const Offset(0, 6),
  }) {
    return UiMenuButton(
      key: key,
      icon: Icons.filter_list_rounded,
      items: items,
      tooltip: tooltip,
      enabled: enabled,
      selected: selected,
      size: size,
      iconSize: iconSize,
      radius: radius,
      menuWidth: menuWidth,
      submenuWidth: submenuWidth,
      offset: offset,
    );
  }

  @override
  State<UiMenuButton> createState() => _UiMenuButtonState();
}

class _UiMenuButtonState extends State<UiMenuButton> {
  bool _hovered = false;
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final menu = UiMenu(
      enabled: widget.enabled,
      items: widget.items,
      width: widget.menuWidth,
      submenuWidth: widget.submenuWidth,
      offset: widget.offset,
      onOpenChanged: (open) => setState(() => _menuOpen = open),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: UiMotion.normal,
          curve: UiMotion.standard,
          width: widget.size,
          height: widget.size,
          decoration: _decoration(context),
          child: Center(child: _icon(context)),
        ),
      ),
    );
    final menuButton = widget.tooltip == null
        ? menu
        : Tooltip(message: widget.tooltip!, child: menu);

    return Semantics(
      button: true,
      enabled: widget.enabled,
      toggled: _active,
      label: widget.tooltip,
      child: menuButton,
    );
  }

  bool get _active => widget.selected || _menuOpen;

  Widget _icon(BuildContext context) {
    final iconColor = _foreground(context);
    final iconSize = widget.iconSize ?? widget.size * 0.52;
    final iconTheme = IconThemeData(size: iconSize, color: iconColor);

    return IconTheme(
      data: iconTheme,
      child: widget.icon is IconData
          ? Icon(widget.icon as IconData)
          : widget.icon as Widget,
    );
  }

  BoxDecoration _decoration(BuildContext context) {
    final theme = context.uiTheme;
    final disabled = !widget.enabled;
    final active = _active && !disabled;
    final hovered = _hovered && !disabled;
    final background = active
        ? widget.selectedBackgroundColor ?? theme.surfaceLighter
        : widget.backgroundColor ?? theme.surfaceLight;
    final border = active
        ? widget.selectedBorderColor ?? theme.primary
        : widget.borderColor ?? (hovered ? theme.borderHover : theme.border);

    return BoxDecoration(
      color: disabled ? theme.surfaceLighter : background,
      borderRadius: BorderRadius.circular(widget.radius),
      border: Border.all(color: disabled ? theme.border : border),
      boxShadow: active || hovered ? theme.shadowXs : const [],
    );
  }

  Color _foreground(BuildContext context) {
    final theme = context.uiTheme;
    if (!widget.enabled) {
      return theme.textTertiary;
    }
    if (_active) {
      return widget.selectedColor ?? theme.primary;
    }
    return widget.color ?? theme.textSecondary;
  }
}
