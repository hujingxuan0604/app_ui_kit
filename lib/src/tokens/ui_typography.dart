import 'package:flutter/material.dart';

class UiTypography {
  const UiTypography._();

  static const String fontFamily = 'Inter';
  static const String fontFamilyFallback = 'PingFang SC';

  static const double h1 = 24;
  static const double h2 = 20;
  static const double h3 = 16;
  static const double h4 = 14;
  static const double body = 14;
  static const double bodySmall = 13;
  static const double caption = 12;
  static const double overline = 11;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  static TextStyle get h1Style => const TextStyle(
    fontSize: h1,
    fontWeight: semibold,
    height: lineHeightTight,
    fontFamily: fontFamily,
  );

  static TextStyle get h2Style => const TextStyle(
    fontSize: h2,
    fontWeight: semibold,
    height: lineHeightTight,
    fontFamily: fontFamily,
  );

  static TextStyle get h3Style => const TextStyle(
    fontSize: h3,
    fontWeight: semibold,
    height: lineHeightNormal,
    fontFamily: fontFamily,
  );

  static TextStyle get h4Style => const TextStyle(
    fontSize: h4,
    fontWeight: semibold,
    height: lineHeightNormal,
    fontFamily: fontFamily,
  );

  static TextStyle get bodyStyle => const TextStyle(
    fontSize: body,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: fontFamily,
  );

  static TextStyle get bodySmallStyle => const TextStyle(
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: fontFamily,
  );

  static TextStyle get captionStyle => const TextStyle(
    fontSize: caption,
    fontWeight: regular,
    height: lineHeightTight,
    fontFamily: fontFamily,
  );

  static TextStyle get overlineStyle => const TextStyle(
    fontSize: overline,
    fontWeight: medium,
    height: lineHeightTight,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  static TextTheme textTheme({String? fontFamily}) {
    final family = fontFamily ?? UiTypography.fontFamily;
    return TextTheme(
      displayLarge: h1Style.copyWith(fontFamily: family),
      displayMedium: h2Style.copyWith(fontFamily: family),
      displaySmall: h3Style.copyWith(fontFamily: family),
      headlineMedium: h4Style.copyWith(fontFamily: family),
      titleMedium: h4Style.copyWith(fontFamily: family),
      bodyLarge: bodyStyle.copyWith(fontFamily: family),
      bodyMedium: bodySmallStyle.copyWith(fontFamily: family),
      bodySmall: captionStyle.copyWith(fontFamily: family),
      labelSmall: overlineStyle.copyWith(fontFamily: family),
    );
  }
}
