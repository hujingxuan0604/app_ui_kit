part of '../../main.dart';

Widget _buildSurfacesSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  final theme = context.uiTheme;
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiCard / UiListItem',
        child: Column(
          children: [
            UiCard(
              selected: true,
              onTap: () => UiToast.info(strings.cardTapped),
              child: Text(strings.selectedCard),
            ),
            const SizedBox(height: 12),
            UiListItem(
              title: strings.listItem,
              subtitle: strings.listItemSubtitle,
              selected: false,
              leading: const Icon(Icons.folder_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => UiToast.info(strings.listItem),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSurfacePanel',
        child: UiSurfacePanel(
          boxShadow: theme.shadowSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.surfacePanel,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.surfaceDescription,
                style: TextStyle(color: theme.textSecondary),
              ),
            ],
          ),
        ),
      ),
      _ExampleCard(
        title: 'UiSelectableCard',
        child: UiSelectableCard(
          selected: state._contentSelected,
          onTap: () => state._toggleContentSelected(),
          onDoubleTap: () => UiToast.success(strings.doubleTapped),
          child: Row(
            children: [
              Icon(Icons.image_outlined, color: theme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state._contentSelected
                      ? strings.selectedAsset
                      : strings.unselectedAsset,
                  style: TextStyle(color: theme.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
      _ExampleCard(
        title: strings.cardVariants,
        child: Column(
          children: [
            UiCard(
              variant: UiCardVariant.elevated,
              child: _CardVariantRow(
                icon: Icons.layers_outlined,
                title: 'Elevated',
                value: strings.ready,
              ),
            ),
            const SizedBox(height: 10),
            UiCard(
              variant: UiCardVariant.outlined,
              child: _CardVariantRow(
                icon: Icons.border_outer_outlined,
                title: 'Outlined',
                value: strings.reviewNeeded,
              ),
            ),
            const SizedBox(height: 10),
            UiCard(
              variant: UiCardVariant.filled,
              selected: true,
              child: _CardVariantRow(
                icon: Icons.check_circle_outline,
                title: 'Selected',
                value: strings.generating,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _CardVariantRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _CardVariantRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        UiBadge(label: value),
      ],
    );
  }
}
