part of '../../main.dart';

class _ThemeModeSwitch extends StatelessWidget {
  final ThemeMode value;
  final _ExampleStrings strings;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeSwitch({
    required this.value,
    required this.strings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
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
          _ThemeModeButton(
            icon: Icons.light_mode_rounded,
            tooltip: strings.lightMode,
            isSelected: value == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
          ),
          _ThemeModeButton(
            icon: Icons.dark_mode_rounded,
            tooltip: strings.darkMode,
            isSelected: value == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
          ),
          _ThemeModeButton(
            icon: Icons.settings_suggest_rounded,
            tooltip: strings.systemMode,
            isSelected: value == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  final _ExampleLanguage value;
  final _ExampleStrings strings;
  final ValueChanged<_ExampleLanguage> onChanged;

  const _LanguageSwitch({
    required this.value,
    required this.strings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageSegment(
            label: strings.languageZh,
            selected: value == _ExampleLanguage.zh,
            onTap: () => onChanged(_ExampleLanguage.zh),
          ),
          _LanguageSegment(
            label: strings.languageEn,
            selected: value == _ExampleLanguage.en,
            onTap: () => onChanged(_ExampleLanguage.en),
          ),
        ],
      ),
    );
  }
}

class _LanguageSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          width: 42,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? theme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : theme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
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
            width: 42,
            height: 30,
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
