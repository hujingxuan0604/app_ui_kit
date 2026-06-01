part of '../../main.dart';

Widget _buildInputsSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiTextField',
        child: Column(
          children: [
            UiTextField(
              label: strings.name,
              hintText: strings.enterName,
              controller: state._nameController,
              prefix: const Icon(Icons.person_outline),
              suffix: const Icon(Icons.check_circle_outline),
              onSubmitted: (value) => UiToast.success(strings.submitted(value)),
            ),
            const SizedBox(height: 14),
            UiTextField(
              label: strings.password,
              hintText: strings.toggleVisibility,
              obscureText: true,
              prefix: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 14),
            UiTextField(
              label: strings.description,
              hintText: strings.multilineInput,
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            UiTextField(
              label: strings.error,
              initialValue: strings.invalidValue,
              errorText: strings.validValueHint,
            ),
            const SizedBox(height: 14),
            UiTextField(
              label: strings.compact,
              initialValue: strings.defaultShotName,
              size: UiTextFieldSize.compact,
            ),
            const SizedBox(height: 14),
            UiTextField(
              label: strings.floatingLabel,
              labelPosition: UiTextFieldLabelPosition.floating,
              initialValue: strings.activeProject,
              prefix: const Icon(Icons.badge_outlined),
              suffix: const Icon(Icons.check_circle_outline),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 84,
              child: UiTextField(
                label: strings.fillParent,
                labelPosition: UiTextFieldLabelPosition.floating,
                layout: UiTextFieldLayout.fill,
                hintText: strings.multilineInput,
                prefix: const Icon(Icons.open_in_full_rounded),
              ),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiDropdown',
        child: Column(
          children: [
            UiDropdown<String>(
              label: strings.status,
              hintText: strings.chooseStatus,
              value: state._inputDropdownValue,
              clearable: true,
              prefix: const Icon(Icons.flag_outlined),
              options: [
                UiDropdownOption(
                  value: 'draft',
                  label: strings.draftStatus,
                  icon: const Icon(Icons.edit_note_outlined),
                ),
                UiDropdownOption(
                  value: 'published',
                  label: strings.publishedStatus,
                  icon: const Icon(Icons.public_outlined),
                ),
                UiDropdownOption(
                  value: 'archived',
                  label: strings.archivedStatus,
                  icon: const Icon(Icons.inventory_2_outlined),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  state._selectDropdownValue(value);
                  UiToast.info(strings.changed);
                }
              },
            ),
            const SizedBox(height: 14),
            UiDropdown<String>(
              label: strings.assetType,
              hintText: strings.chooseAssetType,
              value: state._inputAssetDropdownValue,
              searchable: true,
              clearable: true,
              searchHintText: strings.searchAssetType,
              emptyText: strings.noAssetTypes,
              prefix: const Icon(Icons.perm_media_outlined),
              options: [
                UiDropdownOption(
                  value: 'voiceover',
                  label: strings.voiceover,
                  description: strings.voiceoverDescription,
                  icon: const Icon(Icons.mic_none_outlined),
                  trailing: const Text('VO'),
                ),
                UiDropdownOption(
                  value: 'soundtrack',
                  label: strings.soundtrack,
                  description: strings.soundtrackDescription,
                  icon: const Icon(Icons.music_note_outlined),
                  trailing: const Text('BPM'),
                ),
                UiDropdownOption(
                  value: 'broll',
                  label: strings.broll,
                  description: strings.brollDescription,
                  icon: const Icon(Icons.video_library_outlined),
                  trailing: const Icon(Icons.star_border_rounded),
                ),
              ],
              onChanged: (value) {
                state._selectAssetDropdownValue(value);
                UiToast.info(strings.changed);
              },
            ),
            const SizedBox(height: 14),
            UiDropdown<String>(
              label: strings.error,
              hintText: strings.chooseStatus,
              value: state._inputRequiredDropdownValue,
              errorText: state._inputRequiredDropdownValue == null
                  ? strings.selectRequired
                  : null,
              options: [
                UiDropdownOption(value: 'draft', label: strings.draftStatus),
                UiDropdownOption(
                  value: 'published',
                  label: strings.publishedStatus,
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  state._selectRequiredDropdownValue(value);
                }
              },
            ),
            const SizedBox(height: 14),
            UiDropdown<String>(
              label: strings.compact,
              value: state._inputDropdownValue,
              size: UiDropdownSize.compact,
              options: [
                UiDropdownOption(value: 'draft', label: strings.draftStatus),
                UiDropdownOption(
                  value: 'published',
                  label: strings.publishedStatus,
                ),
                UiDropdownOption(
                  value: 'archived',
                  label: strings.archivedStatus,
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  state._selectDropdownValue(value);
                }
              },
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSearchField',
        child: Column(
          children: [
            UiSearchField(
              hintText: strings.searchAssetType,
              controller: state._searchController,
              onSubmitted: (value) => UiToast.info(strings.submitted(value)),
            ),
            const SizedBox(height: 14),
            UiSearchField(
              hintText: strings.searchFolders,
              size: UiTextFieldSize.compact,
              initialValue: strings.reference,
              onClear: () => UiToast.info(strings.clear),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 42,
              child: UiSearchField(
                hintText: strings.search,
                layout: UiTextFieldLayout.fill,
              ),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.formExample,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiTextField(
              label: strings.formName,
              initialValue: strings.activeProject,
              prefix: const Icon(Icons.movie_creation_outlined),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: UiTextField(
                    label: strings.formStyle,
                    initialValue: strings.cinematic,
                    prefix: const Icon(Icons.palette_outlined),
                  ),
                ),
                const SizedBox(width: 12),
                UiColorPickerButton(
                  colorValue: state._colorValue,
                  showColorIndicator: true,
                  onSelected: (value) => state._selectColor(value),
                ),
              ],
            ),
            const SizedBox(height: 12),
            UiTextField(
              label: strings.formPrompt,
              hintText: strings.multilineInput,
              minLines: 2,
              maxLines: 3,
              suffix: const Icon(Icons.auto_awesome_outlined),
            ),
          ],
        ),
      ),
    ],
  );
}
