part of '../../main.dart';

Widget _buildRecipesSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  final theme = context.uiTheme;
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: strings.dashboardRecipe,
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiSectionHeader(
              title: strings.activeProject,
              subtitle: strings.recommendedPattern,
              trailing: UiBadge(
                label: strings.generating,
                icon: Icons.autorenew_rounded,
                color: theme.info,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: UiSurfacePanel(
                    child: _RecipeMetric(
                      label: strings.shot,
                      value: '24',
                      icon: Icons.movie_creation_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: UiSurfacePanel(
                    child: _RecipeMetric(
                      label: strings.renderQueue,
                      value: '6',
                      icon: Icons.queue_play_next_outlined,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            UiPanelCard(
              selected: true,
              header: UiPanelCardHeader(
                indexLabel: '01',
                title: strings.shotCard,
                subtitle: strings.cinematic,
                showEditButton: false,
              ),
              collapsedContent: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  UiPanelTag(
                    icon: Icons.palette_outlined,
                    label: strings.cinematic,
                    style: UiPanelTagStyle.primary,
                  ),
                  UiPanelTag(icon: Icons.mood_outlined, label: strings.calm),
                  UiPanelStatBadge(
                    icon: Icons.aspect_ratio_outlined,
                    label: strings.ratio,
                    value: '16:9',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: UiButton(
                    label: strings.draft,
                    variant: UiButtonVariant.secondary,
                    fullWidth: true,
                    onPressed: () => UiToast.info(strings.draft),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: UiButton(
                    label: strings.publish,
                    icon: const Icon(Icons.rocket_launch_outlined),
                    fullWidth: true,
                    onPressed: () => UiToast.success(strings.publish),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.assetRecipe,
        height: 420,
        child: Row(
          children: [
            SizedBox(
              width: 210,
              child: UiSidebar<int>(
                title: strings.folders,
                selectedValue: state._selectedFolderIndex,
                onItemSelected: (value) => state._selectFolder(value),
                items: [
                  UiSidebarItemData(
                    value: 0,
                    label: strings.allAssets,
                    icon: Icons.all_inbox_outlined,
                    countLabel: '36',
                  ),
                  UiSidebarItemData(
                    value: 1,
                    label: strings.storyboard,
                    leading: _SidebarColorSwatch(0x3D38F5),
                    countLabel: '12',
                  ),
                  UiSidebarItemData(
                    value: 2,
                    label: strings.reference,
                    leading: _SidebarColorSwatch(0x14AE5C),
                    countLabel: '7',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiSectionHeader(
                    title: strings.allAssets,
                    subtitle: strings.uploadAssets,
                    trailing: UiIconActionButton(
                      icon: Icons.upload_file_outlined,
                      tooltip: strings.uploadAssets,
                      onTap: () => UiToast.info(strings.uploadAssets),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(4, (index) {
                        final selected = index == state._selectedFolderIndex;
                        return UiSelectableCard(
                          selected: selected,
                          padding: const EdgeInsets.all(10),
                          onTap: () => state._selectFolder(index % 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                color: selected
                                    ? theme.primary
                                    : theme.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${strings.selectedAsset} ${index + 1}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: theme.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _RecipeMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _RecipeMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      children: [
        Icon(icon, color: theme.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
