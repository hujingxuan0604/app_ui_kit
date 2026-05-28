part of '../../main.dart';

Widget _buildDisplaySection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  final theme = context.uiTheme;
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiBadge variants',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            UiBadge(
              label: strings.defaultLabel,
              icon: Icons.local_offer_outlined,
            ),
            UiBadge(
              label: strings.customStyle,
              icon: Icons.auto_awesome,
              style: UiBadgeStyle(
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                foregroundColor: Colors.white,
                iconColor: Colors.white,
              ),
            ),
            UiColorBadge(
              label: 'UiColorBadge',
              color: theme.success,
              onTap: () => UiToast.success(strings.toast('UiColorBadge')),
            ),
            UiSelectionBadge(label: strings.inactive),
            UiSelectionBadge(label: strings.active, selected: true),
            UiSelectionToggleBadge(
              selected: state._selectionToggle,
              onTap: () => state._toggleSelectionToggle(),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSectionHeader / UiInfoRow',
        child: Column(
          children: [
            UiSectionHeader(
              title: strings.sectionTitle,
              subtitle: strings.sectionSubtitle,
              trailing: UiButton(
                label: strings.action,
                size: UiButtonSize.small,
                variant: UiButtonVariant.secondary,
                onPressed: () => UiToast.info(strings.action),
              ),
            ),
            const SizedBox(height: 16),
            UiInfoRow(label: strings.prompt, value: strings.infoRowValue),
            const SizedBox(height: 12),
            UiInfoRow(
              label: strings.model,
              value: 'storyflow-v1',
              icon: const Icon(Icons.memory_outlined),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSidebarItem',
        child: Column(
          children: [
            UiSidebarItem(
              label: strings.overview,
              leading: const Icon(Icons.dashboard_outlined),
              countLabel: '12',
              selected: true,
              onTap: () => UiToast.info(strings.overview),
            ),
            const SizedBox(height: 6),
            UiSidebarItem(
              label: strings.archive,
              icon: const Icon(Icons.inventory_2_outlined),
              countLabel: '3',
              trailingActions: const [Icon(Icons.more_horiz, size: 16)],
              onTap: () => UiToast.info(strings.archive),
            ),
          ],
        ),
      ),
    ],
  );
}
