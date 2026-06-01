part of '../../main.dart';

enum _ExampleLanguage { zh, en }

class _ExampleStrings {
  final _ExampleLanguage language;

  const _ExampleStrings(this.language);

  bool get isZh => language == _ExampleLanguage.zh;

  String get appTitle =>
      isZh ? 'app_ui_kit 组件目录' : 'app_ui_kit component catalog';
  String get appSubtitle => isZh
      ? '按组件模块展示 tokens、主题、基础组件和复合组件。'
      : 'Browse tokens, themes, base components, and composite components by module.';
  String get navSubtitle => isZh ? '组件目录' : 'Component catalog';
  String get navSummary => isZh ? '快速切换组件分类' : 'Fast section switching';
  String categoryCount(int count) => isZh ? '$count 个分类' : '$count categories';

  String get light => isZh ? '浅色' : 'Light';
  String get dark => isZh ? '深色' : 'Dark';
  String get reusable => isZh ? '可复用' : 'Reusable';
  String get lightMode => isZh ? '浅色模式' : 'Light mode';
  String get darkMode => isZh ? '深色模式' : 'Dark mode';
  String get systemMode => isZh ? '跟随系统' : 'System mode';
  String get languageZh => '中';
  String get languageEn => 'EN';

  String sectionLabel(String id) {
    switch (id) {
      case 'tokens':
        return isZh ? 'Tokens 与主题' : 'Tokens';
      case 'buttons':
        return isZh ? '按钮' : 'Buttons';
      case 'inputs':
        return isZh ? '输入控件' : 'Inputs';
      case 'display':
        return isZh ? '展示组件' : 'Display';
      case 'surfaces':
        return isZh ? '容器表面' : 'Surfaces';
      case 'navigation':
        return isZh ? '导航' : 'Navigation';
      case 'panels':
        return isZh ? '面板' : 'Panels';
      case 'dialogs':
        return isZh ? '弹窗' : 'Dialogs';
      case 'avatar':
        return isZh ? '头像' : 'Avatar';
      case 'feedback':
        return isZh ? '反馈' : 'Feedback';
      case 'composite':
        return isZh ? '复合组件' : 'Composite';
      case 'recipes':
        return isZh ? '组合示例' : 'Recipes';
      default:
        return id;
    }
  }

  String categoryTitle(String id) => id == 'tokens'
      ? (isZh ? 'Tokens 与主题' : 'Tokens & Theme')
      : sectionLabel(id);

  String get primary => isZh ? '主按钮' : 'Primary';
  String get secondary => isZh ? '次要按钮' : 'Secondary';
  String get ghost => isZh ? '透明按钮' : 'Ghost';
  String get danger => isZh ? '危险操作' : 'Danger';
  String get loading => isZh ? '加载中' : 'Loading';
  String get disabled => isZh ? '禁用' : 'Disabled';
  String get fullWidth => isZh ? '全宽按钮' : 'Full width';
  String get search => isZh ? '搜索' : 'Search';
  String get clear => isZh ? '清空' : 'Clear';
  String get selected => isZh ? '已选中' : 'Selected';
  String get zoomIn => isZh ? '放大' : 'Zoom in';
  String get delete => isZh ? '删除' : 'Delete';
  String get copy => isZh ? '复制' : 'Copy';
  String get allNotes => isZh ? '全部笔记' : 'All notes';
  String get favoriteNotes => isZh ? '收藏笔记' : 'Favorite notes';
  String get pinnedNotes => isZh ? '置顶笔记' : 'Pinned notes';

  String toast(String value) => isZh ? '$value 已触发' : '$value triggered';
  String submitted(String value) => isZh ? '已提交：$value' : 'Submitted: $value';

