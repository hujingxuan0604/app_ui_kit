import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../overlays/ui_overlay_shell.dart';

enum UiMenuTrigger { tap, contextMenu }

class UiMenuItem {
  final String? label;
  final Widget? icon;
  final String? shortcut;
  final VoidCallback? onSelected;
  final List<UiMenuItem> children;
  final bool enabled;
  final bool selected;
  final bool divider;

  const UiMenuItem({
    required String this.label,
    this.icon,
    this.shortcut,
    this.onSelected,
    this.children = const [],
    this.enabled = true,
    this.selected = false,
  }) : divider = false;

  const UiMenuItem.divider()
    : label = null,
      icon = null,
      shortcut = null,
      onSelected = null,
      children = const [],
      enabled = false,
      selected = false,
      divider = true;

  bool get hasChildren => children.isNotEmpty;
}

class UiMenu extends StatefulWidget {
  final Widget child;
  final List<UiMenuItem> items;
  final bool enabled;
  final double width;
  final double submenuWidth;
  final Offset offset;
  final UiMenuTrigger trigger;
  final ValueChanged<bool>? onOpenChanged;

  const UiMenu({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
    this.width = 220,
    this.submenuWidth = 260,
    this.offset = const Offset(0, 6),
    this.trigger = UiMenuTrigger.tap,
    this.onOpenChanged,
  });

  @override
  State<UiMenu> createState() => _UiMenuState();
}

class _UiMenuState extends State<UiMenu> {
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  List<_OpenMenu> _openMenus = const [];

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _debugValidateMenuDepth(widget.items),
      'UiMenu supports at most three levels.',
    );

    return GestureDetector(
      key: _anchorKey,
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled && widget.trigger == UiMenuTrigger.tap
          ? _toggleMenu
          : null,
      onSecondaryTapDown:
          widget.enabled && widget.trigger == UiMenuTrigger.contextMenu
          ? _showContextMenu
          : null,
      onLongPressStart:
          widget.enabled && widget.trigger == UiMenuTrigger.contextMenu
          ? _showLongPressMenu
          : null,
      child: widget.child,
    );
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _showRootMenu();
    } else {
      _hideMenu();
    }
  }

  void _showRootMenu() {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    final anchorBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlayBox == null || anchorBox == null) {
      return;
    }

    final anchorTopLeft = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final desiredPosition = Offset(
      anchorTopLeft.dx + widget.offset.dx,
      anchorTopLeft.dy + anchorBox.size.height + widget.offset.dy,
    );
    final position = _fitMenuToOverlay(
      desiredPosition,
      widget.width,
      _estimateMenuHeight(widget.items),
      overlayBox.size,
    );

    _showMenuAt(position);
  }

  void _showContextMenu(TapDownDetails details) {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) {
      return;
    }

    final desiredPosition =
        overlayBox.globalToLocal(details.globalPosition) + widget.offset;
    final position = _fitMenuToOverlay(
      desiredPosition,
      widget.width,
      _estimateMenuHeight(widget.items),
      overlayBox.size,
    );
    _showMenuAt(position);
  }

  void _showLongPressMenu(LongPressStartDetails details) {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) {
      return;
    }

    final desiredPosition =
        overlayBox.globalToLocal(details.globalPosition) + widget.offset;
    final position = _fitMenuToOverlay(
      desiredPosition,
      widget.width,
      _estimateMenuHeight(widget.items),
      overlayBox.size,
    );
    _showMenuAt(position);
  }

  void _showMenuAt(Offset position) {
    final wasOpen = _overlayEntry != null;
    _overlayEntry?.remove();
    _openMenus = [_OpenMenu(items: widget.items, level: 0, position: position)];
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_overlayEntry!);
    if (!wasOpen) {
      widget.onOpenChanged?.call(true);
    }
    setState(() {});
  }

  Widget _buildOverlay(BuildContext context) {
    return UiOverlayShell(
      stackKey: _overlayKey,
      onDismiss: _hideMenu,
      children: [
        for (final menu in _openMenus)
          Positioned(
            left: menu.position.dx,
            top: menu.position.dy,
            child: _UiMenuPanel(
              width: menu.level == 0 ? widget.width : widget.submenuWidth,
              items: menu.items,
              level: menu.level,
              onHoverItem: _openSubmenu,
              onTapItem: _handleItemTap,
            ),
          ),
      ],
    );
  }

  void _handleItemTap(UiMenuItem item, int level, BuildContext rowContext) {
    if (!item.enabled || item.divider) {
      return;
    }
    if (item.hasChildren) {
      _openSubmenu(item, level, rowContext);
      return;
    }
    item.onSelected?.call();
    _hideMenu();
  }

  void _openSubmenu(UiMenuItem item, int level, BuildContext rowContext) {
    if (!item.enabled || item.divider) {
      return;
    }
    if (!item.hasChildren) {
      _setOpenMenus(_openMenus.take(level + 1).toList());
      return;
    }

    final overlayBox =
        _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    final rowBox = rowContext.findRenderObject() as RenderBox?;
    if (overlayBox == null || rowBox == null) {
      return;
    }

    final rowTopLeft = rowBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final position = _fitSubmenuToOverlay(
      rowTopLeft,
      rowBox.size,
      widget.submenuWidth,
      _estimateMenuHeight(item.children),
      overlayBox.size,
    );

    final nextMenus = [
      ..._openMenus.take(level + 1),
      _OpenMenu(items: item.children, level: level + 1, position: position),
    ];
    _setOpenMenus(nextMenus);
  }

  Offset _fitSubmenuToOverlay(
    Offset rowTopLeft,
    Size rowSize,
    double width,
    double height,
    Size overlaySize,
  ) {
    const margin = UiSpacing.space2;
    final desiredLeft = rowTopLeft.dx + rowSize.width - UiSpacing.space1;
    final left = desiredLeft + width > overlaySize.width - margin
        ? math.max(margin, rowTopLeft.dx - width + UiSpacing.space1)
        : desiredLeft;
    final top =
        rowTopLeft.dy - UiSpacing.space1 + height > overlaySize.height - margin
        ? math.max(margin, overlaySize.height - height - margin)
        : math.max(margin, rowTopLeft.dy - UiSpacing.space1);
    return Offset(left, top);
  }

  void _setOpenMenus(List<_OpenMenu> menus) {
    _openMenus = menus;
    _overlayEntry?.markNeedsBuild();
  }

  void _hideMenu() {
    final wasOpen = _overlayEntry != null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _openMenus = const [];
    if (wasOpen) {
      widget.onOpenChanged?.call(false);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Offset _fitMenuToOverlay(
    Offset desired,
    double width,
    double height,
    Size overlaySize,
  ) {
    const margin = UiSpacing.space2;
    final left = desired.dx + width > overlaySize.width - margin
        ? math.max(margin, desired.dx - width + UiSpacing.space1)
        : math.max(margin, desired.dx);
    final top = desired.dy + height > overlaySize.height - margin
        ? math.max(margin, overlaySize.height - height - margin)
        : math.max(margin, desired.dy);
    return Offset(left, top);
  }

  double _estimateMenuHeight(List<UiMenuItem> items) {
    return UiSpacing.space2 +
        items.fold<double>(
          0,
          (height, item) =>
              height + (item.divider ? 9 : _UiMenuPanel.rowHeight),
        );
  }

  bool _debugValidateMenuDepth(List<UiMenuItem> items, [int depth = 1]) {
    if (depth > 3) {
      return false;
    }
    for (final item in items) {
      if (item.children.isNotEmpty &&
          !_debugValidateMenuDepth(item.children, depth + 1)) {
        return false;
      }
    }
    return true;
  }
}

class _OpenMenu {
  final List<UiMenuItem> items;
  final int level;
  final Offset position;

  const _OpenMenu({
    required this.items,
    required this.level,
    required this.position,
  });
}

class _UiMenuPanel extends StatelessWidget {
  static const double rowHeight = 32;

  final double width;
  final List<UiMenuItem> items;
  final int level;
  final void Function(UiMenuItem item, int level, BuildContext rowContext)
  onHoverItem;
  final void Function(UiMenuItem item, int level, BuildContext rowContext)
  onTapItem;

  const _UiMenuPanel({
    required this.width,
    required this.items,
    required this.level,
    required this.onHoverItem,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return UiFloatingPanel(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in items)
            item.divider
                ? const _UiMenuDivider()
                : _UiMenuRow(
                    item: item,
                    level: level,
                    onHoverItem: onHoverItem,
                    onTapItem: onTapItem,
                  ),
        ],
      ),
    );
  }
}

