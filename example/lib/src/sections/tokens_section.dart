part of '../../main.dart';

Widget _buildTokensSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  final theme = context.uiTheme;
  final colors = [
    (strings.colorPrimary, theme.primary),
    (strings.colorSuccess, theme.success),
    (strings.colorWarning, theme.warning),
    (strings.colorError, theme.error),
    (strings.colorInfo, theme.info),
    (strings.colorSurface, theme.surface),
    (strings.colorElevated, theme.surfaceElevated),
    (strings.colorLight, theme.surfaceLight),
    (strings.colorText, theme.textPrimary),
    (strings.colorMuted, theme.textSecondary),
    (strings.colorBorder, theme.border),
    (strings.colorActiveBorder, UiColors.borderActive(context)),
  ];
  return _ExampleGrid(
    children: [
      _ExampleCard(
        title: 'UiColors / semantic colors',
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((item) {
            return _ColorToken(label: item.$1, color: item.$2);
          }).toList(),
        ),
      ),
      _ExampleCard(
        title: 'UiColors / gradients',
        child: Column(
          children: [
            _GradientToken(
              label: strings.primaryGradient,
              gradient: theme.primaryGradient,
            ),
            const SizedBox(height: 14),
            _GradientToken(
              label: strings.surfaceGradient,
              gradient: theme.surfaceGradient,
            ),
            const SizedBox(height: 14),
            _GradientToken(
              label: strings.glassGradient,
              gradient: UiColors.glassGradient(context),
            ),
          ],
        ),
      ),
      const _ExampleCard(
        title: 'UiSpacing / UiRadii',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetricRow(label: 'space1', value: UiSpacing.space1),
            _MetricRow(label: 'space4', value: UiSpacing.space4),
            _MetricRow(label: 'space8', value: UiSpacing.space8),
            _MetricRow(label: 'space12', value: UiSpacing.space12),
            SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                _RadiusSample(label: 'sm', radius: UiRadii.sm),
                _RadiusSample(label: 'md', radius: UiRadii.md),
                _RadiusSample(label: 'lg', radius: UiRadii.lg),
                _RadiusSample(label: 'xl', radius: UiRadii.xl),
              ],
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.typographyScale,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TypographyToken(label: 'h1', style: UiTypography.h1Style),
            _TypographyToken(label: 'h2', style: UiTypography.h2Style),
            _TypographyToken(label: 'h3', style: UiTypography.h3Style),
            _TypographyToken(label: 'body', style: UiTypography.bodyStyle),
            _TypographyToken(
              label: 'caption',
              style: UiTypography.captionStyle,
            ),
            _TypographyToken(
              label: 'overline',
              style: UiTypography.overlineStyle,
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.shadowTokens,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.headline,
              style: UiTypography.h3Style.copyWith(
                color: theme.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.bodyTypography,
              style: UiTypography.textTheme().bodyMedium?.copyWith(
                color: theme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _ShadowToken(label: 'xs', shadows: theme.shadowXs),
                _ShadowToken(label: 'sm', shadows: theme.shadowSm),
                _ShadowToken(label: 'md', shadows: theme.shadowMd),
                _ShadowToken(label: 'lg', shadows: UiColors.shadowLg(context)),
              ],
            ),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.layoutMetrics,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _MetricPill(label: 'topBar', value: UiSpacing.topBarHeight),
            _MetricPill(label: 'leftNav', value: UiSpacing.leftNavWidth),
            _MetricPill(label: 'leftPanel', value: UiSpacing.leftPanelWidth),
            _MetricPill(label: 'rightPanel', value: UiSpacing.rightPanelWidth),
            _MetricPill(label: 'dialogSm', value: UiSpacing.dialogSm),
            _MetricPill(label: 'dialogMd', value: UiSpacing.dialogMd),
            _MetricPill(label: 'avatarMd', value: UiSpacing.avatarMd),
            _MetricPill(label: 'iconLg', value: UiSpacing.iconLg),
          ],
        ),
      ),
      _ExampleCard(
        title: strings.motionState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetricPill(
                  label: strings.durationFast,
                  value: UiMotion.fast.inMilliseconds.toDouble(),
                ),
                _MetricPill(
                  label: strings.durationNormal,
                  value: UiMotion.normal.inMilliseconds.toDouble(),
                ),
                _MetricPill(
                  label: strings.durationSlow,
                  value: UiMotion.slow.inMilliseconds.toDouble(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StateLayerSample(
                  label: strings.stateHover,
                  opacity: UiStateLayer.hover,
                ),
                _StateLayerSample(
                  label: strings.statePressed,
                  opacity: UiStateLayer.pressed,
                ),
                _StateLayerSample(
                  label: strings.stateSelected,
                  opacity: UiStateLayer.selected,
                ),
                _StateLayerSample(
                  label: strings.stateFocus,
                  opacity: UiStateLayer.focus,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
