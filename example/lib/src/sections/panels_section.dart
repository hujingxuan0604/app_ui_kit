part of '../../main.dart';

Widget _buildPanelsSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiPanelScaffold / Header / Body',
        height: 420,
        child: UiPanelScaffold(
          title: strings.shotList,
          borderSide: UiPanelBorderSide.none,
          actions: [
            UiPanelIconButton(
              icon: Icons.add,
              tooltip: strings.add,
              onTap: () => UiToast.success(strings.add),
            ),
          ],
          onClose: () => UiToast.info(strings.close),
          body: UiPanelBody(
            children: [
              UiPanelSectionHeader(
                title: strings.currentProject,
                actions: [
                  UiPanelIconButton(
                    icon: Icons.filter_list,
                    onTap: () => UiToast.info(strings.filter),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UiPanelCard(
                selected: state._panelCardSelected,
                expanded: state._panelCardExpanded,
                onTap: () => state._togglePanelCardSelected(),
                header: UiPanelCardHeader(
                  indexLabel: '01',
                  title: strings.shotCard,
                  subtitle: 'UiPanelCardHeader',
                  expanded: state._panelCardExpanded,
                  editLabel: strings.edit,
                  collapseLabel: strings.collapse,
                  onEditToggle: () => state._togglePanelCardExpanded(),
                ),
                collapsedContent: Text(strings.collapsedContent),
                expandedContent: UiPanelEditArea(
                  children: [
                    UiPanelFormRow(
                      children: [
                        UiPanelInput(
                          label: strings.title,
                          initialValue: state._panelNameController.text,
                          onChanged: (value) =>
                              state._panelNameController.text = value,
                        ),
                        UiPanelDropdown(
                          label: strings.ratio,
                          value: state._panelDropdownValue,
                          items: const ['16:9', '9:16', '1:1'],
                          onChanged: (value) {
                            if (value != null) {
                              state._selectPanelDropdownValue(value);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    UiPanelTagRow(
                      tags: [
                        UiPanelTag(
                          icon: Icons.palette_outlined,
                          label: strings.cinematic,
                          style: UiPanelTagStyle.primary,
                        ),
                        UiPanelTag(
                          icon: Icons.mood_outlined,
                          label: strings.calm,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        UiStatTag(
                          icon: Icons.movie_outlined,
                          label: strings.shot,
                          value: '8',
                        ),
                        const UiUnsavedIndicator(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    UiPanelSaveRow(
                      hasChanges: true,
                      onSave: () => UiToast.success(strings.saved),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      _ExampleCard(
        title: 'UiPanelEmptyState / Edit helpers',
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: UiPanelEmptyState(
                icon: Icons.inbox_outlined,
                title: strings.noContent,
                description: strings.emptyDescription,
                action: UiButton(
                  label: strings.create,
                  size: UiButtonSize.small,
                  onPressed: () => UiToast.success(strings.created),
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _PanelMixinPreview(strings: strings),
            const SizedBox(height: 10),
            _PanelListMixinPreview(strings: strings),
          ],
        ),
      ),
    ],
  );
}
