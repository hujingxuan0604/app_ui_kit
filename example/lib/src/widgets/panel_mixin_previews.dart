part of '../../main.dart';

class _PanelMixinPreview extends StatefulWidget {
  final _ExampleStrings strings;

  const _PanelMixinPreview({required this.strings});

  @override
  State<_PanelMixinPreview> createState() => _PanelMixinPreviewState();
}

class _PanelMixinPreviewState extends State<_PanelMixinPreview>
    with UiPanelSingleEditMixin<_PanelMixinPreview> {
  @override
  Widget build(BuildContext context) {
    final demoState = const _DemoEditState('draft');
    final originalState = const _DemoEditState('original');
    return Row(
      children: [
        Expanded(
          child: Text(
            'UiPanelSingleEditMixin / UiPanelEditableState: '
            '${demoState.hasChangesFrom(originalState) ? widget.strings.changed : widget.strings.same}',
          ),
        ),
        UiButton(
          label: isExpanded ? widget.strings.collapse : widget.strings.expand,
          size: UiButtonSize.small,
          variant: UiButtonVariant.secondary,
          onPressed: toggleExpanded,
        ),
      ],
    );
  }

  @override
  void saveChanges() {
    setState(() {
      hasChanges = false;
    });
    UiToast.success(widget.strings.mixinSave);
  }
}

class _PanelListMixinPreview extends StatefulWidget {
  final _ExampleStrings strings;

  const _PanelListMixinPreview({required this.strings});

  @override
  State<_PanelListMixinPreview> createState() => _PanelListMixinPreviewState();
}

class _PanelListMixinPreviewState extends State<_PanelListMixinPreview>
    with UiPanelEditMixin<_PanelListMixinPreview> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'UiPanelEditMixin: selected=${selectedIndex ?? '-'}, '
            'expanded=${expandedIndex ?? '-'}',
          ),
        ),
        UiButton(
          label: widget.strings.toggleOne,
          size: UiButtonSize.small,
          variant: UiButtonVariant.secondary,
          onPressed: () {
            selectItem(1);
            toggleExpanded(1);
          },
        ),
      ],
    );
  }

  @override
  void saveChanges(int index) {
    setState(() {
      hasChanges[index] = false;
    });
    UiToast.success(widget.strings.savedItem(index));
  }
}

class _DemoEditState implements UiPanelEditableState<_DemoEditState> {
  final String value;

  const _DemoEditState(this.value);

  @override
  bool hasChangesFrom(_DemoEditState original) => value != original.value;
}
