import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';

class UiColorPalette {
  const UiColorPalette._();

  static const int defaultRgb = 0x3D38F5;

  static const List<int> standardRgbColors = [
    0xC23A3A,
    0xB6631B,
    0xBC8B13,
    0x7B8D09,
    0x2C7E2D,
    0x258277,
    0x1D7EA5,
    0x2A66C9,
    0xB04386,
    0x7545C9,
    0x777777,
    0x812222,
    0x67360E,
    0x704C05,
    0x5B6805,
    0x175513,
    0x14534D,
    0x0E4D66,
    0x1C407C,
    0x70204D,
    0x442079,
    0x333333,
    0x9B2D2D,
    0x8E4F18,
    0x8F6513,
    0x687405,
    0x276B1D,
    0x1F6861,
    0x195C79,
    0x2254A7,
    0x883168,
    0x5D2DB2,
    0x4A4A4A,
    0xEF4444,
    0xD97706,
    0xEAB308,
    0x84A500,
    0x3A9A31,
    0x1F9B91,
    0x1C91BE,
    0x3678EB,
    0xCC4D97,
    0x8B5CF6,
    0xA3A3A3,
    0xF87171,
    0xF97316,
    0xFACC15,
    0xA3C900,
    0x65B741,
    0x2CC4B3,
    0x2FB6DE,
    0x70A0F6,
    0xE56BAB,
    0xB082F5,
    0xE5E5E5,
  ];

  static const List<int> values = standardRgbColors;

  static Color fromRgb(int value) => Color(0xFF000000 | value);
}

class UiColorPickerButton extends StatelessWidget {
  final int colorValue;
  final List<int> colors;
  final bool showColorIndicator;
  final bool showDropdownIcon;
  final ValueChanged<int> onSelected;

  const UiColorPickerButton({
    super.key,
    required this.colorValue,
    required this.onSelected,
    this.colors = UiColorPalette.standardRgbColors,
    this.showColorIndicator = false,
    this.showDropdownIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return PopupMenuButton<int>(
      tooltip: '选择颜色',
      color: theme.surface,
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            enabled: false,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((value) {
                final selected = value == colorValue;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(value),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: UiColorPalette.fromRgb(value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? theme.textPrimary : theme.border,
                        width: selected ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ];
      },
      child: SizedBox.square(
        dimension: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showColorIndicator)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: UiColorPalette.fromRgb(colorValue),
                  shape: BoxShape.circle,
                ),
              ),
            if (showDropdownIcon)
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 26,
                color: UiColorPalette.fromRgb(colorValue),
              ),
            if (!showColorIndicator && !showDropdownIcon)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: UiColorPalette.fromRgb(colorValue),
                  borderRadius: BorderRadius.circular(UiRadii.sm),
                  border: Border.all(color: theme.border),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
