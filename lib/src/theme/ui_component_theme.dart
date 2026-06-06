import 'package:flutter/material.dart';

import '../tokens/ui_radii.dart';

@immutable
class UiComponentTheme {
  final UiButtonTheme button;
  final UiTextFieldTheme textField;
  final UiCardTheme card;
  final UiDialogTheme dialog;
  final UiTabsTheme tabs;
  final UiBottomPopupTheme bottomPopup;
  final UiSideDrawerTheme sideDrawer;
  final UiCalendarTheme calendar;
  final UiDateTimePickerTheme dateTimePicker;

  const UiComponentTheme({
    this.button = const UiButtonTheme(),
    this.textField = const UiTextFieldTheme(),
    this.card = const UiCardTheme(),
    this.dialog = const UiDialogTheme(),
    this.tabs = const UiTabsTheme(),
    this.bottomPopup = const UiBottomPopupTheme(),
    this.sideDrawer = const UiSideDrawerTheme(),
    this.calendar = const UiCalendarTheme(),
    this.dateTimePicker = const UiDateTimePickerTheme(),
  });

  UiComponentTheme copyWith({
    UiButtonTheme? button,
    UiTextFieldTheme? textField,
    UiCardTheme? card,
    UiDialogTheme? dialog,
    UiTabsTheme? tabs,
    UiBottomPopupTheme? bottomPopup,
    UiSideDrawerTheme? sideDrawer,
    UiCalendarTheme? calendar,
    UiDateTimePickerTheme? dateTimePicker,
  }) {
    return UiComponentTheme(
      button: button ?? this.button,
      textField: textField ?? this.textField,
      card: card ?? this.card,
      dialog: dialog ?? this.dialog,
      tabs: tabs ?? this.tabs,
      bottomPopup: bottomPopup ?? this.bottomPopup,
      sideDrawer: sideDrawer ?? this.sideDrawer,
      calendar: calendar ?? this.calendar,
      dateTimePicker: dateTimePicker ?? this.dateTimePicker,
    );
  }

  static UiComponentTheme lerp(
    UiComponentTheme a,
    UiComponentTheme b,
    double t,
  ) {
    return UiComponentTheme(
      button: UiButtonTheme.lerp(a.button, b.button, t),
      textField: UiTextFieldTheme.lerp(a.textField, b.textField, t),
      card: UiCardTheme.lerp(a.card, b.card, t),
      dialog: UiDialogTheme.lerp(a.dialog, b.dialog, t),
      tabs: UiTabsTheme.lerp(a.tabs, b.tabs, t),
      bottomPopup: UiBottomPopupTheme.lerp(a.bottomPopup, b.bottomPopup, t),
      sideDrawer: UiSideDrawerTheme.lerp(a.sideDrawer, b.sideDrawer, t),
      calendar: UiCalendarTheme.lerp(a.calendar, b.calendar, t),
      dateTimePicker: UiDateTimePickerTheme.lerp(
        a.dateTimePicker,
        b.dateTimePicker,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiComponentTheme &&
        other.button == button &&
        other.textField == textField &&
        other.card == card &&
        other.dialog == dialog &&
        other.tabs == tabs &&
        other.bottomPopup == bottomPopup &&
        other.sideDrawer == sideDrawer &&
        other.calendar == calendar &&
        other.dateTimePicker == dateTimePicker;
  }

  @override
  int get hashCode => Object.hash(
    button,
    textField,
    card,
    dialog,
    tabs,
    bottomPopup,
    sideDrawer,
    calendar,
    dateTimePicker,
  );
}

@immutable
class UiButtonTheme {
  final double radius;
  final EdgeInsetsGeometry smallPadding;
  final EdgeInsetsGeometry mediumPadding;
  final EdgeInsetsGeometry largePadding;

  const UiButtonTheme({
    this.radius = UiRadii.lg,
    this.smallPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.mediumPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    this.largePadding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  });

  static UiButtonTheme lerp(UiButtonTheme a, UiButtonTheme b, double t) {
    return UiButtonTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      smallPadding:
          EdgeInsetsGeometry.lerp(a.smallPadding, b.smallPadding, t) ??
          b.smallPadding,
      mediumPadding:
          EdgeInsetsGeometry.lerp(a.mediumPadding, b.mediumPadding, t) ??
          b.mediumPadding,
      largePadding:
          EdgeInsetsGeometry.lerp(a.largePadding, b.largePadding, t) ??
          b.largePadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiButtonTheme &&
        other.radius == radius &&
        other.smallPadding == smallPadding &&
        other.mediumPadding == mediumPadding &&
        other.largePadding == largePadding;
  }

  @override
  int get hashCode =>
      Object.hash(radius, smallPadding, mediumPadding, largePadding);
}

@immutable
class UiTextFieldTheme {
  final double radius;
  final EdgeInsetsGeometry contentPadding;

  const UiTextFieldTheme({
    this.radius = UiRadii.md,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
  });

  static UiTextFieldTheme lerp(
    UiTextFieldTheme a,
    UiTextFieldTheme b,
    double t,
  ) {
    return UiTextFieldTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t) ??
          b.contentPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiTextFieldTheme &&
        other.radius == radius &&
        other.contentPadding == contentPadding;
  }

  @override
  int get hashCode => Object.hash(radius, contentPadding);
}

@immutable
class UiCardTheme {
  final double radius;
  final EdgeInsetsGeometry padding;

