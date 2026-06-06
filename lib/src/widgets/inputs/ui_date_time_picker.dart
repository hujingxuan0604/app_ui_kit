import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme/ui_component_theme.dart';
import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../overlays/ui_bottom_popup.dart';
import 'ui_text_field.dart';

enum UiDateTimePickerMode { year, month, date, hour, minute, second, time }

typedef UiDateTimeFormatter =
    String Function(DateTime value, UiDateTimePickerMode mode);

class UiDateTimePicker extends StatefulWidget {
  final String? label;
  final String? hintText;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTime>? onPreviewChanged;
  final DateTime? minDate;
  final DateTime? maxDate;
  final UiDateTimePickerMode mode;
  final bool enabled;
  final bool clearable;
  final String? errorText;
  final String title;
  final String cancelText;
  final String confirmText;
  final Widget? prefix;
  final Widget? suffix;
  final double? panelWidth;
  final UiTextFieldSize size;
  final UiDateTimeFormatter? formatter;

  const UiDateTimePicker({
    super.key,
    this.label,
    this.hintText,
    this.value,
    this.onChanged,
    this.onPreviewChanged,
    this.minDate,
    this.maxDate,
    this.mode = UiDateTimePickerMode.date,
    this.enabled = true,
    this.clearable = false,
    this.errorText,
    this.title = 'Select date',
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.prefix,
    this.suffix,
    this.panelWidth,
    this.size = UiTextFieldSize.medium,
    this.formatter,
  });

  @override
  State<UiDateTimePicker> createState() => _UiDateTimePickerState();
}

class _UiDateTimePickerState extends State<UiDateTimePicker> {
  final FocusNode _focusNode = FocusNode();

