import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../overlays/ui_overlay_shell.dart';
import 'ui_text_field.dart';

enum UiDropdownSize { compact, medium }

typedef UiDropdownOptionBuilder<T> =
    Widget Function(
      BuildContext context,
      UiDropdownOption<T> option,
      bool selected,
      bool highlighted,
    );

typedef UiDropdownSelectedBuilder<T> =
    Widget Function(BuildContext context, UiDropdownOption<T> option);

class UiDropdownOption<T> {
  final T value;
  final String label;
  final String? description;
  final Widget? icon;
  final Widget? trailing;
  final Widget? child;
  final bool enabled;

  const UiDropdownOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.trailing,
    this.child,
    this.enabled = true,
  });
}

class UiDropdown<T> extends StatefulWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<UiDropdownOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? errorText;
  final bool enabled;
  final bool clearable;
  final bool searchable;
  final Widget? prefix;
  final Widget? suffix;
  final double? menuWidth;
  final double? menuMaxHeight;
  final String searchHintText;
  final String emptyText;
  final bool Function(UiDropdownOption<T> option, String query)? filterOption;
  final UiDropdownOptionBuilder<T>? optionBuilder;
  final UiDropdownSelectedBuilder<T>? selectedBuilder;
  final UiDropdownSize size;

  const UiDropdown({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.options,
    this.onChanged,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.clearable = false,
    this.searchable = false,
    this.prefix,
    this.suffix,
    this.menuWidth,
    this.menuMaxHeight,
    this.searchHintText = 'Search',
    this.emptyText = 'No options',
    this.filterOption,
    this.optionBuilder,
    this.selectedBuilder,
    this.size = UiDropdownSize.medium,
  });

  @override
  State<UiDropdown<T>> createState() => _UiDropdownState<T>();
}

