import 'package:flutter/material.dart';

import '../../theme/ui_component_theme.dart';
import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_spacing.dart';

enum UiTabsSize { small, medium, large }

class UiTabsController extends ValueNotifier<int> {
  UiTabsController(super.value);

  int get selectedIndex => value;

  set selectedIndex(int nextIndex) => value = nextIndex;
}

class UiTabs extends StatelessWidget {
  final int? selectedIndex;
  final UiTabsController? controller;
  final List<String> items;
  final ValueChanged<int>? onChanged;
  final UiTabsSize size;
  final bool fullWidth;
  final double? width;
  final String? semanticsLabel;

  const UiTabs({
    super.key,
    this.selectedIndex,
    this.controller,
    required this.items,
    this.onChanged,
    this.size = UiTabsSize.medium,
    this.fullWidth = true,
    this.width,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'UiTabs needs at least one item.');
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
    assert(
      currentIndex >= 0 && currentIndex < items.length,
      'UiTabs selected index must be within items.',
    );

    final theme = context.uiTheme;
    final tabsTheme = theme.components.tabs;
    final content = Container(
      height: _height(tabsTheme),
      padding: tabsTheme.padding,
      decoration: BoxDecoration(
        color: theme.isDark ? theme.surfaceElevated : theme.surfaceLight,
        borderRadius: BorderRadius.circular(tabsTheme.radius),
        border: Border.all(
          color: theme.isDark
              ? theme.borderHover.withValues(alpha: 0.56)
              : theme.border.withValues(alpha: 0.84),
        ),
        boxShadow: theme.shadowXs,
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const SizedBox(width: UiSpacing.space1),
            _item(context, items[index], index, currentIndex),
          ],
        ],
      ),
    );

    final constrained = width == null
        ? content
        : SizedBox(width: width, child: content);
    final wrapped = fullWidth
        ? SizedBox(width: width ?? double.infinity, child: constrained)
        : constrained;

    return Semantics(label: semanticsLabel, container: true, child: wrapped);
  }

  Widget _item(
    BuildContext context,
    String label,
    int index,
    int currentIndex,
  ) {
    final tabsTheme = context.uiTheme.components.tabs;
    final child = _UiTabButton(
      label: label,
      selected: index == currentIndex,
      size: size,
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

  double _height(UiTabsTheme theme) {
    switch (size) {
      case UiTabsSize.small:
        return theme.smallHeight;
      case UiTabsSize.large:
        return theme.largeHeight;
      case UiTabsSize.medium:
        return theme.mediumHeight;
    }
  }
}

class _UiTabButton extends StatefulWidget {
  final String label;
  final bool selected;
  final UiTabsSize size;
  final double minWidth;
  final VoidCallback? onTap;

  const _UiTabButton({
    required this.label,
    required this.selected,
    required this.size,
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
          constraints: BoxConstraints(minWidth: widget.minWidth),
          padding: _padding,
          alignment: Alignment.center,
          decoration: _decoration(context, enabled),
          child: DefaultTextStyle(
            style: TextStyle(
              color: _foreground(context),
              fontSize: widget.size == UiTabsSize.small ? 12 : 13,
              fontWeight: FontWeight.w700,
            ),
            child: _content(),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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

  BoxDecoration _decoration(BuildContext context, bool enabled) {
    final theme = context.uiTheme;
    final radius = BorderRadius.circular(theme.components.tabs.indicatorRadius);
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
  }

  Color _foreground(BuildContext context) {
    final theme = context.uiTheme;
    if (widget.selected) {
      return Colors.white;
    }
    return theme.primary;
  }
}