  const UiCardTheme({
    this.radius = UiRadii.lg,
    this.padding = const EdgeInsets.all(14),
  });

  static UiCardTheme lerp(UiCardTheme a, UiCardTheme b, double t) {
    return UiCardTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiCardTheme &&
        other.radius == radius &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(radius, padding);
}

@immutable
class UiDialogTheme {
  final double radius;
  final double width;

  const UiDialogTheme({this.radius = UiRadii.xl, this.width = 360});

  static UiDialogTheme lerp(UiDialogTheme a, UiDialogTheme b, double t) {
    return UiDialogTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      width: _lerpDouble(a.width, b.width, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiDialogTheme &&
        other.radius == radius &&
        other.width == width;
  }

  @override
  int get hashCode => Object.hash(radius, width);
}

@immutable
class UiTabsTheme {
  final double radius;
  final double indicatorRadius;
  final double contentRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final double smallHeight;
  final double mediumHeight;
  final double largeHeight;
  final double smallUnderlineHeight;
  final double mediumUnderlineHeight;
  final double largeUnderlineHeight;
  final double itemMinWidth;
  final double contentMinHeight;
  final double contentGap;

  const UiTabsTheme({
    this.radius = UiRadii.lg,
    this.indicatorRadius = UiRadii.md,
    this.contentRadius = UiRadii.lg,
    this.padding = const EdgeInsets.all(4),
    this.contentPadding = const EdgeInsets.all(16),
    this.smallHeight = 30,
    this.mediumHeight = 36,
    this.largeHeight = 42,
    this.smallUnderlineHeight = 40,
    this.mediumUnderlineHeight = 48,
    this.largeUnderlineHeight = 56,
    this.itemMinWidth = 88,
    this.contentMinHeight = 120,
    this.contentGap = 8,
  });

