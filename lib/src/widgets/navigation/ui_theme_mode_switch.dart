import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../theme/ui_theme_scope.dart';

class UiThemeModeSwitch extends StatelessWidget {
  final bool showSystemMode;
  final double itemWidth;
  final double itemHeight;
  final String lightTooltip;
  final String darkTooltip;
  final String systemTooltip;

  const UiThemeModeSwitch({
    super.key,
    this.showSystemMode = true,
    this.itemWidth = 42,
    this.itemHeight = 30,
    this.lightTooltip = 'Light mode',
    this.darkTooltip = 'Dark mode',
    this.systemTooltip = 'Follow system',
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final controller = context.uiThemeController;
    final currentMode = controller.themeMode;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.border),
        boxShadow: theme.shadowXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UiThemeModeButton(
            icon: Icons.light_mode_rounded,
            tooltip: lightTooltip,
            isSelected: currentMode == ThemeMode.light,
            width: itemWidth,
            height: itemHeight,
            onTap: () {
              unawaited(controller.setLight());
            },
          ),
          _UiThemeModeButton(
            icon: Icons.dark_mode_rounded,
            tooltip: darkTooltip,
            isSelected: currentMode == ThemeMode.dark,
            width: itemWidth,
            height: itemHeight,
            onTap: () {
              unawaited(controller.setDark());
            },
          ),
          if (showSystemMode)
            _UiThemeModeButton(
              icon: Icons.settings_suggest_rounded,
              tooltip: systemTooltip,
              isSelected: currentMode == ThemeMode.system,
              width: itemWidth,
              height: itemHeight,
              onTap: () {
                unawaited(controller.setSystem());
              },
            ),
        ],
      ),
    );
  }
}

class _UiThemeModeButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _UiThemeModeButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primary.withValues(alpha: 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected
                    ? theme.primary.withValues(alpha: 0.34)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              size: 17,
              color: isSelected ? theme.primary : theme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
