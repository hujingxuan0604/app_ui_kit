import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_spacing.dart';

enum UiCalendarSelectionMode { single, multiple, range }

typedef UiCalendarDayPredicate = bool Function(DateTime date);

typedef UiCalendarDayBuilder =
    Widget Function(BuildContext context, UiCalendarDayDetails details);

class UiCalendarDayDetails {
  final DateTime date;
  final bool inCurrentMonth;
  final bool selected;
  final bool rangeStart;
  final bool rangeEnd;
  final bool inRange;
  final bool disabled;
  final bool today;

  const UiCalendarDayDetails({
    required this.date,
    required this.inCurrentMonth,
    required this.selected,
    required this.rangeStart,
    required this.rangeEnd,
    required this.inRange,
    required this.disabled,
    required this.today,
  });
}

class UiCalendar extends StatefulWidget {
  final UiCalendarSelectionMode selectionMode;
  final Object? _rawValue;
  final ValueChanged<DateTime?>? _singleOnChanged;
  final ValueChanged<List<DateTime>>? _multiOnChanged;
  final ValueChanged<DateTimeRange?>? _rangeOnChanged;
  final DateTime? initialMonth;
  final DateTime? minDate;
  final DateTime? maxDate;
  final int firstDayOfWeek;
  final String? title;
  final bool showHeader;
  final bool showBorder;
  final UiCalendarDayPredicate? selectableDayPredicate;
  final UiCalendarDayBuilder? dayBuilder;
  final ValueChanged<DateTime>? onMonthChanged;

  const UiCalendar({
    super.key,
    DateTime? value,
    ValueChanged<DateTime?>? onChanged,
    this.initialMonth,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 0,
    this.title,
    this.showHeader = true,
    this.showBorder = true,
    this.selectableDayPredicate,
    this.dayBuilder,
    this.onMonthChanged,
  }) : selectionMode = UiCalendarSelectionMode.single,
       _rawValue = value,
       _singleOnChanged = onChanged,
       _multiOnChanged = null,
       _rangeOnChanged = null;

  const UiCalendar.multiple({
    super.key,
    List<DateTime> value = const [],
    ValueChanged<List<DateTime>>? onChanged,
    this.initialMonth,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 0,
    this.title,
    this.showHeader = true,
    this.showBorder = true,
    this.selectableDayPredicate,
    this.dayBuilder,
    this.onMonthChanged,
  }) : selectionMode = UiCalendarSelectionMode.multiple,
       _rawValue = value,
       _singleOnChanged = null,
       _multiOnChanged = onChanged,
       _rangeOnChanged = null;

  const UiCalendar.range({
    super.key,
    DateTimeRange? value,
    ValueChanged<DateTimeRange?>? onChanged,
    this.initialMonth,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 0,
    this.title,
    this.showHeader = true,
    this.showBorder = true,
    this.selectableDayPredicate,
    this.dayBuilder,
    this.onMonthChanged,
  }) : selectionMode = UiCalendarSelectionMode.range,
       _rawValue = value,
       _singleOnChanged = null,
       _multiOnChanged = null,
       _rangeOnChanged = onChanged;

  Object? get value => _rawValue;

  @override
  State<UiCalendar> createState() => _UiCalendarState();
}

class _UiCalendarState extends State<UiCalendar> {
  late DateTime _visibleMonth;
  DateTime? _pendingRangeStart;

  @override
  void initState() {
    super.initState();
    _visibleMonth = _monthStart(
      widget.initialMonth ?? _firstValueDate ?? DateTime.now(),
    );
  }

  @override
  void didUpdateWidget(UiCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionMode != widget.selectionMode) {
      _pendingRangeStart = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.firstDayOfWeek >= 0 && widget.firstDayOfWeek <= 6,
      'UiCalendar firstDayOfWeek must be in 0...6.',
    );

