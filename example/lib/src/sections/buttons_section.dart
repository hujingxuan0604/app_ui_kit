part of '../../main.dart';

Widget _buildButtonsSection(BuildContext context, _ExampleStrings strings) {
  final theme = context.uiTheme;
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiButton',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                UiButton(
                  label: strings.primary,
                  icon: const Icon(Icons.check_rounded),
                  onPressed: () =>
                      UiToast.success(strings.toast(strings.primary)),
                ),
                UiButton(
                  label: strings.secondary,
                  variant: UiButtonVariant.secondary,
                  onPressed: () =>
                      UiToast.info(strings.toast(strings.secondary)),
                ),
                UiButton(
                  label: strings.ghost,
                  variant: UiButtonVariant.ghost,
                  onPressed: () => UiToast.info(strings.toast(strings.ghost)),
                ),
                UiButton(
                  label: strings.danger,
                  variant: UiButtonVariant.danger,
                  onPressed: () => UiToast.error(strings.toast(strings.danger)),
                ),
                UiButton(
                  label: strings.loading,
                  loading: true,
                  size: UiButtonSize.small,
                ),
                UiButton(label: strings.disabled, onPressed: null),
              ],
            ),
            const SizedBox(height: 18),
            UiButton(
              label: strings.fullWidth,
              fullWidth: true,
              size: UiButtonSize.large,
              onPressed: () =>
                  UiToast.success(strings.toast(strings.fullWidth)),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiIconActionButton / UiPreviewActionButton',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            UiIconActionButton(
              icon: Icons.search_rounded,
              tooltip: strings.search,
              onTap: () => UiToast.info(strings.search),
            ),
            UiIconActionButton(
              icon: const Icon(Icons.favorite_rounded),
              tooltip: strings.selected,
              selected: true,
              onPressed: () => UiToast.success(strings.selected),
            ),
            UiIconActionButton.search(
              onTap: () => UiToast.info('UiIconActionButton.search'),
            ),
            UiPreviewActionButton(
              icon: Icons.zoom_in_rounded,
              tooltip: strings.zoomIn,
              onTap: () => UiToast.info(strings.zoomIn),
            ),
            UiIconActionButton(
              icon: Icons.delete_outline_rounded,
              tooltip: strings.delete,
              color: theme.error,
              onTap: () => UiToast.error(strings.delete),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiMenuButton',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            UiMenuButton.filter(
              items: [
                UiMenuItem(
                  label: '全部笔记',
                  icon: const Icon(Icons.menu_book_rounded),
                  selected: true,
                  onSelected: () => UiToast.info('全部笔记'),
                ),
                UiMenuItem(
                  label: '收藏笔记',
                  icon: const Icon(Icons.bookmark_border_rounded),
                  onSelected: () => UiToast.info('收藏笔记'),
                ),
                UiMenuItem(
                  label: '置顶笔记',
                  icon: const Icon(Icons.push_pin_outlined),
                  onSelected: () => UiToast.info('置顶笔记'),
                ),
              ],
            ),
            UiMenuButton(
              tooltip: strings.action,
              icon: Icons.more_horiz_rounded,
              items: [
                UiMenuItem(
                  label: '复制',
                  icon: const Icon(Icons.content_copy_rounded),
                  onSelected: () => UiToast.info('复制'),
                ),
                UiMenuItem(
                  label: strings.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onSelected: () => UiToast.error(strings.delete),
                ),
              ],
            ),
            UiMenuButton.filter(
              selected: true,
              items: [
                UiMenuItem(
                  label: strings.selected,
                  selected: true,
                  onSelected: () => UiToast.success(strings.selected),
                ),
              ],
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.actionFooter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.copyPatternHint,
              style: TextStyle(color: theme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 14),
            UiSurfacePanel(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  UiIconActionButton(
                    icon: Icons.more_horiz_rounded,
                    tooltip: strings.action,
                    onTap: () => UiToast.info(strings.action),
                  ),
                  const Spacer(),
                  UiButton(
                    label: strings.draft,
                    variant: UiButtonVariant.secondary,
                    size: UiButtonSize.small,
                    onPressed: () => UiToast.info(strings.draft),
                  ),
                  const SizedBox(width: 8),
                  UiButton(
                    label: strings.publish,
                    icon: const Icon(Icons.rocket_launch_outlined),
                    size: UiButtonSize.small,
                    onPressed: () => UiToast.success(strings.publish),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _UsageSnippet(
              title: strings.codeExample,
              code: '''
UiButton(
  label: 'Publish',
  icon: const Icon(Icons.rocket_launch_outlined),
  onPressed: submit,
)
''',
            ),
          ],
        ),
      ),
    ],
  );
}
