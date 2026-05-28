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
                        child: UiInput(
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
                            UiInput(
                              label: strings.formName,
                              hintText: strings.enterTitle,
                              prefix: const Icon(Icons.title_outlined),
                            ),
                            const SizedBox(height: 12),
                            UiInput(
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
            const SizedBox(height: 14),
            _UsageSnippet(
              title: strings.codeExample,
              code: '''
showDialog(
  context: context,
  builder: (_) => UiFormDialog(
    title: 'Create item',
    child: UiInput(label: 'Title'),
    onConfirm: submit,
  ),
)
''',
            ),
          ],
        ),
      ),
    ],
  );
}