  static UiTabsTheme lerp(UiTabsTheme a, UiTabsTheme b, double t) {
    return UiTabsTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      indicatorRadius: _lerpDouble(a.indicatorRadius, b.indicatorRadius, t),
      contentRadius: _lerpDouble(a.contentRadius, b.contentRadius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t) ??
          b.contentPadding,
      smallHeight: _lerpDouble(a.smallHeight, b.smallHeight, t),
      mediumHeight: _lerpDouble(a.mediumHeight, b.mediumHeight, t),
      largeHeight: _lerpDouble(a.largeHeight, b.largeHeight, t),
      smallUnderlineHeight: _lerpDouble(
        a.smallUnderlineHeight,
        b.smallUnderlineHeight,
        t,
      ),
      mediumUnderlineHeight: _lerpDouble(
        a.mediumUnderlineHeight,
        b.mediumUnderlineHeight,
        t,
      ),
      largeUnderlineHeight: _lerpDouble(
        a.largeUnderlineHeight,
        b.largeUnderlineHeight,
        t,
      ),
      itemMinWidth: _lerpDouble(a.itemMinWidth, b.itemMinWidth, t),
      contentMinHeight: _lerpDouble(a.contentMinHeight, b.contentMinHeight, t),
      contentGap: _lerpDouble(a.contentGap, b.contentGap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiTabsTheme &&
        other.radius == radius &&
        other.indicatorRadius == indicatorRadius &&
        other.contentRadius == contentRadius &&
        other.padding == padding &&
        other.contentPadding == contentPadding &&
        other.smallHeight == smallHeight &&
        other.mediumHeight == mediumHeight &&
        other.largeHeight == largeHeight &&
        other.smallUnderlineHeight == smallUnderlineHeight &&
        other.mediumUnderlineHeight == mediumUnderlineHeight &&
        other.largeUnderlineHeight == largeUnderlineHeight &&
        other.itemMinWidth == itemMinWidth &&
        other.contentMinHeight == contentMinHeight &&
        other.contentGap == contentGap;
  }

  @override
  int get hashCode => Object.hashAll([
    radius,
    indicatorRadius,
    contentRadius,
    padding,
    contentPadding,
    smallHeight,
    mediumHeight,
    largeHeight,
    smallUnderlineHeight,
    mediumUnderlineHeight,
    largeUnderlineHeight,
    itemMinWidth,
    contentMinHeight,
    contentGap,
  ]);
}

@immutable
class UiBottomPopupTheme {
  final double radius;
  final double maxWidth;
  final double maxHeightFactor;
  final double dragHandleWidth;
  final double dragHandleHeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;

  const UiBottomPopupTheme({
    this.radius = UiRadii.xxl,
    this.maxWidth = 560,
    this.maxHeightFactor = 0.86,
    this.dragHandleWidth = 40,
    this.dragHandleHeight = 4,
    this.padding = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.fromLTRB(20, 10, 20, 12),
    this.contentPadding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
  });

  static UiBottomPopupTheme lerp(
    UiBottomPopupTheme a,
    UiBottomPopupTheme b,
    double t,
  ) {
    return UiBottomPopupTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      maxWidth: _lerpDouble(a.maxWidth, b.maxWidth, t),
      maxHeightFactor: _lerpDouble(a.maxHeightFactor, b.maxHeightFactor, t),
      dragHandleWidth: _lerpDouble(a.dragHandleWidth, b.dragHandleWidth, t),
      dragHandleHeight: _lerpDouble(a.dragHandleHeight, b.dragHandleHeight, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
      headerPadding:
          EdgeInsetsGeometry.lerp(a.headerPadding, b.headerPadding, t) ??
          b.headerPadding,
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t) ??
          b.contentPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiBottomPopupTheme &&
        other.radius == radius &&
        other.maxWidth == maxWidth &&
        other.maxHeightFactor == maxHeightFactor &&
        other.dragHandleWidth == dragHandleWidth &&
        other.dragHandleHeight == dragHandleHeight &&
        other.padding == padding &&
        other.headerPadding == headerPadding &&
        other.contentPadding == contentPadding;
  }

  @override
  int get hashCode => Object.hash(
    radius,
    maxWidth,
    maxHeightFactor,
    dragHandleWidth,
    dragHandleHeight,
    padding,
    headerPadding,
    contentPadding,
  );
}

@immutable
class UiSideDrawerTheme {
  final double width;
  final double maxWidthFactor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry footerPadding;

  const UiSideDrawerTheme({
    this.width = 320,
    this.maxWidthFactor = 0.92,
    this.radius = UiRadii.xl,
    this.padding = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.fromLTRB(20, 18, 20, 12),
    this.contentPadding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.footerPadding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
  });

