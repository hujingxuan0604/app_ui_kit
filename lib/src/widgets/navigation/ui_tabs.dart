import 'package:flutter/material.dart';

import '../../theme/ui_component_theme.dart';
import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_spacing.dart';

enum UiTabsSize { small, medium, large }

enum UiTabsStyle { pill, segmented, underline }

class UiTabsController extends ValueNotifier<int> {
  UiTabsController(super.value);

  int get selectedIndex => value;

  set selectedIndex(int nextIndex) => value = nextIndex;
}

@immutable
class UiTabItem {
  final String label;
  final Widget? leading;
  final IconData? icon;
  final String? badgeLabel;
  final Widget? badge;
  final Color? badgeColor;
  final Widget? content;
  final String? semanticsLabel;

  const UiTabItem({
    required this.label,
    this.leading,
    this.icon,
    this.badgeLabel,
    this.badge,
    this.badgeColor,
    this.content,
    this.semanticsLabel,
  });
}

class UiTabs extends StatelessWidget {
  final int? selectedIndex;
  final UiTabsController? controller;
  final List<String> items;
  final List<UiTabItem> tabItems;
  final ValueChanged<int>? onChanged;
  final UiTabsSize size;
  final UiTabsStyle style;
  final bool fullWidth;
  final double? width;
  final EdgeInsetsGeometry? contentPadding;
  final double? contentMinHeight;
  final BoxDecoration? contentDecoration;
  final String? semanticsLabel;

  const UiTabs({
    super.key,
    this.selectedIndex,
    this.controller,
    this.items = const [],
    this.tabItems = const [],
    this.onChanged,
    this.size = UiTabsSize.medium,
    this.style = UiTabsStyle.pill,
    this.fullWidth = true,
    this.width,
    this.contentPadding,
    this.contentMinHeight,
    this.contentDecoration,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      items.isNotEmpty || tabItems.isNotEmpty,
      'UiTabs needs at least one item.',
    );
    assert(
      items.isEmpty || tabItems.isEmpty,
      'UiTabs accepts either items or tabItems, not both.',
    );
    assert(
      selectedIndex != null || controller != null,
      'UiTabs needs either a selectedIndex or a controller.',
    );
    assert(
      selectedIndex == null || controller == null,
      'UiTabs accepts either selectedIndex or controller, not both.',
    );
    if (controller != null) {
      return ValueListenableBuilder<int>(
        valueListenable: controller!,
        builder: (context, currentIndex, _) {
          return _buildTabs(context, currentIndex);
        },
      );
    }
    return _buildTabs(context, selectedIndex!);
  }

  Widget _buildTabs(BuildContext context, int currentIndex) {
    final resolvedItems = _resolvedItems;
    assert(
      currentIndex >= 0 && currentIndex < resolvedItems.length,
      'UiTabs selected index must be within items.',
    );

    final tabBar = _buildTabBar(context, currentIndex, resolvedItems);
    final selectedContent = resolvedItems[currentIndex].content;
    final content = selectedContent == null
        ? tabBar
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: fullWidth
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.start,
            children: [
              tabBar,
              SizedBox(height: context.uiTheme.components.tabs.contentGap),
              _contentArea(context, selectedContent),
            ],
          );

    final constrained = width == null
        ? content
        : SizedBox(width: width, child: content);
    final wrapped = fullWidth
        ? SizedBox(width: width ?? double.infinity, child: constrained)
        : constrained;

