part of '../../main.dart';

class _CatalogCategory extends StatelessWidget {
  final String id;
  final String title;
  final List<Widget> children;

  const _CatalogCategory({
    required this.id,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiSectionHeader(
            title: title,
            titleStyle: TextStyle(
              fontSize: 20,
              color: theme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            subtitle: id,
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
