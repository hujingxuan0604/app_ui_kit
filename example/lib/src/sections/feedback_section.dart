part of '../../main.dart';

Widget _buildFeedbackSection(BuildContext context, _ExampleStrings strings) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiToast',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            UiButton(
              label: strings.success,
              onPressed: () => UiToast.success(strings.operationCompleted),
            ),
            UiButton(
              label: strings.info,
              variant: UiButtonVariant.secondary,
              onPressed: () => UiToast.info(strings.helpfulInformation),
            ),
            UiButton(
              label: strings.warning,
              variant: UiButtonVariant.secondary,
              onPressed: () => UiToast.warning(strings.checkInput),
            ),
            UiButton(
              label: strings.error,
              variant: UiButtonVariant.danger,
              onPressed: () => UiToast.error(strings.somethingWentWrong),
            ),
          ],
        ),
      ),
    ],
  );
}