  String get name => isZh ? '名称' : 'Name';
  String get enterName => isZh ? '输入名称' : 'Enter a name';
  String get password => isZh ? '密码' : 'Password';
  String get toggleVisibility => isZh ? '显示或隐藏密码' : 'Toggle visibility';
  String get description => isZh ? '描述' : 'Description';
  String get multilineInput => isZh ? '多行输入' : 'Multi-line input';
  String get error => isZh ? '错误' : 'Error';
  String get invalidValue => isZh ? '无效内容' : 'invalid';
  String get validValueHint => isZh ? '请输入有效内容' : 'Please enter a valid value';
  String get selectedColor => isZh ? '已选颜色' : 'Selected color';
  String get status => isZh ? '状态' : 'Status';
  String get compact => isZh ? '紧凑' : 'Compact';
  String get floatingLabel => isZh ? '浮动标签' : 'Floating label';
  String get fillParent => isZh ? '填充父级尺寸' : 'Fill parent';
  String get chooseStatus => isZh ? '选择状态' : 'Choose status';
  String get draftStatus => isZh ? '草稿' : 'Draft';
  String get publishedStatus => isZh ? '已发布' : 'Published';
  String get archivedStatus => isZh ? '已归档' : 'Archived';
  String get selectRequired => isZh ? '请选择一个状态' : 'Please choose a status';
  String get assetType => isZh ? '素材类型' : 'Asset type';
  String get chooseAssetType => isZh ? '选择素材类型' : 'Choose asset type';
  String get searchAssetType => isZh ? '搜索素材类型' : 'Search types';
  String get noAssetTypes => isZh ? '没有匹配的素材类型' : 'No matching types';
  String get voiceover => isZh ? '旁白' : 'Voiceover';
  String get voiceoverDescription =>
      isZh ? '适合口播、叙事和解释型片段' : 'Narration, explainers, and voice-led scenes';
  String get soundtrack => isZh ? '配乐' : 'Soundtrack';
  String get soundtrackDescription =>
      isZh ? '为镜头组选择情绪和节奏' : 'Mood and rhythm for a sequence';
  String get broll => isZh ? '补充镜头' : 'B-roll';
  String get brollDescription =>
      isZh ? '用于覆盖转场、细节或环境镜头' : 'Cutaways, details, and ambient footage';

  String get defaultLabel => isZh ? '默认' : 'Default';
  String get customStyle => isZh ? '自定义样式' : 'Custom style';
  String get inactive => isZh ? '未激活' : 'Inactive';
  String get active => isZh ? '已激活' : 'Active';
  String get sectionTitle => isZh ? '区块标题' : 'Section title';
  String get sectionSubtitle =>
      isZh ? '带有右侧操作的副标题文本' : 'Subtitle text with a trailing action';
  String get action => isZh ? '操作' : 'Action';
  String get prompt => isZh ? '提示词' : 'Prompt';
  String get infoRowValue => isZh
      ? '用于在表单或面板中展示标签与内容的紧凑信息行。'
      : 'A compact row for displaying label-value information in forms or panels.';
  String get model => isZh ? '模型' : 'Model';
  String get overview => isZh ? '总览' : 'Overview';
  String get archive => isZh ? '归档' : 'Archive';

  String get colorPrimary => isZh ? '主色' : 'Primary';
  String get colorSuccess => isZh ? '成功' : 'Success';
  String get colorWarning => isZh ? '警告' : 'Warning';
  String get colorError => isZh ? '错误' : 'Error';
  String get colorInfo => isZh ? '信息' : 'Info';
  String get colorSurface => isZh ? '表面' : 'Surface';
  String get colorElevated => isZh ? '浮层' : 'Elevated';
  String get colorLight => isZh ? '浅表面' : 'Light';
  String get colorText => isZh ? '文本' : 'Text';
  String get colorMuted => isZh ? '弱文本' : 'Muted';
  String get colorBorder => isZh ? '边框' : 'Border';
  String get colorActiveBorder => isZh ? '激活边框' : 'Active border';
  String get primaryGradient => isZh ? '主色渐变' : 'Primary gradient';
  String get surfaceGradient => isZh ? '表面渐变' : 'Surface gradient';
  String get glassGradient => isZh ? '玻璃渐变' : 'Glass gradient';
  String get shadowTokens => isZh ? '阴影层级' : 'Shadow scale';
  String get layoutMetrics => isZh ? '布局尺寸' : 'Layout metrics';
  String get componentMetrics => isZh ? '组件尺寸' : 'Component metrics';
  String get motionState => isZh ? 'Motion 与状态层' : 'Motion & state layers';
  String get durationFast => isZh ? '快速' : 'Fast';
  String get durationNormal => isZh ? '常规' : 'Normal';
  String get durationSlow => isZh ? '慢速' : 'Slow';
  String get stateHover => isZh ? '悬浮' : 'Hover';
  String get statePressed => isZh ? '按下' : 'Pressed';
  String get stateSelected => isZh ? '选中' : 'Selected';
  String get stateFocus => isZh ? '聚焦' : 'Focus';
  String get headline => isZh ? '标题文本' : 'Headline';
  String get bodyTypography => isZh
      ? '来自共享排版 tokens 的正文文本。'
      : 'Body text from shared typography tokens.';
  String get typographyScale => isZh ? '排版层级' : 'Typography scale';

