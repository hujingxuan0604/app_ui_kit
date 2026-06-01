part of '../../main.dart';

Widget _buildDialogsSection(BuildContext context, _ExampleStrings strings) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiFormDialog',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                UiButton(
                  label: strings.formDialog,
                  variant: UiButtonVariant.secondary,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => UiFormDialog(
                        title: strings.createItem,
                        description: strings.formDialogDescription,
                        child: UiTextField(
                          label: strings.title,
                          hintText: strings.enterTitle,
                        ),
                        onConfirm: () => Navigator.of(context).pop(),
                      ),
                    );
                  },
                ),
                UiButton(
                  label: strings.dialogRecipe,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => UiFormDialog(
                        title: strings.dialogRecipe,
                        description: strings.formDialogDescription,
                        confirmLabel: strings.save,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UiTextField(
                              label: strings.formName,
                              hintText: strings.enterTitle,
                              prefix: const Icon(Icons.title_outlined),
                            ),
                            const SizedBox(height: 12),
                            UiTextField(
                              label: strings.formPrompt,
                              hintText: strings.multilineInput,
                              minLines: 2,
                              maxLines: 3,
                            ),
                          ],
                        ),
                        onConfirm: () => Navigator.of(context).pop(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiBottomSheet',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiButton(
              label: strings.bottomSheet,
              icon: const Icon(Icons.vertical_align_bottom_rounded),
              variant: UiButtonVariant.secondary,
              onPressed: () {
                UiBottomSheet.show<void>(
                  context: context,
                  builder: (sheetContext) => UiBottomSheet(
                    title: strings.quickSettings,
                    description: strings.bottomSheetDescription,
                    actions: [
                      UiButton(
                        label: strings.close,
                        variant: UiButtonVariant.secondary,
                        size: UiButtonSize.small,
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                      UiButton(
                        label: strings.save,
                        size: UiButtonSize.small,
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiInfoRow(
                          label: strings.sheetOptionOne,
                          value: strings.activeProject,
                          icon: const Icon(Icons.folder_outlined),
                        ),
                        const SizedBox(height: 12),
                        UiInfoRow(
                          label: strings.sheetOptionTwo,
                          value: '16:9',
                          icon: const Icon(Icons.aspect_ratio_outlined),
                        ),
                        const SizedBox(height: 12),
                        UiDropdown<String>(
                          label: strings.status,
                          value: 'draft',
                          options: [
                            UiDropdownOption(
                              value: 'draft',
                              label: strings.draft,
                            ),
                            UiDropdownOption(
                              value: 'published',
                              label: strings.publishedStatus,
                            ),
                          ],
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}
