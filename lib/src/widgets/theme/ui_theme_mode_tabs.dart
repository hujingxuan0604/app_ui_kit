import 'package:flutter/material.dart';

import '../navigation/ui_tabs.dart';

class UiThemeModeTabs extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;
  final List<String> labels;

  const UiThemeModeTabs({
    super.key,
    required this.value,
    required this.onChanged,
    this.labels = const ['Light', 'Dark', 'System'],
  }) : assert(labels.length == 3, 'UiThemeModeTabs needs exactly 3 labels.');

  @override
  Widget build(BuildContext context) {
    return UiTabs(
      selectedIndex: _selectedIndex,
      items: labels,
      size: UiTabsSize.small,
      style: UiTabsStyle.segmented,
      fullWidth: false,
      semanticsLabel: 'Theme mode',
      onChanged: (index) {
        switch (index) {
          case 0:
            onChanged(ThemeMode.light);
            break;
          case 1:
            onChanged(ThemeMode.dark);
            break;
          case 2:
            onChanged(ThemeMode.system);
            break;
        }
      },
    );
  }

  int get _selectedIndex {
    return switch (value) {
      ThemeMode.light => 0,
      ThemeMode.dark => 1,
      ThemeMode.system => 2,
    };
  }
}