    return Semantics(label: semanticsLabel, container: true, child: wrapped);
  }

  Widget _buildTabBar(
    BuildContext context,
    int currentIndex,
    List<UiTabItem> resolvedItems,
  ) {
    final theme = context.uiTheme;
    final tabsTheme = theme.components.tabs;
    return Container(
      height: _height(tabsTheme),
      padding: _barPadding(tabsTheme),
      decoration: _barDecoration(context),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (var index = 0; index < resolvedItems.length; index++) ...[
            if (index > 0 && style != UiTabsStyle.underline)
              const SizedBox(width: UiSpacing.space1),
            _item(context, resolvedItems[index], index, currentIndex),
          ],
        ],
      ),
    );
  }

  Widget _contentArea(BuildContext context, Widget child) {
    final tabsTheme = context.uiTheme.components.tabs;
    return Container(
      constraints: BoxConstraints(
        minHeight: contentMinHeight ?? tabsTheme.contentMinHeight,
      ),
      padding: contentPadding ?? tabsTheme.contentPadding,
      decoration: contentDecoration ?? _contentDecoration(context),
      child: child,
    );
  }

  BoxDecoration _contentDecoration(BuildContext context) {
    final theme = context.uiTheme;
    final tabsTheme = theme.components.tabs;
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(tabsTheme.contentRadius),
      border: Border.all(color: theme.border.withValues(alpha: 0.7)),
    );
  }

  Widget _item(
    BuildContext context,
    UiTabItem item,
    int index,
    int currentIndex,
  ) {
    final tabsTheme = context.uiTheme.components.tabs;
    final itemHeight = _itemHeight(context, tabsTheme);
    final child = _UiTabButton(
      item: item,
      selected: index == currentIndex,
      size: size,
      style: style,
      height: itemHeight,
      minWidth: fullWidth ? 0 : tabsTheme.itemMinWidth,
      onTap: onChanged != null || controller != null
          ? () {
              if (index != currentIndex) {
                controller?.value = index;
                onChanged?.call(index);
              }
            }
          : null,
    );
    return fullWidth ? Expanded(child: child) : child;
  }

  double _itemHeight(BuildContext context, UiTabsTheme tabsTheme) {
    final barHeight = _height(tabsTheme);
    final verticalPadding = _barPadding(
      tabsTheme,
    ).resolve(Directionality.of(context)).vertical;
    final itemHeight = barHeight - verticalPadding;
    return itemHeight > 0 ? itemHeight : barHeight;
  }

  List<UiTabItem> get _resolvedItems {
    if (tabItems.isNotEmpty) {
      return tabItems;
    }
    return [for (final item in items) UiTabItem(label: item)];
  }

  double _height(UiTabsTheme theme) {
    switch (size) {
      case UiTabsSize.small:
        return style == UiTabsStyle.underline
            ? theme.smallUnderlineHeight
            : theme.smallHeight;
      case UiTabsSize.large:
        return style == UiTabsStyle.underline
            ? theme.largeUnderlineHeight
            : theme.largeHeight;
      case UiTabsSize.medium:
        return style == UiTabsStyle.underline
            ? theme.mediumUnderlineHeight
            : theme.mediumHeight;
    }
  }

  EdgeInsetsGeometry _barPadding(UiTabsTheme theme) {
    if (style == UiTabsStyle.underline) {
      return EdgeInsets.zero;
    }
    return theme.padding;
  }

  BoxDecoration _barDecoration(BuildContext context) {
    final theme = context.uiTheme;
    final tabsTheme = theme.components.tabs;
    switch (style) {
      case UiTabsStyle.underline:
        return BoxDecoration(
          color: theme.surface,
          border: Border(
            bottom: BorderSide(color: theme.border.withValues(alpha: 0.72)),
          ),
        );
      case UiTabsStyle.segmented:
        return BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(tabsTheme.radius),
          border: Border.all(color: theme.border.withValues(alpha: 0.78)),
        );
      case UiTabsStyle.pill:
        return BoxDecoration(
          color: theme.isDark ? theme.surfaceElevated : theme.surfaceLight,
          borderRadius: BorderRadius.circular(tabsTheme.radius),
          border: Border.all(
            color: theme.isDark
                ? theme.borderHover.withValues(alpha: 0.56)
                : theme.border.withValues(alpha: 0.84),
          ),
          boxShadow: theme.shadowXs,
        );
    }
  }
}

class _UiTabButton extends StatefulWidget {
  final UiTabItem item;
  final bool selected;
  final UiTabsSize size;
  final UiTabsStyle style;
  final double height;
  final double minWidth;
  final VoidCallback? onTap;

  const _UiTabButton({
    required this.item,
    required this.selected,
    required this.size,
    required this.style,
    required this.height,
    required this.minWidth,
    required this.onTap,
  });

  @override
  State<_UiTabButton> createState() => _UiTabButtonState();
}