    final theme = context.uiTheme;
    final calendarTheme = theme.components.calendar;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader) _buildHeader(context, theme),
        _buildWeekdays(context, theme),
        _buildGrid(context, theme),
      ],
    );

    return AnimatedContainer(
      duration: UiMotion.normal,
      padding: calendarTheme.padding,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(calendarTheme.radius),
        border: widget.showBorder
            ? Border.all(color: theme.border.withValues(alpha: 0.82))
            : null,
      ),
      child: content,
    );
  }

  Widget _buildHeader(BuildContext context, UiThemeData theme) {
    final calendarTheme = theme.components.calendar;
    return SizedBox(
      height: calendarTheme.headerHeight,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: () => _changeMonth(-1),
            icon: const Icon(Icons.chevron_left_rounded),
            color: theme.textSecondary,
            iconSize: UiSpacing.iconMd,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 34, height: 34),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.title ?? _formatMonth(_visibleMonth),
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Next month',
            onPressed: () => _changeMonth(1),
            icon: const Icon(Icons.chevron_right_rounded),
            color: theme.textSecondary,
            iconSize: UiSpacing.iconMd,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 34, height: 34),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdays(BuildContext context, UiThemeData theme) {
    final calendarTheme = theme.components.calendar;
    return SizedBox(
      height: calendarTheme.weekdayHeight,
      child: Row(
        children: _weekdayLabels
            .map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, UiThemeData theme) {
    final calendarTheme = theme.components.calendar;
    final first = _monthStart(_visibleMonth);
    final startOffset =
        (_sundayBasedWeekday(first) - widget.firstDayOfWeek + 7) % 7;
    final firstCell = first.subtract(Duration(days: startOffset));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(6, (week) {
        return SizedBox(
          height: calendarTheme.dayCellHeight,
          child: Row(
            children: List.generate(7, (day) {
              final date = _dateOnly(
                firstCell.add(Duration(days: week * 7 + day)),
              );
              return Expanded(child: _buildDayCell(context, theme, date));
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(BuildContext context, UiThemeData theme, DateTime date) {
    final details = _detailsFor(date);
    if (widget.dayBuilder != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(
          theme.components.calendar.cellRadius,
        ),
        onTap: details.disabled ? null : () => _selectDate(date),
        child: widget.dayBuilder!(context, details),
      );
    }

    final foreground = _dayForeground(theme, details);
    final background = _dayBackground(theme, details);
    final rangeColor = theme.primary.withValues(
      alpha: theme.isDark ? 0.20 : 0.12,
    );

    Widget cell = Center(
      child: AnimatedContainer(
        duration: UiMotion.fast,
        curve: UiMotion.standard,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(
            theme.components.calendar.cellRadius,
          ),
          border: details.today && !details.selected
              ? Border.all(color: theme.primary.withValues(alpha: 0.72))
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: foreground,
              fontSize: 13,
              fontWeight: details.selected || details.today
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    if (details.inRange && !details.selected) {
      cell = Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: rangeColor,
        child: cell,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(theme.components.calendar.cellRadius),
      onTap: details.disabled ? null : () => _selectDate(date),
      child: cell,
    );
  }

  Color _dayForeground(UiThemeData theme, UiCalendarDayDetails details) {
    if (details.disabled) {
      return theme.textTertiary.withValues(alpha: 0.48);
    }
    if (details.selected) {
      return Colors.white;
    }
    if (!details.inCurrentMonth) {
      return theme.textTertiary.withValues(alpha: 0.68);
    }
    if (details.today) {
      return theme.primary;
    }
    return theme.textPrimary;
  }

  Color? _dayBackground(UiThemeData theme, UiCalendarDayDetails details) {
    if (details.selected) {
      return theme.primary;
    }
    if (details.today) {
      return theme.primary.withValues(alpha: theme.isDark ? 0.16 : 0.09);
    }
    return null;
  }

  UiCalendarDayDetails _detailsFor(DateTime date) {
    final normalized = _dateOnly(date);
    final selectedDates = _selectedDates;
    final selected = selectedDates.any((value) => _sameDate(value, normalized));
    final range = _selectedRange;
    final pendingStart = _pendingRangeStart;
    final isPendingStart =
        pendingStart != null && _sameDate(pendingStart, normalized);
    final rangeStart = range != null && _sameDate(range.start, normalized);
    final rangeEnd = range != null && _sameDate(range.end, normalized);
    final inRange =
        range != null &&
        !_sameDate(range.start, normalized) &&
        !_sameDate(range.end, normalized) &&
        !_isBefore(normalized, range.start) &&
        !_isAfter(normalized, range.end);

    return UiCalendarDayDetails(
      date: normalized,
      inCurrentMonth:
          normalized.month == _visibleMonth.month &&
          normalized.year == _visibleMonth.year,
      selected: selected || rangeStart || rangeEnd || isPendingStart,
      rangeStart: rangeStart || isPendingStart,
      rangeEnd: rangeEnd,
      inRange: inRange,
      disabled: _isDisabled(normalized),
      today: _sameDate(normalized, DateTime.now()),
    );
  }

  List<DateTime> get _selectedDates {
    switch (widget.selectionMode) {
      case UiCalendarSelectionMode.single:
        final value = widget.value;
        return value is DateTime ? [_dateOnly(value)] : const [];
      case UiCalendarSelectionMode.multiple:
        final value = widget.value;
        if (value is List<DateTime>) {
          return value.map(_dateOnly).toList(growable: false);
        }
        return const [];
      case UiCalendarSelectionMode.range:
        return const [];
    }
  }

  DateTimeRange? get _selectedRange {
    final value = widget.value;
    if (widget.selectionMode == UiCalendarSelectionMode.range &&
        value is DateTimeRange) {
      return DateTimeRange(
        start: _dateOnly(value.start),
        end: _dateOnly(value.end),
      );
    }
    return null;
  }

  DateTime? get _firstValueDate {
    final value = widget.value;
    if (value is DateTime) {
      return value;
    }
    if (value is List<DateTime> && value.isNotEmpty) {
      return value.first;
    }
    if (value is DateTimeRange) {
      return value.start;
    }
    return null;
  }

  List<String> get _weekdayLabels {
    const labels = ['日', '一', '二', '三', '四', '五', '六'];
    return List.generate(
      7,
      (index) => labels[(widget.firstDayOfWeek + index) % 7],
    );
  }

  void _changeMonth(int delta) {
    final next = _addMonths(_visibleMonth, delta);
    setState(() => _visibleMonth = next);
    widget.onMonthChanged?.call(next);
  }

  void _selectDate(DateTime date) {
    final normalized = _dateOnly(date);
    if (_isDisabled(normalized)) {
      return;
    }
    switch (widget.selectionMode) {
      case UiCalendarSelectionMode.single:
        widget._singleOnChanged?.call(normalized);
        break;
      case UiCalendarSelectionMode.multiple:
        final values = List<DateTime>.of(_selectedDates);
        final index = values.indexWhere(
          (value) => _sameDate(value, normalized),
        );
        if (index >= 0) {
          values.removeAt(index);
        } else {
          values.add(normalized);
        }
        values.sort();
        widget._multiOnChanged?.call(List<DateTime>.unmodifiable(values));
        break;
      case UiCalendarSelectionMode.range:
        final pending = _pendingRangeStart;
        if (pending == null) {
          setState(() => _pendingRangeStart = normalized);
          widget._rangeOnChanged?.call(null);
        } else {
          final start = _isAfter(pending, normalized) ? normalized : pending;
          final end = _isAfter(pending, normalized) ? pending : normalized;
          setState(() => _pendingRangeStart = null);
          widget._rangeOnChanged?.call(DateTimeRange(start: start, end: end));
        }
        break;
    }
  }

  bool _isDisabled(DateTime date) {
    final minDate = widget.minDate == null ? null : _dateOnly(widget.minDate!);
    final maxDate = widget.maxDate == null ? null : _dateOnly(widget.maxDate!);
    if (minDate != null && _isBefore(date, minDate)) {
      return true;
    }
    if (maxDate != null && _isAfter(date, maxDate)) {
      return true;
    }
    return widget.selectableDayPredicate?.call(date) == false;
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _monthStart(DateTime value) => DateTime(value.year, value.month);

DateTime _addMonths(DateTime value, int delta) {
  return DateTime(value.year, value.month + delta);
}

int _sundayBasedWeekday(DateTime value) => value.weekday % 7;

bool _sameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _isBefore(DateTime a, DateTime b) => a.compareTo(b) < 0;

bool _isAfter(DateTime a, DateTime b) => a.compareTo(b) > 0;

String _formatMonth(DateTime value) {
  return '${value.year}-${value.month.toString().padLeft(2, '0')}';
}
