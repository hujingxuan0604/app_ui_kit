import 'package:flutter/material.dart';

import '../tokens/ui_radii.dart';

@immutable
class UiComponentTheme {
  final UiButtonTheme button;
  final UiTextFieldTheme textField;
  final UiCardTheme card;
  final UiDialogTheme dialog;
  final UiTabsTheme tabs;

  const UiComponentTheme({
    this.button = const UiButtonTheme(),
    this.textField = const UiTextFieldTheme(),
    this.card = const UiCardTheme(),
    this.dialog = const UiDialogTheme(),
    this.tabs = const UiTabsTheme(),
  });

  UiComponentTheme copyWith({
    UiButtonTheme? button,
    UiTextFieldTheme? textField,
    UiCardTheme? card,
    UiDialogTheme? dialog,
    UiTabsTheme? tabs,
  }) {
    return UiComponentTheme(
      button: button ?? this.button,
      textField: textField ?? this.textField,
      card: card ?? this.card,
      dialog: dialog ?? this.dialog,
      tabs: tabs ?? this.tabs,
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
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiComponentTheme &&
        other.button == button &&
        other.textField == textField &&
        other.card == card &&
        other.dialog == dialog &&
        other.tabs == tabs;
  }

  @override
  int get hashCode => Object.hash(button, textField, card, dialog, tabs);
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

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
