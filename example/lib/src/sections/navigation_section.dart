part of '../../main.dart';

Widget _buildNavigationSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  final items = [
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
  ];
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiTabs / UiTabsController',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiTabs(
              controller: state._tabsController,
              items: [
                strings.freeCreation,
                strings.aiScript,
                strings.videoCopy,
              ],
              onChanged: (_) => UiToast.info(strings.changed),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: state._tabsController,
              builder: (context, index, _) {
                return UiInfoRow(
                  label: strings.currentMode,
                  value: _tabLabel(index, strings),
                );
              },
            ),
            const SizedBox(height: 16),
            UiTabs(
              selectedIndex: 1,
              size: UiTabsSize.small,
              fullWidth: false,
              items: [
                strings.freeCreation,
                strings.aiScript,
                strings.videoCopy,
              ],
              onChanged: (index) => UiToast.info(_tabLabel(index, strings)),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiTabs rich items / content',
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiTabs(
              controller: state._contentTabsController,
              style: UiTabsStyle.underline,
              tabItems: [
                UiTabItem(
                  label: '选项',
                  icon: Icons.dashboard_outlined,
                  badgeLabel: '',
                  content: _TabContentPanel(title: '内容区 1', value: '24'),
                ),
                UiTabItem(
                  label: '选项',
                  badgeLabel: '8',
                  content: _TabContentPanel(title: '内容区 2', value: '8'),
                ),
                UiTabItem(
                  label: '选项',
                  icon: Icons.grid_view_rounded,
                  content: _TabContentPanel(title: '内容区 3', value: '12'),
                ),
              ],
              onChanged: (index) => UiToast.info('Tab $index'),
            ),
            const SizedBox(height: 16),
            UiTabs(
              selectedIndex: 0,
              style: UiTabsStyle.segmented,
              fullWidth: false,
              tabItems: const [
                UiTabItem(label: '选项1'),
                UiTabItem(label: '选项2', badgeLabel: '2'),
                UiTabItem(label: '选项3', icon: Icons.auto_awesome_outlined),
              ],
              onChanged: (_) => UiToast.info(strings.changed),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiMenu / UiMenuItem',
        height: 360,
        child: const _MenuExample(),
      ),
      _ExampleCard(
        title: 'UiMenu context menu',
        height: 360,
        child: const _ContextMenuCardExample(),
      ),
      _ExampleCard(
        title: 'UiSidebar / UiSidebarItemData',
        height: 360,
        child: UiSidebar<int>(
          title: strings.folders,
          width: double.infinity,
          items: items,
          selectedValue: state._selectedFolderIndex,
          onItemSelected: (value) => state._selectFolder(value),
          searchQuery: state._searchController.text,
          searchHint: strings.searchFolders,
          onSearchChanged: (value) {
            state._searchController.text = value;
          },
          headerActions: [
            UiIconActionButton(
              icon: Icons.add_rounded,
              tooltip: strings.create,
              size: 28,
              onTap: () => UiToast.success(strings.createFolder),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: 'UiSideDrawer',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            UiButton(
              label: strings.leftSideDrawer,
              icon: const Icon(Icons.keyboard_tab_rounded),
              variant: UiButtonVariant.secondary,
              onPressed: () => _showSideDrawer(
                context,
                state,
                strings,
                UiSideDrawerSide.left,
                items,
              ),
            ),
            UiButton(
              label: strings.rightSideDrawer,
              icon: const Icon(Icons.keyboard_tab_rounded),
              variant: UiButtonVariant.secondary,
              onPressed: () => _showSideDrawer(
                context,
                state,
                strings,
                UiSideDrawerSide.right,
                items,
              ),
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.assetRecipe,
        height: 360,
        child: Row(
          children: [
            SizedBox(
              width: 220,
              child: UiSidebar<int>(
                title: strings.folders,
                items: items,
                selectedValue: state._selectedFolderIndex,
                onItemSelected: (value) => state._selectFolder(value),
                headerActions: [
                  UiIconActionButton(
                    icon: Icons.add_rounded,
                    tooltip: strings.create,
                    size: 26,
                    onTap: () => UiToast.success(strings.createFolder),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: _AssetPreviewArea(strings: strings)),
          ],
        ),
      ),
    ],
  );
}

void _showSideDrawer(
  BuildContext context,
  _ExampleHomeState state,
  _ExampleStrings strings,
  UiSideDrawerSide side,
  List<UiSidebarItemData<int>> items,
) {
  UiSideDrawer.show<void>(
    context: context,
    side: side,
    builder: (drawerContext) => UiSideDrawer(
      side: side,
      width: side == UiSideDrawerSide.left ? 320 : null,
      widthFactor: side == UiSideDrawerSide.right ? 0.42 : null,
      title: strings.sideDrawer,
      description: strings.sideDrawerDescription,
      leading: const Icon(Icons.view_sidebar_outlined),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UiButton(
            label: strings.close,
            variant: UiButtonVariant.secondary,
            size: UiButtonSize.small,
            onPressed: () => Navigator.of(drawerContext).pop(),
          ),
          const SizedBox(width: 8),
          UiButton(
            label: strings.save,
            size: UiButtonSize.small,
            onPressed: () => Navigator.of(drawerContext).pop(),
          ),
        ],
      ),
      child: Column(
        children: [
          for (final item in items) ...[
            UiSidebarItem(
              label: item.label,
              leading:
                  item.leading ?? (item.icon == null ? null : Icon(item.icon)),
              countLabel: item.countLabel,
              selected: item.value == state._selectedFolderIndex,
              onTap: () {
                state._selectFolder(item.value);
                UiToast.info(item.label);
              },
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    ),
  );
}

class _TabContentPanel extends StatelessWidget {
  final String title;
  final String value;

  const _TabContentPanel({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        UiBadge(label: value, color: theme.primary),
      ],
    );
  }
}

String _tabLabel(int index, _ExampleStrings strings) {
  switch (index) {
    case 1:
      return strings.aiScript;
    case 2:
      return strings.videoCopy;
    case 0:
    default:
      return strings.freeCreation;
  }
}

class _MenuExample extends StatelessWidget {
  const _MenuExample();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(UiRadii.lg),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiMenu(
              width: 276,
              submenuWidth: 276,
              items: _fileMenuItems(),
              child: const _MenuBarLabel(label: '文件'),
            ),
            UiMenu(
              items: _editMenuItems(),
              child: const _MenuBarLabel(label: '编辑'),
            ),
            UiMenu(
              items: _viewMenuItems(),
              child: const _MenuBarLabel(label: '查看'),
            ),
          ],
        ),
      ),
    );
  }

  List<UiMenuItem> _fileMenuItems() {
    return [
      UiMenuItem(
        label: '新建文本文件',
        shortcut: 'Ctrl+N',
        onSelected: () => UiToast.info('新建文本文件'),
      ),
      UiMenuItem(
        label: '新建文件...',
        shortcut: 'Ctrl+Alt+N',
        onSelected: () => UiToast.info('新建文件'),
      ),
      UiMenuItem(
        label: '使用配置文件新建窗口',
        children: [
          UiMenuItem(
            label: '默认配置文件',
            selected: true,
            onSelected: () => UiToast.success('默认配置文件'),
          ),
          UiMenuItem(
            label: '团队工作区',
            children: [
              UiMenuItem(label: '前端配置', onSelected: () => UiToast.info('前端配置')),
              UiMenuItem(
                label: '设计系统配置',
                onSelected: () => UiToast.info('设计系统配置'),
              ),
            ],
          ),
        ],
      ),
      const UiMenuItem.divider(),
      UiMenuItem(
        label: '打开文件...',
        shortcut: 'Ctrl+O',
        onSelected: () => UiToast.info('打开文件'),
      ),
      UiMenuItem(
        label: '打开最近的文件',
        children: [
          UiMenuItem(
            label: 'example/lib/main.dart',
            icon: const Icon(Icons.description_outlined),
            onSelected: () => UiToast.info('main.dart'),
          ),
          UiMenuItem(
            label: 'lib/app_ui_kit.dart',
            icon: const Icon(Icons.description_outlined),
            onSelected: () => UiToast.info('app_ui_kit.dart'),
          ),
        ],
      ),
      const UiMenuItem.divider(),
      UiMenuItem(
        label: '保存',
        shortcut: 'Ctrl+S',
        onSelected: () => UiToast.success('保存'),
      ),
      const UiMenuItem(label: '全部保存', enabled: false),
    ];
  }

  List<UiMenuItem> _editMenuItems() {
    return [
      UiMenuItem(
        label: '撤销',
        shortcut: 'Ctrl+Z',
        onSelected: () => UiToast.info('撤销'),
      ),
      UiMenuItem(
        label: '重做',
        shortcut: 'Ctrl+Shift+Z',
        onSelected: () => UiToast.info('重做'),
      ),
      const UiMenuItem.divider(),
      UiMenuItem(
        label: '查找',
        shortcut: 'Ctrl+F',
        onSelected: () => UiToast.info('查找'),
      ),
    ];
  }

  List<UiMenuItem> _viewMenuItems() {
    return [
      UiMenuItem(
        label: '命令面板',
        shortcut: 'Ctrl+Shift+P',
        onSelected: () => UiToast.info('命令面板'),
      ),
      UiMenuItem(
        label: '外观',
        children: [
          UiMenuItem(
            label: '活动栏',
            selected: true,
            onSelected: () => UiToast.info('活动栏'),
          ),
          UiMenuItem(
            label: '状态栏',
            selected: true,
            onSelected: () => UiToast.info('状态栏'),
          ),
        ],
      ),
    ];
  }
}

class _ContextMenuCardExample extends StatelessWidget {
  const _ContextMenuCardExample();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Center(
      child: UiMenu(
        trigger: UiMenuTrigger.contextMenu,
        width: 236,
        submenuWidth: 236,
        offset: Offset.zero,
        items: _cardMenuItems(),
        child: SizedBox(
          width: 240,
          child: UiCard(
            onTap: () => UiToast.info('打开素材'),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.surfaceLight,
                    borderRadius: BorderRadius.circular(UiRadii.lg),
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: theme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'scene-cover.png',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1.8 MB · PNG',
                  style: TextStyle(color: theme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<UiMenuItem> _cardMenuItems() {
    return [
      UiMenuItem(
        label: '打开',
        icon: const Icon(Icons.open_in_new_rounded),
        onSelected: () => UiToast.info('打开素材'),
      ),
      UiMenuItem(
        label: '重命名',
        icon: const Icon(Icons.edit_outlined),
        shortcut: 'F2',
        onSelected: () => UiToast.info('重命名'),
      ),
      UiMenuItem(
        label: '复制为',
        icon: const Icon(Icons.copy_rounded),
        children: [
          UiMenuItem(
            label: '复制文件名',
            onSelected: () => UiToast.success('复制文件名'),
          ),
          UiMenuItem(
            label: '复制相对路径',
            onSelected: () => UiToast.success('复制相对路径'),
          ),
        ],
      ),
      const UiMenuItem.divider(),
      UiMenuItem(
        label: '移到集合',
        icon: const Icon(Icons.drive_file_move_outline),
        children: [
          UiMenuItem(
            label: '参考素材',
            selected: true,
            onSelected: () => UiToast.info('参考素材'),
          ),
          UiMenuItem(label: '归档', onSelected: () => UiToast.info('归档')),
        ],
      ),
      const UiMenuItem.divider(),
      UiMenuItem(
        label: '删除',
        icon: const Icon(Icons.delete_outline),
        onSelected: () => UiToast.error('删除素材'),
      ),
    ];
  }
}

class _MenuBarLabel extends StatelessWidget {
  final String label;

  const _MenuBarLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.surfaceLight,
          borderRadius: BorderRadius.circular(UiRadii.md),
          border: Border.all(color: theme.border.withValues(alpha: 0.7)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SidebarColorSwatch extends StatelessWidget {
  final int value;

  const _SidebarColorSwatch(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: UiColorPalette.fromRgb(value),
        borderRadius: BorderRadius.circular(UiRadii.md),
      ),
    );
  }
}

class _AssetPreviewArea extends StatelessWidget {
  final _ExampleStrings strings;

  const _AssetPreviewArea({required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiSectionHeader(
          title: strings.allAssets,
          subtitle: strings.recommendedPattern,
          trailing: UiButton(
            label: strings.uploadAssets,
            icon: const Icon(Icons.upload_file_outlined),
            size: UiButtonSize.small,
            onPressed: () => UiToast.info(strings.uploadAssets),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(4, (index) {
              return UiSelectableCard(
                selected: index == 0,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, color: theme.primary),
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
    );
  }
}
