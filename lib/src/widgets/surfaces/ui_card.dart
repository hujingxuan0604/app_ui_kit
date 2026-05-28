import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_spacing.dart';

enum UiCardVariant { elevated, outlined, filled }

class UiCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final bool interactive;
  final UiCardVariant variant;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Widget? leading;
  final Widget? trailing;
  final Color? borderColor;

  const UiCard({
    super.key,
    required this.child,
    this.onTap,
    this.selected = false,
    this.interactive = true,
    this.variant = UiCardVariant.elevated,
    this.padding = const EdgeInsets.all(UiSpacing.cardPadding),
    this.width,
    this.height,
    this.leading,
    this.trailing,
    this.borderColor,
  });

  @override
  State<UiCard> createState() => _UiCardState();
}

class _UiCardState extends State<UiCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedContainer(
      duration: UiMotion.normal,
      curve: UiMotion.standard,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: _decoration(context),
      child: widget.child,
    );

    if (widget.leading != null || widget.trailing != null) {
      child = Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 12),
          ],
          Expanded(child: child),
          if (widget.trailing != null) ...[
            const SizedBox(width: 12),
            widget.trailing!,
          ],
        ],
      );
    }

    if (_selected) {
      child = Stack(
        children: [
          child,
          Positioned(
            left: 0,
            top: 12,
            bottom: 12,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: context.uiTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      );
    }

    if (_interactive || widget.onTap != null) {
      child = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(onTap: widget.onTap, child: child),
      );
    }
    return child;
  }

  bool get _selected => widget.selected;
  bool get _interactive => widget.interactive;

  BoxDecoration _decoration(BuildContext context) {
    final theme = context.uiTheme;
    return BoxDecoration(
      color: _selected ? theme.surfaceElevated : theme.surface,
      borderRadius: BorderRadius.circular(theme.components.card.radius),
      border: _border(theme),
      boxShadow: _shadow(theme),
    );
  }

  Border _border(UiThemeData theme) {
    final color =
        widget.borderColor ??
        (_selected
            ? theme.primary
            : (_hovered ? theme.borderHover : theme.border));
    return Border.all(color: color, width: _selected ? 1.5 : 1);
  }

  List<BoxShadow>? _shadow(UiThemeData theme) {
    switch (widget.variant) {
      case UiCardVariant.elevated:
        return _hovered && _interactive ? theme.shadowMd : theme.shadowSm;
      case UiCardVariant.outlined:
      case UiCardVariant.filled:
        return null;
    }
  }
}

class UiListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;

  const UiListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return UiCard(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.listItemPaddingHorizontal,
        vertical: UiSpacing.listItemPaddingVertical,
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