  bool _focused = false;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(UiDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled) {
      _dismissPanel();
    }
  }

  @override
  void dispose() {
    _open = false;
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final metrics = _UiDateTimeFieldMetrics.forSize(widget.size);
    final active = _focused || _open;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: hasError
                  ? theme.error
                  : (active ? theme.primary : theme.textSecondary),
              fontSize: metrics.labelFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: metrics.labelGap),
        ],
        Focus(
          focusNode: _focusNode,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? _togglePanel : null,
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
                  IconTheme(
                    data: IconThemeData(
                      size: UiSpacing.iconMd,
                      color: hasError
                          ? theme.error
                          : (active ? theme.primary : theme.textTertiary),
                    ),
                    child:
                        widget.prefix ??
                        const Icon(Icons.calendar_month_outlined),
                  ),
                  const SizedBox(width: UiSpacing.space2),
                  Expanded(
                    child: Text(
                      _displayValue ?? widget.hintText ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _displayValue == null
                            ? theme.textTertiary
                            : theme.textPrimary,
                        fontSize: metrics.inputFontSize,
                      ),
                    ),
                  ),
                  if (widget.clearable &&
                      widget.enabled &&
                      widget.value != null) ...[
                    const SizedBox(width: UiSpacing.space2),
                    _DateTimeIconAction(
                      icon: Icons.close_rounded,
                      color: theme.textTertiary,
                      onTap: () => widget.onChanged?.call(null),
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
        if (hasError) ...[
          const SizedBox(height: UiSpacing.space1),
          Text(
            widget.errorText!,
            style: TextStyle(color: theme.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  String? get _displayValue {
    final value = widget.value;
    if (value == null) {
      return null;
    }
    return widget.formatter?.call(value, widget.mode) ??
        UiDateTimeFormats.format(value, widget.mode);
  }

  void _handleFocusChanged() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  void _togglePanel() {
    if (_open) {
      _dismissPanel();
    } else {
      _showPanel();
    }
  }

  Future<void> _showPanel() async {
    if (!widget.enabled || _open) {
      return;
    }
    _focusNode.requestFocus();
    setState(() => _open = true);
    final pickerTheme = context.uiTheme.components.dateTimePicker;
    await UiBottomPopup.show<void>(
      context: context,
      builder: (popupContext) => UiBottomPopup(
        maxWidth: widget.panelWidth ?? _preferredPanelWidth(pickerTheme),
        maxHeight: pickerTheme.panelMaxHeight,
        showCloseButton: false,
        scrollable: false,
        contentPadding: EdgeInsets.zero,
        child: _UiDateTimePickerPanel(
          title: widget.title,
          cancelText: widget.cancelText,
          confirmText: widget.confirmText,
          value: widget.value,
          mode: widget.mode,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          onPreviewChanged: widget.onPreviewChanged,
          onCancel: () => Navigator.of(popupContext).maybePop(),
          onConfirm: (value) {
            widget.onChanged?.call(value);
            Navigator.of(popupContext).maybePop();
          },
        ),
      ),
    );
    if (mounted) {
      setState(() => _open = false);
    } else {
      _open = false;
    }
  }

  void _dismissPanel() {
    if (!_open) {
      return;
    }
    Navigator.of(context).maybePop();
  }

  double _preferredPanelWidth(UiDateTimePickerTheme pickerTheme) {
    final columnCount = _partsForMode(widget.mode).length;
    final horizontalPadding = pickerTheme.panelPadding
        .resolve(Directionality.of(context))
        .horizontal;
    final contentWidth = pickerTheme.columnWidth * columnCount;
    return math.max(pickerTheme.panelWidth, contentWidth + horizontalPadding);
  }
}

class UiDateTimeFormats {
  const UiDateTimeFormats._();

  static String format(DateTime value, UiDateTimePickerMode mode) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');

    switch (mode) {
      case UiDateTimePickerMode.year:
        return year;
      case UiDateTimePickerMode.month:
        return '$year-$month';
      case UiDateTimePickerMode.date:
        return '$year-$month-$day';
      case UiDateTimePickerMode.hour:
        return '$year-$month-$day $hour';
      case UiDateTimePickerMode.minute:
        return '$year-$month-$day $hour:$minute';
      case UiDateTimePickerMode.second:
        return '$year-$month-$day $hour:$minute:$second';
      case UiDateTimePickerMode.time:
        return '$hour:$minute:$second';
    }
  }
}

class _UiDateTimePickerPanel extends StatefulWidget {
  final String title;
  final String cancelText;
  final String confirmText;
  final DateTime? value;
  final UiDateTimePickerMode mode;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime>? onPreviewChanged;
  final VoidCallback onCancel;
  final ValueChanged<DateTime> onConfirm;

  const _UiDateTimePickerPanel({
    required this.title,
    required this.cancelText,
    required this.confirmText,
    required this.value,
    required this.mode,
    required this.minDate,
    required this.maxDate,
    required this.onPreviewChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<_UiDateTimePickerPanel> createState() => _UiDateTimePickerPanelState();
}

class _UiDateTimePickerPanelState extends State<_UiDateTimePickerPanel> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = _clamp(widget.value ?? DateTime.now());
  }

  @override
  void didUpdateWidget(_UiDateTimePickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode ||
        oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate ||
        oldWidget.value != widget.value) {
      _selected = _clamp(widget.value ?? _selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final pickerTheme = theme.components.dateTimePicker;
    final columns = _columns;
    final wheelHeight = pickerTheme.itemHeight * pickerTheme.visibleItemCount;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panelPadding = pickerTheme.panelPadding.resolve(
            Directionality.of(context),
          );
          final columnWidth =
              constraints.maxWidth.isFinite && columns.isNotEmpty
              ? ((constraints.maxWidth - panelPadding.horizontal) /
                        columns.length)
                    .clamp(64.0, pickerTheme.columnWidth)
              : pickerTheme.columnWidth;

          return Padding(
            padding: pickerTheme.panelPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: widget.onCancel,
                        child: Text(widget.cancelText),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onConfirm(_selected),
                        child: Text(widget.confirmText),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiSpacing.space2),
                Container(
                  height: wheelHeight,
                  decoration: BoxDecoration(
                    color: theme.surfaceLight,
                    borderRadius: BorderRadius.circular(pickerTheme.radius),
                    border: Border.all(
                      color: theme.border.withValues(alpha: 0.72),
                    ),
                  ),
                  child: Row(
                    children: columns
                        .map(
                          (column) => Expanded(
                            key: ValueKey(column.part),
                            child: _DateTimeColumnWheel(
                              column: column,
                              itemHeight: pickerTheme.itemHeight,
                              columnWidth: columnWidth,
                              onChanged: (value) => _select(column.part, value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_DateTimeColumn> get _columns {
    return _parts
        .map((part) {
          final values = _valuesFor(part);
          return _DateTimeColumn(
            part: part,
            values: values,
            selectedValue: _valueFor(part),
            unit: _unitFor(part),
          );
        })
        .toList(growable: false);
  }

  List<_DateTimePart> get _parts {
    return _partsForMode(widget.mode);
  }

  List<int> _valuesFor(_DateTimePart part) {
    switch (part) {
      case _DateTimePart.year:
        return _range(_minYear, _maxYear);
      case _DateTimePart.month:
        return _boundedRange(
          1,
          12,
          part,
          (value) => DateTime(
            _selected.year,
            value,
            1,
            _selected.hour,
            _selected.minute,
            _selected.second,
          ),
        );
      case _DateTimePart.day:
        return _boundedRange(
          1,
          _daysInMonth(_selected.year, _selected.month),
          part,
          (value) => DateTime(
            _selected.year,
            _selected.month,
            value,
            _selected.hour,
            _selected.minute,
            _selected.second,
          ),
        );
      case _DateTimePart.hour:
        return _boundedRange(
          0,
          23,
          part,
          (value) => DateTime(
            _selected.year,
            _selected.month,
            _selected.day,
            value,
            _selected.minute,
            _selected.second,
          ),
        );
      case _DateTimePart.minute:
        return _boundedRange(
          0,
          59,
          part,
          (value) => DateTime(
            _selected.year,
            _selected.month,
            _selected.day,
            _selected.hour,
            value,
            _selected.second,
          ),
        );
      case _DateTimePart.second:
        return _boundedRange(
          0,
          59,
          part,
          (value) => DateTime(
            _selected.year,
            _selected.month,
            _selected.day,
            _selected.hour,
            _selected.minute,
            value,
          ),
        );
    }
  }

  List<int> _boundedRange(
    int start,
    int end,
    _DateTimePart part,
    DateTime Function(int value) candidateBuilder,
  ) {
    if (widget.mode == UiDateTimePickerMode.time) {
      return _range(start, end);
    }
    return _range(start, end)
        .where((value) => _canRepresent(part, candidateBuilder(value)))
        .toList(growable: false);
  }

  bool _canRepresent(_DateTimePart part, DateTime candidate) {
    final minDate = widget.minDate;
    final maxDate = widget.maxDate;
    if (minDate != null && _compareByPart(candidate, minDate, part) < 0) {
      return false;
    }
    if (maxDate != null && _compareByPart(candidate, maxDate, part) > 0) {
      return false;
    }
    return true;
  }

  int _compareByPart(DateTime a, DateTime b, _DateTimePart part) {
    final left = _truncate(a, part);
    final right = _truncate(b, part);
    return left.compareTo(right);
  }

  DateTime _truncate(DateTime value, _DateTimePart part) {
    switch (part) {
      case _DateTimePart.year:
        return DateTime(value.year);
      case _DateTimePart.month:
        return DateTime(value.year, value.month);
      case _DateTimePart.day:
        return DateTime(value.year, value.month, value.day);
      case _DateTimePart.hour:
        return DateTime(value.year, value.month, value.day, value.hour);
      case _DateTimePart.minute:
        return DateTime(
          value.year,
          value.month,
          value.day,
          value.hour,
          value.minute,
        );
      case _DateTimePart.second:
        return DateTime(
          value.year,
          value.month,
          value.day,
          value.hour,
          value.minute,
          value.second,
        );
    }
  }

  void _select(_DateTimePart part, int value) {
    final daysInMonth = _daysInMonth(_selected.year, _selected.month);
    DateTime next;
    switch (part) {
      case _DateTimePart.year:
        next = DateTime(
          value,
          _selected.month,
          math.min(_selected.day, _daysInMonth(value, _selected.month)),
          _selected.hour,
          _selected.minute,
          _selected.second,
        );
        break;
      case _DateTimePart.month:
        next = DateTime(
          _selected.year,
          value,
          math.min(_selected.day, _daysInMonth(_selected.year, value)),
          _selected.hour,
          _selected.minute,
          _selected.second,
        );
        break;
      case _DateTimePart.day:
        next = DateTime(
          _selected.year,
          _selected.month,
          math.min(value, daysInMonth),
          _selected.hour,
          _selected.minute,
          _selected.second,
        );
        break;
      case _DateTimePart.hour:
        next = DateTime(
          _selected.year,
          _selected.month,
          _selected.day,
          value,
          _selected.minute,
          _selected.second,
        );
        break;
      case _DateTimePart.minute:
        next = DateTime(
          _selected.year,
          _selected.month,
          _selected.day,
          _selected.hour,
          value,
          _selected.second,
        );
        break;
      case _DateTimePart.second:
        next = DateTime(
          _selected.year,
          _selected.month,
          _selected.day,
          _selected.hour,
          _selected.minute,
          value,
        );
        break;
    }
    next = _clamp(next);
    setState(() => _selected = next);
    widget.onPreviewChanged?.call(next);
  }

  DateTime _clamp(DateTime value) {
    final normalized = widget.mode == UiDateTimePickerMode.time
        ? value
        : DateTime(
            value.year,
            value.month,
            math.min(value.day, _daysInMonth(value.year, value.month)),
            value.hour,
            value.minute,
            value.second,
          );
    if (widget.mode == UiDateTimePickerMode.time) {
      return normalized;
    }
    final minDate = widget.minDate;
    final maxDate = widget.maxDate;
    if (minDate != null && normalized.isBefore(minDate)) {
      return minDate;
    }
    if (maxDate != null && normalized.isAfter(maxDate)) {
      return maxDate;
    }
    return normalized;
  }

  int _valueFor(_DateTimePart part) {
    switch (part) {
      case _DateTimePart.year:
        return _selected.year;
      case _DateTimePart.month:
        return _selected.month;
      case _DateTimePart.day:
        return _selected.day;
      case _DateTimePart.hour:
        return _selected.hour;
      case _DateTimePart.minute:
        return _selected.minute;
      case _DateTimePart.second:
        return _selected.second;
    }
  }

  int get _minYear => widget.minDate?.year ?? 1900;
  int get _maxYear => widget.maxDate?.year ?? 2100;
}

class _DateTimeColumnWheel extends StatefulWidget {
  final _DateTimeColumn column;
  final double itemHeight;
  final double columnWidth;
  final ValueChanged<int> onChanged;

  const _DateTimeColumnWheel({
    required this.column,
    required this.itemHeight,
    required this.columnWidth,
    required this.onChanged,
  });

  @override
  State<_DateTimeColumnWheel> createState() => _DateTimeColumnWheelState();
}

class _DateTimeColumnWheelState extends State<_DateTimeColumnWheel> {
  late FixedExtentScrollController _controller;
  bool _syncingController = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(_DateTimeColumnWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = _selectedIndex;
    if (oldWidget.column.values != widget.column.values ||
        oldWidget.column.selectedValue != widget.column.selectedValue) {
      if (_controller.selectedItem != index) {
        _jumpToIndex(index);
      }
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
    return SizedBox(
      width: widget.columnWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6,
            right: 6,
            child: Container(
              height: widget.itemHeight,
              decoration: BoxDecoration(
                color: theme.primary.withValues(
                  alpha: theme.isDark ? 0.18 : 0.10,
                ),
                borderRadius: BorderRadius.circular(UiRadii.md),
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: const _DateTimeWheelScrollBehavior(),
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: widget.itemHeight,
              diameterRatio: 1.6,
              overAndUnderCenterOpacity: 0.52,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                if (!_syncingController &&
                    index >= 0 &&
                    index < widget.column.values.length) {
                  widget.onChanged(widget.column.values[index]);
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.column.values.length,
                builder: (context, index) {
                  final value = widget.column.values[index];
                  final selected = value == widget.column.selectedValue;
                  return Center(
                    child: Text(
                      '${value.toString().padLeft(_padFor(widget.column.part), '0')}${widget.column.unit}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? theme.primary : theme.textSecondary,
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _selectedIndex {
    final index = widget.column.values.indexOf(widget.column.selectedValue);
    return index < 0 ? 0 : index;
  }

  void _jumpToIndex(int index) {
    _syncingController = true;
    _controller.jumpToItem(index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _syncingController = false;
      }
    });
  }
}

class _DateTimeColumn {
  final _DateTimePart part;
  final List<int> values;
  final int selectedValue;
  final String unit;

  const _DateTimeColumn({
    required this.part,
    required this.values,
    required this.selectedValue,
    required this.unit,
  });
}

enum _DateTimePart { year, month, day, hour, minute, second }

class _DateTimeWheelScrollBehavior extends MaterialScrollBehavior {
  const _DateTimeWheelScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return const {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.stylus,
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.trackpad,
    };
  }
}

class _DateTimeIconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DateTimeIconAction({
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
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _UiDateTimeFieldMetrics {
  final double fieldHeight;
  final double paddingX;
  final double inputFontSize;
  final double labelFontSize;
  final double labelGap;
  final double iconSize;

  const _UiDateTimeFieldMetrics({
    required this.fieldHeight,
    required this.paddingX,
    required this.inputFontSize,
    required this.labelFontSize,
    required this.labelGap,
    required this.iconSize,
  });

  factory _UiDateTimeFieldMetrics.forSize(UiTextFieldSize size) {
    switch (size) {
      case UiTextFieldSize.compact:
        return const _UiDateTimeFieldMetrics(
          fieldHeight: 34,
          paddingX: 10,
          inputFontSize: 13,
          labelFontSize: 12,
          labelGap: 5,
          iconSize: 18,
        );
      case UiTextFieldSize.medium:
        return const _UiDateTimeFieldMetrics(
          fieldHeight: 42,
          paddingX: 12,
          inputFontSize: 14,
          labelFontSize: 13,
          labelGap: 6,
          iconSize: 20,
        );
    }
  }
}

List<int> _range(int start, int end) {
  if (end < start) {
    return const [];
  }
  return List.generate(end - start + 1, (index) => start + index);
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

List<_DateTimePart> _partsForMode(UiDateTimePickerMode mode) {
  switch (mode) {
    case UiDateTimePickerMode.year:
      return const [_DateTimePart.year];
    case UiDateTimePickerMode.month:
      return const [_DateTimePart.year, _DateTimePart.month];
    case UiDateTimePickerMode.date:
      return const [_DateTimePart.year, _DateTimePart.month, _DateTimePart.day];
    case UiDateTimePickerMode.hour:
      return const [
        _DateTimePart.year,
        _DateTimePart.month,
        _DateTimePart.day,
        _DateTimePart.hour,
      ];
    case UiDateTimePickerMode.minute:
      return const [
        _DateTimePart.year,
        _DateTimePart.month,
        _DateTimePart.day,
        _DateTimePart.hour,
        _DateTimePart.minute,
      ];
    case UiDateTimePickerMode.second:
      return const [
        _DateTimePart.year,
        _DateTimePart.month,
        _DateTimePart.day,
        _DateTimePart.hour,
        _DateTimePart.minute,
        _DateTimePart.second,
      ];
    case UiDateTimePickerMode.time:
      return const [
        _DateTimePart.hour,
        _DateTimePart.minute,
        _DateTimePart.second,
      ];
  }
}

String _unitFor(_DateTimePart part) {
  switch (part) {
    case _DateTimePart.year:
      return '年';
    case _DateTimePart.month:
      return '月';
    case _DateTimePart.day:
      return '日';
    case _DateTimePart.hour:
      return '时';
    case _DateTimePart.minute:
      return '分';
    case _DateTimePart.second:
      return '秒';
  }
}

int _padFor(_DateTimePart part) {
  switch (part) {
    case _DateTimePart.year:
      return 4;
    case _DateTimePart.month:
    case _DateTimePart.day:
    case _DateTimePart.hour:
    case _DateTimePart.minute:
    case _DateTimePart.second:
      return 2;
  }
}
