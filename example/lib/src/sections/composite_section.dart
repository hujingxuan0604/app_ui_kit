part of '../../main.dart';

Widget _buildCompositeSection(
  _ExampleHomeState state,
  BuildContext context,
  _ExampleStrings strings,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _CatalogCategory(
        id: 'composite',
        title: strings.categoryTitle('composite'),
        children: [
          _buildPanelsSection(state, context, strings),
          const SizedBox(height: 24),
          _buildDialogsSection(context, strings),
          const SizedBox(height: 24),
          _buildRecipesSection(state, context, strings),
        ],
      ),
    ],
  );
}
