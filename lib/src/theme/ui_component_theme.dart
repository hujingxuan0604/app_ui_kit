import 'package:flutter/material.dart';

import '../tokens/ui_radii.dart';

@immutable
class UiComponentTheme {
  final UiButtonTheme button;
  final UiInputTheme input;
  final UiCardTheme card;
  final UiDialogTheme dialog;
  final UiTabsTheme tabs;

  const UiComponentTheme({
    this.button = const UiButtonTheme(),
    this.input = const UiInputTheme(),
    this.card = const UiCardTheme(),
    this.dialog = const UiDialogTheme(),
    this.tabs = const UiTabsTheme(),
  });

  UiComponentTheme copyWith({
    UiButtonTheme? button,
    UiInputTheme? input,
    UiCardTheme? card,
    UiDialogTheme? dialog,
    UiTabsTheme? tabs,
  }) {
    return UiComponentTheme(
      button: button ?? this.button,
      input: input ?? this.input,
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
      input: UiInputTheme.lerp(a.input, b.input, t),
      card: UiCardTheme.lerp(a.card, b.card, t),
      dialog: UiDialogTheme.lerp(a.dialog, b.dialog, t),
      tabs: UiTabsTheme.lerp(a.tabs, b.tabs, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiComponentTheme &&
        other.button == button &&
        other.input == input &&
        other.card == card &&
        other.dialog == dialog &&
        other.tabs == tabs;
  }

  @override
  int get hashCode => Object.hash(button, input, card, dialog, tabs);
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
class UiInputTheme {
  final double radius;
  final EdgeInsetsGeometry contentPadding;

  const UiInputTheme({
    this.radius = UiRadii.md,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
  });

  static UiInputTheme lerp(UiInputTheme a, UiInputTheme b, double t) {
    return UiInputTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t) ??
          b.contentPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiInputTheme &&
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
  final EdgeInsetsGeometry padding;
  final double smallHeight;
  final double mediumHeight;
  final double largeHeight;
  final double itemMinWidth;

  const UiTabsTheme({
    this.radius = UiRadii.lg,
    this.indicatorRadius = UiRadii.md,
    this.padding = const EdgeInsets.all(4),
    this.smallHeight = 30,
    this.mediumHeight = 36,
    this.largeHeight = 42,
    this.itemMinWidth = 88,
  });

  static UiTabsTheme lerp(UiTabsTheme a, UiTabsTheme b, double t) {
    return UiTabsTheme(
      radius: _lerpDouble(a.radius, b.radius, t),
      indicatorRadius: _lerpDouble(a.indicatorRadius, b.indicatorRadius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ?? b.padding,
      smallHeight: _lerpDouble(a.smallHeight, b.smallHeight, t),
      mediumHeight: _lerpDouble(a.mediumHeight, b.mediumHeight, t),
      largeHeight: _lerpDouble(a.largeHeight, b.largeHeight, t),
      itemMinWidth: _lerpDouble(a.itemMinWidth, b.itemMinWidth, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UiTabsTheme &&
        other.radius == radius &&
        other.indicatorRadius == indicatorRadius &&
        other.padding == padding &&
        other.smallHeight == smallHeight &&
        other.mediumHeight == mediumHeight &&
        other.largeHeight == largeHeight &&
        other.itemMinWidth == itemMinWidth;
  }

  @override
  int get hashCode => Object.hash(
    radius,
    indicatorRadius,
    padding,
    smallHeight,
    mediumHeight,
    largeHeight,
    itemMinWidth,
  );
}

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
