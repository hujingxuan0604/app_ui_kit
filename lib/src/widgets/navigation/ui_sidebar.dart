import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../display/ui_sidebar_item.dart';

class UiNavigationItem<T> {
  final T value;
  final String label;
  final Widget? leading;
  final IconData? icon;
  final String? countLabel;

  const UiNavigationItem({
    required this.value,
    required this.label,
    this.leading,
    this.icon,
    this.countLabel,
  });
}

class UiSidebar<T> extends StatelessWidget {
  final String? title;
  final List<Widget> headerActions;
  final List<UiNavigationItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onItemSelected;
  final String? searchQuery;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final double width;
  final EdgeInsetsGeometry padding;

  const UiSidebar({
    super.key,
    this.title,
    this.headerActions = const [],
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
    this.searchQuery,
    this.searchHint,
    this.onSearchChanged,
    this.width = 220,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          right: BorderSide(color: theme.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || headerActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  ...headerActions,
                ],
              ),
            ),
          if (onSearchChanged != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _UiSidebarSearchField(
                initialValue: searchQuery ?? '',
                hintText: searchHint ?? 'Search',
                onChanged: onSearchChanged!,
              ),
            ),
          if (onSearchChanged != null) const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: padding,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                return UiSidebarItem(
                  label: item.label,
                  leading:
                      item.leading ??
                      (item.icon == null ? null : Icon(item.icon)),
                  countLabel: item.countLabel,
                  selected: item.value == selectedValue,
                  onTap: () => onItemSelected(item.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UiSidebarSearchField extends StatefulWidget {
  final String initialValue;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _UiSidebarSearchField({
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<_UiSidebarSearchField> createState() => _UiSidebarSearchFieldState();
}

class _UiSidebarSearchFieldState extends State<_UiSidebarSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _UiSidebarSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.surfaceLight,
        borderRadius: BorderRadius.circular(UiRadii.lg),
        border: Border.all(color: theme.border),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: 13, color: theme.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 13, color: theme.textTertiary),
          prefixIcon: Icon(Icons.search, size: 18, color: theme.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          isDense: true,
        ),
      ),
    );
  }
}
