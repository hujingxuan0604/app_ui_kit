part of '../../main.dart';

class _ColorToken extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorToken({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(UiRadii.lg),
              border: Border.all(color: theme.border),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final double value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: TextStyle(color: theme.textSecondary)),
          ),
          Container(
            width: value * 4,
            height: 8,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Text('${value.toStringAsFixed(0)}px'),
        ],
      ),
    );
  }
}

class _RadiusSample extends StatelessWidget {
  final String label;
  final double radius;

  const _RadiusSample({required this.label, required this.radius});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Column(
      children: [
        Container(
          width: 48,
          height: 36,
          decoration: BoxDecoration(
            color: theme.surfaceLight,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: theme.primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: theme.textSecondary)),
      ],
    );
  }
}

class _GradientToken extends StatelessWidget {
  final String label;
  final Gradient gradient;

  const _GradientToken({required this.label, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(UiRadii.lg),
            border: Border.all(color: theme.border),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: theme.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _ShadowToken extends StatelessWidget {
  final String label;
  final List<BoxShadow> shadows;

  const _ShadowToken({required this.label, required this.shadows});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return SizedBox(
      width: 86,
      child: Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(UiRadii.lg),
              border: Border.all(color: theme.border.withValues(alpha: 0.7)),
              boxShadow: shadows,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: theme.textSecondary)),
        ],
      ),
    );
  }
}

class _TypographyToken extends StatelessWidget {
  final String label;
  final TextStyle style;

  const _TypographyToken({required this.label, required this.style});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(color: theme.textTertiary, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              'Aa 组件文字',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: theme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final double value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceLight,
        borderRadius: BorderRadius.circular(UiRadii.lg),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateLayerSample extends StatelessWidget {
  final String label;
  final double opacity;

  const _StateLayerSample({required this.label, required this.opacity});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Container(
      width: 86,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(UiRadii.lg),
        border: Border.all(color: theme.primary.withValues(alpha: 0.24)),
      ),
      child: Column(
        children: [
          Text(
            '${(opacity * 100).round()}%',
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
