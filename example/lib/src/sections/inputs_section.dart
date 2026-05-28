part of '../../main.dart';

Widget _buildInputsSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiInput',
        child: Column(
          children: [
            UiInput(
              label: strings.name,
              hintText: strings.enterName,
              controller: state._nameController,
              prefix: const Icon(Icons.person_outline),
              suffix: const Icon(Icons.check_circle_outline),
              onSubmitted: (value) => UiToast.success(strings.submitted(value)),
            ),
            const SizedBox(height: 14),
            UiInput(
              label: strings.password,
              hintText: strings.toggleVisibility,
              obscureText: true,
              prefix: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 14),
            UiInput(
              label: strings.description,
              hintText: strings.multilineInput,
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            UiInput(
              label: strings.error,
              initialValue: strings.invalidValue,
              errorText: strings.validValueHint,
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiColorPickerButton / UiColorPalette',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UiColorPickerButton(
                  colorValue: state._colorValue,
                  showColorIndicator: true,
                  onSelected: (value) => state._selectColor(value),
                ),
                const SizedBox(width: 12),
                UiColorBadge(
                  label: strings.selectedColor,
                  color: UiColorPalette.fromRgb(state._colorValue),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: UiColorPalette.standardRgbColors.take(12).map((value) {
                return Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: UiColorPalette.fromRgb(value),
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSelect',
        child: Column(
          children: [
            UiSelect<String>(
              label: strings.status,
              hintText: strings.chooseStatus,
              value: state._inputSelectValue,
              prefix: const Icon(Icons.flag_outlined),
              options: [
                UiSelectOption(
                  value: 'draft',
                  label: strings.draftStatus,
                  icon: const Icon(Icons.edit_note_outlined),
                ),
                UiSelectOption(
                  value: 'published',
                  label: strings.publishedStatus,
                  icon: const Icon(Icons.public_outlined),
                ),
                UiSelectOption(
                  value: 'archived',
                  label: strings.archivedStatus,
                  icon: const Icon(Icons.inventory_2_outlined),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  state._selectInputValue(value);
                  UiToast.info(strings.changed);
                }
              },
            ),
            const SizedBox(height: 14),
            UiSelect<String>(
              label: strings.error,
              hintText: strings.chooseStatus,
              value: state._inputRequiredSelectValue,
              errorText: state._inputRequiredSelectValue == null
                  ? strings.selectRequired
                  : null,
              options: [
                UiSelectOption(value: 'draft', label: strings.draftStatus),
                UiSelectOption(
                  value: 'published',
                  label: strings.publishedStatus,
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  state._selectRequiredInputValue(value);
                }
              },
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.formExample,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiInput(
              label: strings.formName,
              initialValue: strings.activeProject,
              prefix: const Icon(Icons.movie_creation_outlined),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: UiInput(
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
            UiInput(
              label: strings.formPrompt,
              hintText: strings.multilineInput,
              minLines: 2,
              maxLines: 3,
              suffix: const Icon(Icons.auto_awesome_outlined),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.basicUsage,
        child: _UsageSnippet(
          title: strings.codeExample,
          code: '''
UiInput(
  label: 'Password',
  hintText: 'Toggle visibility',
  obscureText: true,
  prefix: const Icon(Icons.lock_outline),
)

UiSelect<String>(
  label: 'Status',
  value: 'draft',
  options: const [
    UiSelectOption(value: 'draft', label: 'Draft'),
    UiSelectOption(value: 'published', label: 'Published'),
  ],
  onChanged: (value) {},
)
''',
        ),
      ),
    ],
  );
}