class _UiTabButtonState extends State<_UiTabButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: Container(
          height: widget.height,
          constraints: BoxConstraints(minWidth: widget.minWidth),
          padding: _padding,
          decoration: _decoration(context, enabled),
          child: Semantics(
            label: widget.item.semanticsLabel,
            selected: widget.selected,
            child: widget.style == UiTabsStyle.underline
                ? _underlineBody(context)
                : Center(child: _labelBody(context)),
          ),
        ),
      ),
    );
  }

  Widget _labelBody(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: _foreground(context),
        fontSize: widget.size == UiTabsSize.small ? 12 : 13,
        fontWeight: FontWeight.w700,
      ),
      child: _content(context),
    );
  }

  Widget _underlineBody(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Center(child: _labelBody(context)),
          ),
        ),
        if (widget.selected)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: context.uiTheme.primary,
                  borderRadius: BorderRadius.circular(
                    context.uiTheme.components.tabs.indicatorRadius,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _content(BuildContext context) {
    final foreground = _foreground(context);
    final leading =
        widget.item.leading ??
        (widget.item.icon == null ? null : Icon(widget.item.icon));
    final badge =
        widget.item.badge ??
        (widget.item.badgeLabel == null
            ? null
            : _UiTabBadge(
                label: widget.item.badgeLabel!,
                color: widget.item.badgeColor,
                selected: widget.selected,
                style: widget.style,
              ));
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(color: foreground, size: _iconSize),
            child: leading,
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            widget.item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
    if (badge == null) {
      return label;
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 16),
          child: label,
        ),
        Positioned(top: 0, right: 0, child: badge),
      ],
    );
  }

  EdgeInsetsGeometry get _padding {
    switch (widget.size) {
      case UiTabsSize.small:
        return const EdgeInsets.symmetric(horizontal: 10);
      case UiTabsSize.large:
        return const EdgeInsets.symmetric(horizontal: 18);
      case UiTabsSize.medium:
        return const EdgeInsets.symmetric(horizontal: 14);
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case UiTabsSize.small:
        return 14;
      case UiTabsSize.large:
        return 18;
      case UiTabsSize.medium:
        return 16;
    }
  }

  BoxDecoration _decoration(BuildContext context, bool enabled) {
    final theme = context.uiTheme;
    final radius = BorderRadius.circular(theme.components.tabs.indicatorRadius);
    switch (widget.style) {
      case UiTabsStyle.pill:
        if (widget.selected) {
          return BoxDecoration(
            gradient: theme.primaryGradient,
            borderRadius: radius,
            boxShadow: theme.shadowSm,
          );
        }
        return BoxDecoration(
          color: _hovered && enabled
              ? theme.primary.withValues(alpha: theme.isDark ? 0.14 : 0.08)
              : Colors.transparent,
          borderRadius: radius,
        );
      case UiTabsStyle.segmented:
        return BoxDecoration(
          color: widget.selected
              ? (theme.isDark ? theme.surfaceLight : theme.surfaceElevated)
              : (_hovered && enabled
                    ? theme.primary.withValues(
                        alpha: theme.isDark ? 0.12 : 0.06,
                      )
                    : Colors.transparent),
          borderRadius: radius,
          border: widget.selected
              ? Border.all(color: theme.borderHover.withValues(alpha: 0.62))
              : null,
        );
      case UiTabsStyle.underline:
        return BoxDecoration(
          color: _hovered && enabled
              ? theme.primary.withValues(alpha: theme.isDark ? 0.12 : 0.06)
              : Colors.transparent,
        );
    }
  }

  Color _foreground(BuildContext context) {
    final theme = context.uiTheme;
    switch (widget.style) {
      case UiTabsStyle.pill:
        return widget.selected ? Colors.white : theme.primary;
      case UiTabsStyle.segmented:
        return widget.selected ? theme.primary : theme.textSecondary;
      case UiTabsStyle.underline:
        return widget.selected ? theme.primary : theme.textSecondary;
    }
  }
}

class _UiTabBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final bool selected;
  final UiTabsStyle style;

  const _UiTabBadge({
    required this.label,
    required this.color,
    required this.selected,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final accent = color ?? theme.error;
    if (label.isEmpty) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      );
    }
    final pillSelected = selected && style == UiTabsStyle.pill;
    return Container(
      height: 14,
      constraints: const BoxConstraints(minWidth: 14),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pillSelected ? Colors.white.withValues(alpha: 0.9) : accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          color: pillSelected ? theme.primary : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