class _UiDropdownState<T> extends State<UiDropdown<T>> {
  static const double _menuGap = 6;
  static const double _overlayMargin = UiSpacing.space2;

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final GlobalKey<FormFieldState<T>> _formFieldKey =
      GlobalKey<FormFieldState<T>>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool _focused = false;
  bool _open = false;
  int _highlightedIndex = -1;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void didUpdateWidget(UiDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _formFieldKey.currentState?.didChange(widget.value);
      _syncHighlightedIndex();
    }
    if (!widget.enabled && oldWidget.enabled) {
      _hideMenu();
    } else if (_open) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _hideMenu(notify: false);
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.value == null ||
          widget.options
                  .where((option) => option.value == widget.value)
                  .length ==
              1,
      'UiDropdown value must match exactly one option.',
    );

    return FormField<T>(
      key: _formFieldKey,
      initialValue: widget.value,
      enabled: widget.enabled,
      validator: widget.validator,
      builder: (field) => _buildField(context, field),
    );
  }

  Widget _buildField(BuildContext context, FormFieldState<T> field) {
    final theme = context.uiTheme;
    final errorText = widget.errorText ?? field.errorText;
    final hasError = errorText != null && errorText.isNotEmpty;
    final active = _focused || _open;
    final selectedOption = _optionForValue(field.value);
    final metrics = _UiDropdownMetrics.forSize(widget.size);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: metrics.labelFontSize,
              fontWeight: FontWeight.w600,
              color: hasError
                  ? theme.error
                  : (active ? theme.primary : theme.textSecondary),
            ),
          ),
          SizedBox(height: metrics.labelGap),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: Focus(
            focusNode: _focusNode,
            onKeyEvent: (node, event) => _handleKeyEvent(event, field),
            child: GestureDetector(
              key: _fieldKey,
              behavior: HitTestBehavior.opaque,
              onTap: widget.enabled ? () => _toggleMenu(field) : null,
              child: AnimatedContainer(
                duration: UiMotion.normal,
                curve: UiMotion.standard,
                constraints: BoxConstraints(minHeight: metrics.fieldHeight),
                padding: EdgeInsets.symmetric(horizontal: metrics.paddingX),
                decoration: BoxDecoration(
                  color: active ? theme.surface : theme.surfaceLight,
                  borderRadius: BorderRadius.circular(
                    theme.components.textField.radius,
                  ),
                  border: Border.all(
                    color: hasError
                        ? theme.error
                        : (active ? theme.primary : theme.border),
                    width: active ? 1.5 : 1,
                  ),
                  boxShadow: active && !hasError
                      ? [
                          BoxShadow(
                            color: theme.primary.withValues(
                              alpha: theme.isDark ? 0.24 : 0.12,
                            ),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    if (widget.prefix != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          size: UiSpacing.iconMd,
                          color: hasError
                              ? theme.error
                              : (active ? theme.primary : theme.textTertiary),
                        ),
                        child: widget.prefix!,
                      ),
                      const SizedBox(width: UiSpacing.space2),
                    ],
                    Expanded(
                      child: _UiDropdownValue<T>(
                        option: selectedOption,
                        hintText: widget.hintText,
                        selectedBuilder: widget.selectedBuilder,
                        metrics: metrics,
                      ),
                    ),
                    if (widget.clearable &&
                        widget.enabled &&
                        selectedOption != null) ...[
                      const SizedBox(width: UiSpacing.space2),
                      _DropdownIconAction(
                        icon: Icons.close_rounded,
                        color: theme.textTertiary,
                        onTap: () => _selectValue(null, field),
                      ),
                    ],
                    if (widget.suffix != null) ...[
                      const SizedBox(width: UiSpacing.space2),
                      IconTheme(
                        data: IconThemeData(
                          size: UiSpacing.iconMd,
                          color: hasError ? theme.error : theme.textTertiary,
                        ),
                        child: widget.suffix!,
                      ),
                    ],
                    const SizedBox(width: UiSpacing.space1),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: UiMotion.fast,
                      curve: UiMotion.standard,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: metrics.iconSize,
                        color: widget.enabled
                            ? theme.textTertiary
                            : theme.textTertiary.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: UiSpacing.space1),
          Text(errorText, style: TextStyle(fontSize: 12, color: theme.error)),
        ],
      ],
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, FormFieldState<T> field) {
    if (event is! KeyDownEvent || !widget.enabled) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _hideMenu();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (!_open) {
        _showMenu(field);
      } else {
        _moveHighlight(1);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (!_open) {
        _showMenu(field);
      } else {
        _moveHighlight(-1);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (!_open) {
        _showMenu(field);
      } else {
        final options = _visibleOptions;
        if (_highlightedIndex >= 0 && _highlightedIndex < options.length) {
          final option = options[_highlightedIndex];
          if (option.enabled) {
            _selectValue(option.value, field);
          }
        }
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      _hideMenu();
    }
    return KeyEventResult.ignored;
  }

  void _handleFocusChanged() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  void _handleSearchChanged() {
    _query = _searchController.text;
    _syncHighlightedIndex();
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleMenu(FormFieldState<T> field) {
    if (_open) {
      _hideMenu();
    } else {
      _showMenu(field);
    }
  }

  void _showMenu(FormFieldState<T> field) {
    if (!widget.enabled) {
      return;
    }
    _focusNode.requestFocus();
    _overlayEntry?.remove();
    _syncHighlightedIndex();
    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlay(field));
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  Widget _buildOverlay(FormFieldState<T> field) {
    final layout = _menuLayout();
    final visibleOptions = _visibleOptions;

    return UiOverlayShell(
      onDismiss: _hideMenu,
      children: [
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, layout.offsetY),
          child: _UiDropdownMenu<T>(
            width: layout.width,
            maxHeight: layout.maxHeight,
            size: widget.size,
            options: visibleOptions,
            selectedValue: field.value,
            highlightedIndex: _highlightedIndex,
            searchable: widget.searchable,
            searchController: _searchController,
            searchHintText: widget.searchHintText,
            emptyText: widget.emptyText,
            optionBuilder: widget.optionBuilder,
            onHover: (index) => _setHighlightedIndex(index),
            onSelected: (option) => _selectValue(option.value, field),
          ),
        ),
      ],
    );
  }

  void _selectValue(T? value, FormFieldState<T> field) {
    field.didChange(value);
    widget.onChanged?.call(value);
    _hideMenu();
  }

  void _moveHighlight(int delta) {
    final options = _visibleOptions;
    if (options.isEmpty) {
      _setHighlightedIndex(-1);
      return;
    }

    var next = _highlightedIndex;
    for (var index = 0; index < options.length; index++) {
      next = (next + delta) % options.length;
      if (next < 0) {
        next = options.length - 1;
      }
      if (options[next].enabled) {
        _setHighlightedIndex(next);
        return;
      }
    }
  }

  void _syncHighlightedIndex() {
    final options = _visibleOptions;
    final selectedValue = _formFieldKey.currentState?.value ?? widget.value;
    final selectedIndex = options.indexWhere(
      (option) => option.value == selectedValue && option.enabled,
    );
    if (selectedIndex >= 0) {
      _highlightedIndex = selectedIndex;
      return;
    }
    _highlightedIndex = options.indexWhere((option) => option.enabled);
  }

  void _setHighlightedIndex(int index) {
    _highlightedIndex = index;
    _overlayEntry?.markNeedsBuild();
  }

  void _hideMenu({bool notify = true}) {
    if (_overlayEntry == null) {
      return;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    if (notify && mounted) {
      setState(() => _open = false);
    } else {
      _open = false;
    }
  }

  _UiDropdownMenuLayout _menuLayout() {
    final fieldBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (fieldBox == null || overlayBox == null) {
      return const _UiDropdownMenuLayout(
        width: 220,
        maxHeight: 280,
        offsetY: _menuGap,
      );
    }

    final fieldSize = fieldBox.size;
    final fieldTopLeft = fieldBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final below =
        overlayBox.size.height -
        fieldTopLeft.dy -
        fieldSize.height -
        _overlayMargin -
        _menuGap;
    final above = fieldTopLeft.dy - _overlayMargin - _menuGap;
    final estimatedHeight = _estimatedMenuHeight();
    final openUp = below < math.min(estimatedHeight, 180.0) && above > below;
    final availableHeight = math.max(96.0, openUp ? above : below);
    final maxHeight = math.min(
      widget.menuMaxHeight ?? 320.0,
      math.min(estimatedHeight, availableHeight),
    );

    return _UiDropdownMenuLayout(
      width: widget.menuWidth ?? fieldSize.width,
      maxHeight: maxHeight,
      offsetY: openUp ? -(maxHeight + _menuGap) : fieldSize.height + _menuGap,
    );
  }

  double _estimatedMenuHeight() {
    final metrics = _UiDropdownMetrics.forSize(widget.size);
    final searchHeight = widget.searchable ? metrics.searchHeight : 0;
    final optionHeight =
        math.max(1, _visibleOptions.length) * metrics.optionMinHeight;
    return searchHeight + optionHeight + UiSpacing.space2;
  }

  List<UiDropdownOption<T>> get _visibleOptions {
    final query = _query.trim().toLowerCase();
    if (!widget.searchable || query.isEmpty) {
      return widget.options;
    }
    return widget.options.where((option) {
      final filter = widget.filterOption;
      if (filter != null) {
        return filter(option, query);
      }
      final description = option.description?.toLowerCase() ?? '';
      return option.label.toLowerCase().contains(query) ||
          description.contains(query);
    }).toList();
  }

  UiDropdownOption<T>? _optionForValue(T? value) {
    if (value == null) {
      return null;
    }
    for (final option in widget.options) {
      if (option.value == value) {
        return option;
      }
    }
    return null;
  }
}

class _UiDropdownMetrics {
  final double fieldHeight;
  final double labelFontSize;
  final double fontSize;
  final double menuFontSize;
  final double labelGap;
  final double paddingX;
  final double iconSize;
  final double optionMinHeight;
  final double optionPaddingY;
  final double searchHeight;
  final double searchFieldHeight;

  const _UiDropdownMetrics({
    required this.fieldHeight,
    required this.labelFontSize,
    required this.fontSize,
    required this.menuFontSize,
    required this.labelGap,
    required this.paddingX,
    required this.iconSize,
    required this.optionMinHeight,
    required this.optionPaddingY,
    required this.searchHeight,
    required this.searchFieldHeight,
  });

  factory _UiDropdownMetrics.forSize(UiDropdownSize size) {
    switch (size) {
      case UiDropdownSize.compact:
        return const _UiDropdownMetrics(
          fieldHeight: 28,
          labelFontSize: 10,
          fontSize: 12,
          menuFontSize: 12,
          labelGap: 4,
          paddingX: 8,
          iconSize: 16,
          optionMinHeight: 34,
          optionPaddingY: 6,
          searchHeight: 44,
          searchFieldHeight: 32,
        );
      case UiDropdownSize.medium:
        return const _UiDropdownMetrics(
          fieldHeight: 46,
          labelFontSize: 12,
          fontSize: 14,
          menuFontSize: 13,
          labelGap: 8,
          paddingX: 12,
          iconSize: UiSpacing.iconMd,
          optionMinHeight: 42,
          optionPaddingY: UiSpacing.space2,
          searchHeight: 48,
          searchFieldHeight: 36,
        );
    }
  }
}

class _UiDropdownMenuLayout {
  final double width;
  final double maxHeight;
  final double offsetY;

  const _UiDropdownMenuLayout({
    required this.width,
    required this.maxHeight,
    required this.offsetY,
  });
}

class _UiDropdownValue<T> extends StatelessWidget {
  final UiDropdownOption<T>? option;
  final String? hintText;
  final UiDropdownSelectedBuilder<T>? selectedBuilder;
  final _UiDropdownMetrics metrics;

  const _UiDropdownValue({
    required this.option,
    required this.hintText,
    required this.selectedBuilder,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final option = this.option;
    if (option == null) {
      return Text(
        hintText ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: theme.textTertiary, fontSize: metrics.fontSize),
      );
    }
    final builder = selectedBuilder;
    if (builder != null) {
      return builder(context, option);
    }
    return Row(
      children: [
        if (option.icon != null) ...[
          IconTheme(
            data: IconThemeData(size: UiSpacing.iconSm, color: theme.primary),
            child: option.icon!,
          ),
          const SizedBox(width: UiSpacing.space2),
        ],
        Expanded(
          child: Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: metrics.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _UiDropdownMenu<T> extends StatelessWidget {
  final double width;
  final double maxHeight;
  final UiDropdownSize size;
  final List<UiDropdownOption<T>> options;
  final T? selectedValue;
  final int highlightedIndex;
  final bool searchable;
  final TextEditingController searchController;
  final String searchHintText;
  final String emptyText;
  final UiDropdownOptionBuilder<T>? optionBuilder;
  final ValueChanged<int> onHover;
  final ValueChanged<UiDropdownOption<T>> onSelected;

  const _UiDropdownMenu({
    required this.width,
    required this.maxHeight,
    required this.size,
    required this.options,
    required this.selectedValue,
    required this.highlightedIndex,
    required this.searchable,
    required this.searchController,
    required this.searchHintText,
    required this.emptyText,
    required this.optionBuilder,
    required this.onHover,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = _UiDropdownMetrics.forSize(size);
    return UiFloatingPanel(
      width: width,
      maxHeight: maxHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (searchable) ...[
            _UiDropdownSearchField(
              controller: searchController,
              hintText: searchHintText,
              metrics: metrics,
            ),
            const SizedBox(height: UiSpacing.space1),
          ],
          Flexible(
            child: options.isEmpty
                ? _UiDropdownEmpty(text: emptyText)
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return _UiDropdownOptionRow<T>(
                        option: option,
                        selected: option.value == selectedValue,
                        highlighted: index == highlightedIndex,
                        metrics: metrics,
                        optionBuilder: optionBuilder,
                        onHover: () => onHover(index),
                        onSelected: () {
                          if (option.enabled) {
                            onSelected(option);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _UiDropdownSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final _UiDropdownMetrics metrics;

  const _UiDropdownSearchField({
    required this.controller,
    required this.hintText,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final inputSize = metrics.searchFieldHeight <= 32
        ? UiTextFieldSize.compact
        : UiTextFieldSize.medium;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UiSpacing.space1),
      child: UiTextField(
        controller: controller,
        hintText: hintText,
        prefix: const Icon(Icons.search_rounded),
        size: inputSize,
      ),
    );
  }
}

class _UiDropdownOptionRow<T> extends StatefulWidget {
  final UiDropdownOption<T> option;
  final bool selected;
  final bool highlighted;
  final _UiDropdownMetrics metrics;
  final UiDropdownOptionBuilder<T>? optionBuilder;
  final VoidCallback onHover;
  final VoidCallback onSelected;

  const _UiDropdownOptionRow({
    required this.option,
    required this.selected,
    required this.highlighted,
    required this.metrics,
    required this.optionBuilder,
    required this.onHover,
    required this.onSelected,
  });

  @override
  State<_UiDropdownOptionRow<T>> createState() =>
      _UiDropdownOptionRowState<T>();
}

class _UiDropdownOptionRowState<T> extends State<_UiDropdownOptionRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final option = widget.option;
    final enabled = option.enabled;
    final active = enabled && (_hovered || widget.highlighted);
    final selected = widget.selected;
    final foreground = enabled ? theme.textPrimary : theme.textTertiary;
    final secondary = enabled ? theme.textSecondary : theme.textTertiary;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHover();
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onSelected : null,
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.standard,
          constraints: BoxConstraints(
            minHeight: widget.metrics.optionMinHeight,
          ),
          margin: const EdgeInsets.symmetric(horizontal: UiSpacing.space1),
          padding: EdgeInsets.symmetric(
            horizontal: UiSpacing.space3,
            vertical: widget.metrics.optionPaddingY,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.primary.withValues(alpha: theme.isDark ? 0.28 : 0.12)
                : (active ? theme.surfaceLighter : Colors.transparent),
            borderRadius: BorderRadius.circular(UiRadii.sm),
          ),
          child:
              widget.optionBuilder?.call(
                context,
                option,
                selected,
                widget.highlighted,
              ) ??
              _defaultContent(context, option, selected, foreground, secondary),
        ),
      ),
    );
  }

  Widget _defaultContent(
    BuildContext context,
    UiDropdownOption<T> option,
    bool selected,
    Color foreground,
    Color secondary,
  ) {
    if (option.child != null) {
      return option.child!;
    }
    return Row(
      children: [
        if (option.icon != null) ...[
          SizedBox(
            width: 20,
            child: IconTheme(
              data: IconThemeData(size: UiSpacing.iconSm, color: secondary),
              child: option.icon!,
            ),
          ),
          const SizedBox(width: UiSpacing.space2),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: widget.metrics.menuFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (option.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  option.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondary, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (option.trailing != null) ...[
          const SizedBox(width: UiSpacing.space3),
          IconTheme(
            data: IconThemeData(size: UiSpacing.iconSm, color: secondary),
            child: option.trailing!,
          ),
        ],
      ],
    );
  }
}

class _UiDropdownEmpty extends StatelessWidget {
  final String text;

  const _UiDropdownEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.space4,
        vertical: UiSpacing.space4,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.textTertiary, fontSize: 13),
      ),
    );
  }
}

class _DropdownIconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DropdownIconAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(icon, size: UiSpacing.iconSm, color: color),
      ),
    );
  }
}
