part of '../main.dart';

class ExampleHome extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const ExampleHome({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  late final ImageProvider _demoAvatarImage = MemoryImage(
    Uint8List.fromList(_transparentPngBytes),
  );
  final _nameController = TextEditingController(text: 'StoryFlow');
  final _searchController = TextEditingController();
  final _panelNameController = TextEditingController(text: '镜头 01');
  late final ValueNotifier<String> _activeSectionId;
  final _sections = const [
    _CatalogSection('tokens', Icons.palette_outlined),
    _CatalogSection('buttons', Icons.smart_button_outlined),
    _CatalogSection('inputs', Icons.input_outlined),
    _CatalogSection('display', Icons.view_agenda_outlined),
    _CatalogSection('surfaces', Icons.layers_outlined),
    _CatalogSection('navigation', Icons.alt_route_outlined),
    _CatalogSection('panels', Icons.dashboard_customize_outlined),
    _CatalogSection('dialogs', Icons.web_asset_outlined),
    _CatalogSection('avatar', Icons.account_circle_outlined),
    _CatalogSection('feedback', Icons.notifications_outlined),
    _CatalogSection('recipes', Icons.auto_awesome_mosaic_outlined),
  ];

  _ExampleLanguage _language = _ExampleLanguage.zh;
  int _selectedFolderIndex = 0;
  bool _selectionToggle = true;
  bool _contentSelected = true;
  bool _panelCardExpanded = true;
  bool _panelCardSelected = true;
  int _colorValue = UiColorPalette.defaultRgb;
  String _inputSelectValue = 'draft';
  String? _inputRequiredSelectValue;
  String _panelDropdownValue = '16:9';
  String _selectedAvatarId = 'a';

  @override
  void initState() {
    super.initState();
    _activeSectionId = ValueNotifier<String>(_sections.first.id);
  }

  @override
  void dispose() {
    _activeSectionId.dispose();
    _nameController.dispose();
    _searchController.dispose();
    _panelNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final strings = _ExampleStrings(_language);
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Row(
          children: [
            _CatalogNav(
              sections: _sections,
              activeSectionId: _activeSectionId,
              onSelected: _handleSectionSelected,
              strings: strings,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
                      child: UiPageHero(
                        icon: Icons.widgets_outlined,
                        title: Text(
                          strings.appTitle,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          strings.appSubtitle,
                          style: TextStyle(color: theme.textSecondary),
                        ),
                        content: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            UiBadge(
                              label: strings.light,
                              icon: Icons.light_mode_outlined,
                              color: theme.warning,
                            ),
                            UiBadge(
                              label: strings.dark,
                              icon: Icons.dark_mode_outlined,
                              color: theme.info,
                            ),
                            UiBadge(
                              label: strings.reusable,
                              icon: Icons.check_circle_outline,
                              color: theme.success,
                            ),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _LanguageSwitch(
                              value: _language,
                              strings: strings,
                              onChanged: _changeLanguage,
                            ),
                            _ThemeModeSwitch(
                              value: widget.themeMode,
                              strings: strings,
                              onChanged: widget.onThemeModeChanged,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
                    sliver: SliverToBoxAdapter(
                      child: ValueListenableBuilder<String>(
                        valueListenable: _activeSectionId,
                        builder: (context, sectionId, _) {
                          return KeyedSubtree(
                            key: ValueKey(sectionId),
                            child: _buildActiveSection(
                              sectionId,
                              context,
                              strings,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSectionSelected(String sectionId) {
    if (_activeSectionId.value == sectionId) {
      return;
    }
    _activeSectionId.value = sectionId;
  }

  Widget _buildActiveSection(
    String sectionId,
    BuildContext context,
    _ExampleStrings strings,
  ) {
    switch (sectionId) {
      case 'buttons':
        return _CatalogCategory(
          id: 'buttons',
          title: strings.categoryTitle('buttons'),
          children: [_buildButtonsSection(context, strings)],
        );
      case 'inputs':
        return _CatalogCategory(
          id: 'inputs',
          title: strings.categoryTitle('inputs'),
          children: [_buildInputsSection(this, context, strings)],
        );
      case 'display':
        return _CatalogCategory(
          id: 'display',
          title: strings.categoryTitle('display'),
          children: [_buildDisplaySection(this, context, strings)],
        );
      case 'surfaces':
        return _CatalogCategory(
          id: 'surfaces',
          title: strings.categoryTitle('surfaces'),
          children: [_buildSurfacesSection(this, context, strings)],
        );
      case 'navigation':
        return _CatalogCategory(
          id: 'navigation',
          title: strings.categoryTitle('navigation'),
          children: [_buildNavigationSection(this, context, strings)],
        );
      case 'panels':
        return _CatalogCategory(
          id: 'panels',
          title: strings.categoryTitle('panels'),
          children: [_buildPanelsSection(this, context, strings)],
        );
      case 'dialogs':
        return _CatalogCategory(
          id: 'dialogs',
          title: strings.categoryTitle('dialogs'),
          children: [_buildDialogsSection(context, strings)],
        );
      case 'avatar':
        return _CatalogCategory(
          id: 'avatar',
          title: strings.categoryTitle('avatar'),
          children: [_buildAvatarSection(this, context, strings)],
        );
      case 'feedback':
        return _CatalogCategory(
          id: 'feedback',
          title: strings.categoryTitle('feedback'),
          children: [_buildFeedbackSection(context, strings)],
        );
      case 'recipes':
        return _CatalogCategory(
          id: 'recipes',
          title: strings.categoryTitle('recipes'),
          children: [_buildRecipesSection(this, context, strings)],
        );
      case 'tokens':
      default:
        return _CatalogCategory(
          id: 'tokens',
          title: strings.categoryTitle('tokens'),
          children: [_buildTokensSection(this, context, strings)],
        );
    }
  }

  void _changeLanguage(_ExampleLanguage language) {
    if (_language == language) {
      return;
    }
    final currentPanelName = _panelNameController.text;
    setState(() {
      _language = language;
      final nextStrings = _ExampleStrings(language);
      if (currentPanelName == '镜头 01' || currentPanelName == 'Shot 01') {
        _panelNameController.text = nextStrings.defaultShotName;
      }
    });
  }

  void _selectColor(int value) {
    setState(() => _colorValue = value);
  }

  void _selectInputValue(String value) {
    setState(() => _inputSelectValue = value);
  }

  void _selectRequiredInputValue(String value) {
    setState(() => _inputRequiredSelectValue = value);
  }

  void _toggleSelectionToggle() {
    setState(() => _selectionToggle = !_selectionToggle);
  }

  void _toggleContentSelected() {
    setState(() => _contentSelected = !_contentSelected);
  }

  void _selectFolder(int value) {
    setState(() => _selectedFolderIndex = value);
  }

  void _togglePanelCardSelected() {
    setState(() => _panelCardSelected = !_panelCardSelected);
  }

  void _togglePanelCardExpanded() {
    setState(() => _panelCardExpanded = !_panelCardExpanded);
  }

  void _selectPanelDropdownValue(String value) {
    setState(() => _panelDropdownValue = value);
  }

  void _selectAvatar(String id) {
    setState(() => _selectedAvatarId = id);
  }
}
