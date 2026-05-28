import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_colors.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';

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
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.chevron_left,
                size: 18,
                color: theme.textSecondary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
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
    final theme = context.uiTheme;
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UiRadii.md),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.surfaceLight,
          borderRadius: BorderRadius.circular(UiRadii.md),
          border: Border.all(color: borderColor ?? theme.border),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? theme.textSecondary,
        ),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return button;
    }

    return Tooltip(message: tooltip, child: button);
  }
}

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: expanded
            ? theme.primary
            : theme.surfaceLight.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: expanded ? theme.primary : theme.border.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        indexLabel!,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: expanded ? Colors.white : theme.textSecondary,
        ),
      ),
    );
  }

  Widget _editButton(UiThemeData theme) {
    return InkWell(
      onTap: onEditToggle,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: expanded
              ? theme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: expanded ? theme.primary : theme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              expanded ? Icons.expand_less : Icons.edit_outlined,
              size: 12,
              color: expanded ? theme.primary : theme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              expanded ? collapseLabel : editLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: expanded ? theme.primary : theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum UiPanelTagStyle { primary, secondary, outlined }

class UiPanelTag extends StatelessWidget {
  final IconData? icon;
  final String label;
  final UiPanelTagStyle style;
  final VoidCallback? onTap;

  const UiPanelTag({
    super.key,
    this.icon,
    required this.label,
    this.style = UiPanelTagStyle.secondary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: _backgroundColor(theme),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _borderColor(theme)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 10, color: _foregroundColor(theme)),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: style == UiPanelTagStyle.primary
                    ? FontWeight.w500
                    : FontWeight.normal,
                color: _foregroundColor(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _backgroundColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary.withValues(alpha: 0.1);
      case UiPanelTagStyle.secondary:
        return theme.surfaceLight.withValues(alpha: 0.6);
      case UiPanelTagStyle.outlined:
        return Colors.transparent;
    }
  }

  Color _borderColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary.withValues(alpha: 0.3);
      case UiPanelTagStyle.secondary:
        return theme.border.withValues(alpha: 0.5);
      case UiPanelTagStyle.outlined:
        return theme.border;
    }
  }

  Color _foregroundColor(UiThemeData theme) {
    switch (style) {
      case UiPanelTagStyle.primary:
        return theme.primary;
      case UiPanelTagStyle.secondary:
      case UiPanelTagStyle.outlined:
        return theme.textSecondary;
    }
  }
}

class UiPanelTagRow extends StatelessWidget {
  final List<UiPanelTag> tags;
  final double spacing;
  final Widget? trailing;

  const UiPanelTagRow({
    super.key,
    required this.tags,
    this.spacing = 6,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...tags.map(
          (tag) => Padding(
            padding: EdgeInsets.only(right: spacing),
            child: tag,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class UiStatTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const UiStatTag({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.textSecondary),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 11, color: theme.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class UiPanelInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const UiPanelInput({
    super.key,
    required this.label,
    required this.initialValue,
    this.hint = '',
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: theme.textTertiary)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: initialValue)
            ..selection = TextSelection.collapsed(offset: initialValue.length),
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 12, color: theme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: theme.textTertiary),
            filled: true,
            fillColor: theme.surfaceLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UiRadii.md),
              borderSide: BorderSide(color: theme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UiRadii.md),
              borderSide: BorderSide(color: theme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UiRadii.md),
              borderSide: BorderSide(color: theme.primary),
            ),
            isDense: true,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class UiPanelDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const UiPanelDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: theme.textTertiary)),
        const SizedBox(height: 4),
        SizedBox(
          height: 28,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 11)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: theme.textSecondary,
            ),
            dropdownColor: theme.surface,
            style: TextStyle(fontSize: 11, color: theme.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.surfaceLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiRadii.md),
                borderSide: BorderSide(color: theme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiRadii.md),
                borderSide: BorderSide(color: theme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiRadii.md),
                borderSide: BorderSide(color: theme.primary),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

class UiUnsavedIndicator extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;

  const UiUnsavedIndicator({super.key, this.text = '未保存', this.margin});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 10, color: theme.warning),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: theme.warning)),
        ],
      ),
    );
  }
}

class UiPanelEditArea extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const UiPanelEditArea({super.key, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class UiPanelFormRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const UiPanelFormRow({super.key, required this.children, this.spacing = 8});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((child) => Expanded(child: child))
          .toList()
          .expand((widget) => [widget, SizedBox(width: spacing)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

class UiPanelSaveRow extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback onSave;

  const UiPanelSaveRow({
    super.key,
    required this.hasChanges,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (hasChanges) const UiUnsavedIndicator(),
        ElevatedButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.check, size: 14),
          label: const Text('保存'),
          style: ElevatedButton.styleFrom(
            backgroundColor: UiColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiRadii.md),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

abstract class UiEditState<D> {
  bool hasChangesFrom(D original);
}

mixin UiPanelEditMixin<T extends StatefulWidget> on State<T> {
  int? expandedIndex;
  int? selectedIndex;
  final Map<int, bool> hasChanges = {};

  void checkUnsavedChanges(int index, VoidCallback onConfirm) {
    if (hasChanges[index] == true) {
      showUnsavedDialog(index, onConfirm);
      return;
    }
    onConfirm();
  }

  void showUnsavedDialog(int index, VoidCallback onConfirm) {
    final theme = context.uiTheme;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          '未保存的修改',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          getUnsavedMessage(index),
          style: TextStyle(color: theme.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              discardChanges(index);
              onConfirm();
            },
            child: Text('放弃修改', style: TextStyle(color: theme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('继续编辑', style: TextStyle(color: theme.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              saveChanges(index);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiRadii.lg),
              ),
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  String getUnsavedMessage(int index) => '当前内容有未保存的修改，是否保存？';

  void discardChanges(int index) {
    setState(() {
      expandedIndex = null;
      hasChanges[index] = false;
    });
  }

  void saveChanges(int index);

  void toggleExpanded(int index) {
    if (expandedIndex == index) {
      checkUnsavedChanges(index, () {
        setState(() {
          expandedIndex = null;
        });
      });
      return;
    }

    if (expandedIndex != null) {
      final previousIndex = expandedIndex!;
      checkUnsavedChanges(previousIndex, () {
        setState(() {
          expandedIndex = index;
        });
      });
      return;
    }

    setState(() {
      expandedIndex = index;
    });
  }

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

mixin UiSingleEditMixin<T extends StatefulWidget> on State<T> {
  bool isExpanded = false;
  bool hasChanges = false;

  void checkUnsavedChanges(VoidCallback onConfirm) {
    if (hasChanges) {
      showUnsavedDialog(onConfirm);
      return;
    }
    onConfirm();
  }

  void showUnsavedDialog(VoidCallback onConfirm) {
    final theme = context.uiTheme;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          '未保存的修改',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          getUnsavedMessage(),
          style: TextStyle(color: theme.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              discardChanges();
              onConfirm();
            },
            child: Text('放弃修改', style: TextStyle(color: theme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('继续编辑', style: TextStyle(color: theme.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              saveChanges();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiRadii.lg),
              ),
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  String getUnsavedMessage() => '当前内容有未保存的修改，是否保存？';

  void discardChanges() {
    setState(() {
      isExpanded = false;
      hasChanges = false;
    });
  }

  void saveChanges();

  void toggleExpanded() {
    if (isExpanded) {
      checkUnsavedChanges(() {
        setState(() {
          isExpanded = false;
        });
      });
      return;
    }

    setState(() {
      isExpanded = true;
    });
  }
}