class _UiMenuRow extends StatefulWidget {
  final UiMenuItem item;
  final int level;
  final void Function(UiMenuItem item, int level, BuildContext rowContext)
  onHoverItem;
  final void Function(UiMenuItem item, int level, BuildContext rowContext)
  onTapItem;

  const _UiMenuRow({
    required this.item,
    required this.level,
    required this.onHoverItem,
    required this.onTapItem,
  });

  @override
  State<_UiMenuRow> createState() => _UiMenuRowState();
}

class _UiMenuRowState extends State<_UiMenuRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final enabled = widget.item.enabled;
    final textColor = enabled ? theme.textPrimary : theme.textTertiary;
    final secondaryColor = enabled ? theme.textSecondary : theme.textTertiary;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHoverItem(widget.item, widget.level, context);
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTapItem(widget.item, widget.level, context),
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.standard,
          height: _UiMenuPanel.rowHeight,
          margin: const EdgeInsets.symmetric(horizontal: UiSpacing.space1),
          padding: const EdgeInsets.symmetric(horizontal: UiSpacing.space3),
          decoration: BoxDecoration(
            color: _hovered && enabled
                ? theme.surfaceLighter
                : Colors.transparent,
            borderRadius: BorderRadius.circular(UiRadii.sm),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                child: _MenuLeadingIcon(item: widget.item, color: textColor),
              ),
              const SizedBox(width: UiSpacing.space2),
              Expanded(
                child: Text(
                  widget.item.label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: widget.item.selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
              if (widget.item.shortcut != null) ...[
                const SizedBox(width: UiSpacing.space3),
                Text(
                  widget.item.shortcut!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondaryColor, fontSize: 12),
                ),
              ],
              if (widget.item.hasChildren) ...[
                const SizedBox(width: UiSpacing.space2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: UiSpacing.iconMd,
                  color: secondaryColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuLeadingIcon extends StatelessWidget {
  final UiMenuItem item;
  final Color color;

  const _MenuLeadingIcon({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    if (item.icon != null) {
      return IconTheme(
        data: IconThemeData(size: UiSpacing.iconSm, color: color),
        child: item.icon!,
      );
    }
    if (item.selected) {
      return Icon(Icons.check_rounded, size: UiSpacing.iconSm, color: color);
    }
    return const SizedBox.shrink();
  }
}

class _UiMenuDivider extends StatelessWidget {
  const _UiMenuDivider();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UiSpacing.space1),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.border.withValues(alpha: 0.72),
      ),
    );
  }
}