  static UiSideDrawerTheme lerp(
    UiSideDrawerTheme a,
    UiSideDrawerTheme b,
    double t,
  ) {
    return UiSideDrawerTheme(
      width: _lerpDouble(a.width, b.width, t),
      maxWidthFactor: _lerpDouble(a.maxWidthFactor, b.maxWidthFactor, t),
      radius: _lerpDouble(a.radius, b.radius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
      headerPadding:
          EdgeInsetsGeometry.lerp(a.headerPadding, b.headerPadding, t) ??
          b.headerPadding,
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t) ??
          b.contentPadding,
      footerPadding:
          EdgeInsetsGeometry.lerp(a.footerPadding, b.footerPadding, t) ??
          b.footerPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiSideDrawerTheme &&
        other.width == width &&
        other.maxWidthFactor == maxWidthFactor &&
        other.radius == radius &&
        other.padding == padding &&
        other.headerPadding == headerPadding &&
        other.contentPadding == contentPadding &&
        other.footerPadding == footerPadding;
  }

  @override
  int get hashCode => Object.hash(
    width,
    maxWidthFactor,
    radius,
    padding,
    headerPadding,
    contentPadding,
    footerPadding,
  );
}

@immutable
class UiCalendarTheme {
  final double radius;
  final double cellRadius;
  final EdgeInsetsGeometry padding;
  final double headerHeight;
  final double weekdayHeight;
  final double dayCellHeight;

  const UiCalendarTheme({
    this.radius = UiRadii.lg,
    this.cellRadius = UiRadii.md,
    this.padding = const EdgeInsets.all(12),
    this.headerHeight = 40,
    this.weekdayHeight = 28,
    this.dayCellHeight = 42,
  });

  static UiCalendarTheme lerp(UiCalendarTheme a, UiCalendarTheme b, double t) {
    return UiCalendarTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      cellRadius: _lerpDouble(a.cellRadius, b.cellRadius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
      headerHeight: _lerpDouble(a.headerHeight, b.headerHeight, t),
      weekdayHeight: _lerpDouble(a.weekdayHeight, b.weekdayHeight, t),
      dayCellHeight: _lerpDouble(a.dayCellHeight, b.dayCellHeight, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiCalendarTheme &&
        other.radius == radius &&
        other.cellRadius == cellRadius &&
        other.padding == padding &&
        other.headerHeight == headerHeight &&
        other.weekdayHeight == weekdayHeight &&
        other.dayCellHeight == dayCellHeight;
  }

  @override
  int get hashCode => Object.hash(
    radius,
    cellRadius,
    padding,
    headerHeight,
    weekdayHeight,
    dayCellHeight,
  );
}

@immutable
class UiDateTimePickerTheme {
  final double radius;
  final double panelWidth;
  final double panelMaxHeight;
  final double columnWidth;
  final double itemHeight;
  final double visibleItemCount;
  final EdgeInsetsGeometry panelPadding;

  const UiDateTimePickerTheme({
    this.radius = UiRadii.lg,
    this.panelWidth = 360,
    this.panelMaxHeight = 440,
    this.columnWidth = 92,
    this.itemHeight = 36,
    this.visibleItemCount = 5,
    this.panelPadding = const EdgeInsets.all(12),
  });

  static UiDateTimePickerTheme lerp(
    UiDateTimePickerTheme a,
    UiDateTimePickerTheme b,
    double t,
  ) {
    return UiDateTimePickerTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      panelWidth: _lerpDouble(a.panelWidth, b.panelWidth, t),
      panelMaxHeight: _lerpDouble(a.panelMaxHeight, b.panelMaxHeight, t),
      columnWidth: _lerpDouble(a.columnWidth, b.columnWidth, t),
      itemHeight: _lerpDouble(a.itemHeight, b.itemHeight, t),
      visibleItemCount: _lerpDouble(a.visibleItemCount, b.visibleItemCount, t),
      panelPadding:
          EdgeInsetsGeometry.lerp(a.panelPadding, b.panelPadding, t) ??
          b.panelPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiDateTimePickerTheme &&
        other.radius == radius &&
        other.panelWidth == panelWidth &&
        other.panelMaxHeight == panelMaxHeight &&
        other.columnWidth == columnWidth &&
        other.itemHeight == itemHeight &&
        other.visibleItemCount == visibleItemCount &&
        other.panelPadding == panelPadding;
  }

  @override
  int get hashCode => Object.hash(
    radius,
    panelWidth,
    panelMaxHeight,
    columnWidth,
    itemHeight,
    visibleItemCount,
    panelPadding,
  );
}

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
