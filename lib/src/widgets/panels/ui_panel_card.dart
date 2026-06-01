import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../buttons/ui_button.dart';
import '../display/ui_badge.dart';

class UiPanelCard extends StatelessWidget {
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;
  final Widget header;
  final Widget? collapsedContent;
  final Widget? expandedContent;
  final EdgeInsetsGeometry? padding;

  const UiPanelCard({
    super.key,
    this.selected = false,
    this.expanded = false,
    this.onTap,
    required this.header,
    this.collapsedContent,
    this.expandedContent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: expanded
              ? theme.primary.withValues(alpha: 0.08)
              : selected
              ? theme.primary.withValues(alpha: 0.05)
              : theme.surfaceLight,
          borderRadius: BorderRadius.circular(UiRadii.md),
          border: Border.all(
            color: expanded || selected ? theme.primary : theme.border,
          ),
        ),
        child: Stack(
          children: [
            if (selected && !expanded)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                if (!expanded && collapsedContent != null)
                  Padding(
                    padding:
                        padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: collapsedContent!,
                  ),
                if (expanded && expandedContent != null) expandedContent!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UiPanelCardHeader extends StatelessWidget {
  final String? indexLabel;
  final String title;
  final String? subtitle;
  final bool expanded;
  final bool showEditButton;
  final VoidCallback? onEditToggle;
  final Widget? leading;
  final String editLabel;
  final String collapseLabel;

  const UiPanelCardHeader({
    super.key,
    this.indexLabel,
    required this.title,
    this.subtitle,
    this.expanded = false,
    this.showEditButton = true,
    this.onEditToggle,
    this.leading,
    this.editLabel = 'Edit',
    this.collapseLabel = 'Collapse',
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          if (indexLabel != null) ...[
            _indexLabel(theme),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 10, color: theme.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (showEditButton) _editButton(theme),
        ],
      ),
    );
  }

  Widget _indexLabel(UiThemeData theme) {
    return UiBadge(
      label: indexLabel!,
      color: expanded ? theme.primary : theme.textSecondary,
      style: UiBadgeStyle(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: expanded
              ? theme.primary
              : theme.surfaceLight.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: expanded
                ? theme.primary
                : theme.border.withValues(alpha: 0.5),
          ),
        ),
        foregroundColor: expanded ? Colors.white : theme.textSecondary,
        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _editButton(UiThemeData theme) {
    return UiButton(
      label: expanded ? collapseLabel : editLabel,
      icon: Icon(expanded ? Icons.expand_less : Icons.edit_outlined),
      onPressed: onEditToggle,
      variant: expanded ? UiButtonVariant.ghost : UiButtonVariant.secondary,
      size: UiButtonSize.small,
      foregroundColor: expanded ? theme.primary : theme.textSecondary,
    );
  }
}
