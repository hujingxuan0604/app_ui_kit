part of '../../main.dart';

Widget _buildAvatarSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiAvatar / UiClickableAvatar / UiAvatarPickerDialog',
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const UiAvatar(label: 'StoryFlow', size: 48),
            const UiAvatar(placeholder: Icon(Icons.person_outline), size: 48),
            UiAvatar(
              label: strings.squareAvatar,
              size: 48,
              shape: UiAvatarShape.square,
            ),
            UiClickableAvatar(
              label: strings.edit,
              size: 56,
              onTap: () => UiToast.info(strings.clickableAvatar),
            ),
            UiClickableAvatar(
              label: strings.edit,
              size: 56,
              shape: UiAvatarShape.square,
              onTap: () => UiToast.info(strings.clickableAvatar),
            ),
            UiButton(
              label: strings.avatarPicker,
              variant: UiButtonVariant.secondary,
              onPressed: () async {
                final selected = await showDialog<UiAvatarOption>(
                  context: context,
                  builder: (_) => UiAvatarPickerDialog(
                    options: [
                      UiAvatarOption(
                        id: 'a',
                        image: state._demoAvatarImage,
                        label: 'A',
                      ),
                      UiAvatarOption(
                        id: 'b',
                        image: state._demoAvatarImage,
                        label: 'B',
                      ),
                      UiAvatarOption(
                        id: 'c',
                        image: state._demoAvatarImage,
                        label: 'C',
                      ),
                    ],
                    selectedId: state._selectedAvatarId,
                  ),
                );
                if (selected != null) {
                  state._selectAvatar(selected.id);
                  UiToast.success(strings.selectedAvatar(selected.id));
                }
              },
            ),
          ],
        ),
      ),
    ],
  );
}