  String get cardTapped => isZh ? '卡片已点击' : 'Card tapped';
  String get selectedCard =>
      isZh ? '选中卡片，支持悬浮和焦点样式' : 'Selected card with hover and focus style';
  String get listItem => isZh ? '列表项' : 'List item';
  String get listItemSubtitle =>
      isZh ? '内部使用 UiCard' : 'Uses UiCard internally';
  String get surfacePanel => isZh ? '表面面板' : 'Surface panel';
  String get surfaceDescription =>
      isZh ? '用于分组内容的安静边框容器。' : 'A quiet framed container for grouped content.';
  String get selectedAsset => isZh ? '已选素材' : 'Selected asset';
  String get unselectedAsset => isZh ? '未选素材' : 'Unselected asset';
  String get doubleTapped => isZh ? '双击已触发' : 'Double tapped';

  String get allAssets => isZh ? '全部素材' : 'All assets';
  String get storyboard => isZh ? '分镜' : 'Storyboard';
  String get reference => isZh ? '参考' : 'Reference';
  String get freeCreation => isZh ? '自由创作' : 'Free creation';
  String get aiScript => isZh ? 'AI 剧本' : 'AI script';
  String get videoCopy => isZh ? '视频复刻' : 'Video copy';
  String get currentMode => isZh ? '当前模式' : 'Current mode';
  String get folders => isZh ? '文件夹' : 'Folders';
  String get searchFolders => isZh ? '搜索文件夹' : 'Search folders';
  String get createFolder => isZh ? '新建文件夹' : 'Create folder';
  String get renameFolder => isZh ? '重命名文件夹' : 'Rename folder';
  String get deleteFolder => isZh ? '删除文件夹' : 'Delete folder';

  String get shotList => isZh ? '镜头列表' : 'Shot list';
  String get defaultShotName => isZh ? '镜头 01' : 'Shot 01';
  String get add => isZh ? '添加' : 'Add';
  String get close => isZh ? '关闭' : 'Close';
  String get currentProject => isZh ? '当前项目' : 'Current project';
  String get filter => isZh ? '筛选' : 'Filter';
  String get shotCard => isZh ? '镜头卡片' : 'Shot card';
  String get collapsedContent => isZh ? '折叠内容' : 'Collapsed content';
  String get title => isZh ? '标题' : 'Title';
  String get ratio => isZh ? '比例' : 'Ratio';
  String get cinematic => isZh ? '电影感' : 'Cinematic';
  String get calm => isZh ? '平静' : 'Calm';
  String get shot => isZh ? '镜头' : 'Shot';
  String get saved => isZh ? '已保存' : 'Saved';
  String get noContent => isZh ? '暂无内容' : 'No content';
  String get emptyDescription => isZh
      ? 'UiPanelEmptyState 用于空列表、空搜索结果等状态。'
      : 'Use UiPanelEmptyState for empty lists and empty search results.';
  String get create => isZh ? '创建' : 'Create';
  String get created => isZh ? '已创建' : 'Created';
  String get changed => isZh ? '已变更' : 'changed';
  String get same => isZh ? '相同' : 'same';
  String get collapse => isZh ? '收起' : 'Collapse';
  String get expand => isZh ? '展开' : 'Expand';
  String get mixinSave => isZh ? 'Mixin 已保存' : 'Mixin save';
  String get toggleOne => isZh ? '切换 1' : 'Toggle 1';
  String savedItem(int index) => isZh ? '已保存第 $index 项' : 'Saved item $index';

