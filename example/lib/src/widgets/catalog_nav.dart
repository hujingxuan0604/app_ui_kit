part of '../../main.dart';

class _CatalogNav extends StatelessWidget {
  final List<_CatalogSection> sections;
  final ValueListenable<String> activeSectionId;
  final ValueChanged<String> onSelected;
  final _ExampleStrings strings;

  const _CatalogNav({
    required this.sections,
    required this.activeSectionId,
    required this.onSelected,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      width: 248,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(right: BorderSide(color: theme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            child: _CatalogBrand(strings: strings),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _CatalogSummary(strings: strings),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: activeSectionId,
              builder: (context, activeId, _) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    return _CatalogNavItem(
                      section: section,
                      isSelected: section.id == activeId,
                      label: strings.sectionLabel(section.id),
                      onTap: () => onSelected(section.id),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
            child: _CatalogFooter(count: sections.length, strings: strings),
          ),
        ],
      ),
    );
  }
}

class _CatalogBrand extends StatelessWidget {
  final _ExampleStrings strings;

  const _CatalogBrand({required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: theme.primaryGradient,
            borderRadius: BorderRadius.circular(UiRadii.xl),
            boxShadow: theme.shadowSm,
          ),
          child: const Icon(
            Icons.auto_awesome_mosaic_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app_ui_kit',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                strings.navSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.textTertiary, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CatalogSummary extends StatelessWidget {
  final _ExampleStrings strings;

  const _CatalogSummary({required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surfaceLight,
        borderRadius: BorderRadius.circular(UiRadii.xl),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        children: [
          Icon(Icons.speed_outlined, color: theme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              strings.navSummary,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogNavItem extends StatefulWidget {
  final _CatalogSection section;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _CatalogNavItem({
    required this.section,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  State<_CatalogNavItem> createState() => _CatalogNavItemState();
}

class _CatalogNavItemState extends State<_CatalogNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final selected = widget.isSelected;
    final color = selected ? theme.primary : theme.textSecondary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(UiRadii.xl),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? theme.primary.withValues(alpha: 0.12)
                : _hovered
                ? theme.surfaceLight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(UiRadii.xl),
            border: Border.all(
              color: selected
                  ? theme.primary.withValues(alpha: 0.28)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 4,
                height: selected ? 20 : 0,
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              Icon(widget.section.icon, size: 18, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? theme.textPrimary : theme.textSecondary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogFooter extends StatelessWidget {
  final int count;
  final _ExampleStrings strings;

  const _CatalogFooter({required this.count, required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.surfaceLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(UiRadii.lg),
      ),
      child: Row(
        children: [
          Icon(Icons.widgets_outlined, size: 16, color: theme.textTertiary),
          const SizedBox(width: 8),
          Text(
            strings.categoryCount(count),
            style: TextStyle(color: theme.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
