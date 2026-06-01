part of '../../main.dart';

class _ExampleGrid extends StatelessWidget {
  final List<Widget> children;

  const _ExampleGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 980 ? 2 : 1;
        const spacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;

  const _ExampleCard({required this.title, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final content = Padding(padding: const EdgeInsets.all(18), child: child);
    return UiCard(
      interactive: false,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Text(
                title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Divider(height: 1, color: theme.border),
            if (height == null) content else Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