  String get formDialog => isZh ? '表单弹窗' : 'Form dialog';
  String get createItem => isZh ? '创建项目' : 'Create item';
  String get formDialogDescription => isZh
      ? 'UiFormDialog 用于承载自定义表单内容。'
      : 'UiFormDialog wraps custom form content.';
  String get bottomSheet => isZh ? '底部弹窗' : 'Bottom sheet';
  String get bottomSheetDescription => isZh
      ? 'UiBottomSheet 适合移动端操作确认、快速编辑和轻量选择。'
      : 'UiBottomSheet is useful for quick edits, choices, and mobile actions.';
  String get quickSettings => isZh ? '快速设置' : 'Quick settings';
  String get sheetOptionOne => isZh ? '当前项目' : 'Current project';
  String get sheetOptionTwo => isZh ? '输出比例' : 'Output ratio';
  String get enterTitle => isZh ? '输入标题' : 'Enter title';
  String get editTag => isZh ? '编辑标签' : 'Edit tag';
  String get save => isZh ? '保存' : 'Save';
  String get pickTags => isZh ? '选择标签' : 'Pick tags';
  String createdTag(String label) => isZh ? '已创建 $label' : 'Created $label';

  String get edit => isZh ? '编辑' : 'Edit';
  String get squareAvatar => isZh ? '方形头像' : 'Square avatar';
  String get clickableAvatar => isZh ? '头像已点击' : 'Clickable avatar';
  String get avatarPicker => isZh ? '选择头像' : 'Avatar picker';
  String selectedAvatar(String id) => isZh ? '已选择 $id' : 'Selected $id';

  String get success => isZh ? '成功' : 'Success';
  String get info => isZh ? '信息' : 'Info';
  String get warning => isZh ? '警告' : 'Warning';
  String get operationCompleted => isZh ? '操作已完成' : 'Operation completed';
  String get helpfulInformation => isZh ? '这是一条提示信息' : 'Helpful information';
  String get checkInput => isZh ? '请检查输入内容' : 'Please check the input';
  String get somethingWentWrong => isZh ? '出现了一些问题' : 'Something went wrong';

  String get actionFooter => isZh ? '底部操作区' : 'Action footer';
  String get compactToolbar => isZh ? '紧凑工具栏' : 'Compact toolbar';
  String get formExample => isZh ? '项目表单' : 'Project form example';
  String get formName => isZh ? '项目名称' : 'Project name';
  String get formStyle => isZh ? '视觉风格' : 'Visual style';
  String get formPrompt => isZh ? '提示词' : 'Prompt';
  String get publish => isZh ? '发布' : 'Publish';
  String get draft => isZh ? '草稿' : 'Draft';
  String get cardVariants => isZh ? '卡片变体' : 'Card variants';
  String get dashboardRecipe => isZh ? '项目概览' : 'Project dashboard';
  String get assetRecipe => isZh ? '素材管理布局' : 'Asset management layout';
  String get dialogRecipe => isZh ? '弹窗表单' : 'Complete dialog form';
  String get recommendedPattern => isZh ? '推荐搭配' : 'Recommended pattern';
  String get uploadAssets => isZh ? '导入素材' : 'Import assets';
  String get renderQueue => isZh ? '渲染队列' : 'Render queue';
  String get activeProject => isZh ? '短片预告片' : 'Short trailer';
  String get ready => isZh ? '就绪' : 'Ready';
  String get generating => isZh ? '生成中' : 'Generating';
  String get reviewNeeded => isZh ? '待检查' : 'Review needed';
  String get copyPatternHint =>
      isZh ? '常见的底部操作区组合。' : 'A common action footer composition.';
}
