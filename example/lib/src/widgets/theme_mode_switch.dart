part of '../../main.dart';

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
