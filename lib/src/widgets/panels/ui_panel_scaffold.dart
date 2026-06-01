import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../buttons/ui_icon_action_button.dart';

enum UiPanelBorderSide { left, right, none }

class UiPanelScaffold extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final Widget body;
  final UiPanelBorderSide borderSide;

  const UiPanelScaffold({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.borderSide = UiPanelBorderSide.right,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      decoration: BoxDecoration(color: theme.surface, border: _border(theme)),
      child: Column(
        children: [
          UiPanelHeader(
            title: title,
            titleWidget: titleWidget,
            actions: actions,
            onClose: showCloseButton ? onClose : null,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Border? _border(UiThemeData theme) {
    final side = BorderSide(color: theme.border);
    switch (borderSide) {
      case UiPanelBorderSide.left:
        return Border(left: side);
      case UiPanelBorderSide.right:
        return Border(right: side);
      case UiPanelBorderSide.none:
        return null;
    }
  }
}

class UiPanelHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onClose;

  const UiPanelHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.space4,
        vertical: UiSpacing.space3,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Row(
        children: [
          if (titleWidget != null)
            Expanded(child: titleWidget!)
          else
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
          if (titleWidget == null) const Spacer(),
          if (actions != null) ...actions!,
          if (onClose != null)
            UiIconActionButton(
              icon: Icons.chevron_left,
              onPressed: onClose,
              size: 28,
              iconSize: 18,
              radius: UiRadii.md,
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
        ],
      ),
    );
  }
}

class UiPanelBody extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const UiPanelBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(UiSpacing.space4),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class UiPanelEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  const UiPanelEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0.0;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(UiSpacing.space4),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, size: 28, color: theme.primary),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: theme.textSecondary,
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 16),
                        action!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UiPanelSectionHeader extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;

  const UiPanelSectionHeader({
    super.key,
    this.title = '',
    this.titleWidget,
    this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child:
                titleWidget ??
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.textSecondary,
                  ),
                ),
          ),
          if (actions != null && actions!.isNotEmpty)
            ...actions!
                .expand((action) => [action, const SizedBox(width: 4)])
                .take(actions!.length * 2 - 1),
        ],
      ),
    );
  }
}

class UiPanelIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const UiPanelIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.size = 28,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final button = UiIconActionButton(
      icon: icon,
      onTap: onTap,
      size: size,
      iconSize: iconSize,
      radius: UiRadii.md,
      color: iconColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return button;
    }

    return Tooltip(message: tooltip, child: button);
  }
}
