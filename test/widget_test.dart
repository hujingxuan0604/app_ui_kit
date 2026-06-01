import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UiMenu opens nested items and calls selected leaf', (
    tester,
  ) async {
    var selected = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiMenu(
          items: [
            UiMenuItem(
              label: 'File',
              children: [
                UiMenuItem(
                  label: 'New text file',
                  onSelected: () => selected = true,
                ),
              ],
            ),
          ],
          child: const Text('Open menu'),
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await tester.pump();

    expect(find.text('File'), findsOneWidget);

    await tester.tap(find.text('File'));
    await tester.pump();

    expect(find.text('New text file'), findsOneWidget);

    await tester.tap(find.text('New text file'));
    await tester.pump();

    expect(selected, isTrue);
    expect(find.text('File'), findsNothing);
  });

  testWidgets('UiMenu context trigger opens from secondary tap', (
    tester,
  ) async {
    var selected = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiMenu(
          trigger: UiMenuTrigger.contextMenu,
          items: [
            UiMenuItem(
              label: 'Context action',
              onSelected: () => selected = true,
            ),
          ],
          child: const Text('Context target'),
        ),
      ),
    );

    await tester.tap(find.text('Context target'));
    await tester.pump();

    expect(find.text('Context action'), findsNothing);

    await tester.tap(find.text('Context target'), buttons: kSecondaryButton);
    await tester.pump();

    expect(find.text('Context action'), findsOneWidget);

    await tester.tap(find.text('Context action'));
    await tester.pump();

    expect(selected, isTrue);
  });

  testWidgets('UiMenu disabled items do not call callbacks', (tester) async {
    var selected = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiMenu(
          items: [
            UiMenuItem(
              label: 'Disabled',
              enabled: false,
              onSelected: () => selected = true,
            ),
          ],
          child: const Text('Open menu'),
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await tester.pump();
    await tester.tap(find.text('Disabled'));
    await tester.pump();

    expect(selected, isFalse);
    expect(find.text('Disabled'), findsOneWidget);
  });

  testWidgets('UiMenuButton opens menu and calls selected item', (
    tester,
  ) async {
    var selected = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiMenuButton.filter(
          items: [
            UiMenuItem(label: 'All notes', onSelected: () => selected = true),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(UiMenuButton));
    await tester.pump();

    expect(find.text('All notes'), findsOneWidget);

    await tester.tap(find.text('All notes'));
    await tester.pump();

    expect(selected, isTrue);
    expect(find.text('All notes'), findsNothing);
  });

  testWidgets('UiMenu supports at most three levels', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: UiMenu(
          items: [
            UiMenuItem(
              label: 'Level 1',
              children: [
                UiMenuItem(
                  label: 'Level 2',
                  children: [
                    UiMenuItem(
                      label: 'Level 3',
                      children: [UiMenuItem(label: 'Level 4')],
                    ),
                  ],
                ),
              ],
            ),
          ],
          child: Text('Open menu'),
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('UiDropdown calls onChanged when an option is selected', (
    tester,
  ) async {
    String? selected = 'draft';

    await tester.pumpWidget(
      MaterialApp(
        theme: UiTheme.light().toThemeData(),
        home: Scaffold(
          body: UiDropdown<String>(
            label: 'Status',
            value: selected,
            options: const [
              UiDropdownOption(value: 'draft', label: 'Draft'),
              UiDropdownOption(value: 'published', label: 'Published'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('Draft'), findsOneWidget);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_rounded), findsNothing);

    await tester.tap(find.text('Published').last);
    await tester.pumpAndSettle();

    expect(selected, 'published');
  });

  testWidgets('UiDropdown can search options and clear the selection', (
    tester,
  ) async {
    String? selected = 'draft';

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            theme: UiTheme.light().toThemeData(),
            home: Scaffold(
              body: UiDropdown<String>(
                label: 'Status',
                value: selected,
                searchable: true,
                clearable: true,
                options: const [
                  UiDropdownOption(value: 'draft', label: 'Draft'),
                  UiDropdownOption(value: 'published', label: 'Published'),
                ],
                onChanged: (value) => setState(() => selected = value),
              ),
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'pub');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Published').last);
    await tester.pumpAndSettle();

    expect(selected, 'published');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('UiDropdown requires value to match exactly one option', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UiTheme.light().toThemeData(),
        home: Scaffold(
          body: UiDropdown<String>(
            value: 'missing',
            options: const [UiDropdownOption(value: 'draft', label: 'Draft')],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('UiTextField keeps outside label by default', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: UiTextField(label: 'Name', initialValue: 'StoryFlow'),
      ),
    );

    final input = tester.widget<InputDecorator>(find.byType(InputDecorator));

    expect(input.decoration.labelText, isNull);
    expect(find.text('Name'), findsOneWidget);
  });

  testWidgets('UiTextField supports floating label position', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: UiTextField(
          label: 'Name',
          labelPosition: UiTextFieldLabelPosition.floating,
          initialValue: 'StoryFlow',
        ),
      ),
    );

    final input = tester.widget<InputDecorator>(find.byType(InputDecorator));

    expect(input.decoration.labelText, 'Name');
    expect(
      input.decoration.floatingLabelBehavior,
      FloatingLabelBehavior.always,
    );
  });

  testWidgets('UiTextField fill layout follows parent size', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 160,
          height: 48,
          child: UiTextField(
            label: 'Name',
            layout: UiTextFieldLayout.fill,
            initialValue: 'StoryFlow',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(UiTextField)), const Size(160, 48));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).expands,
      isFalse,
    );
  });

  testWidgets('UiTextField fill layout expands multiline field', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 160,
          height: 80,
          child: UiTextField(
            layout: UiTextFieldLayout.fill,
            maxLines: 3,
            initialValue: 'StoryFlow',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).expands,
      isTrue,
    );
  });

  testWidgets('UiSearchField reports changes and clears value', (tester) async {
    var value = 'initial';
    var cleared = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiSearchField(
          initialValue: value,
          hintText: 'Search',
          onChanged: (next) => value = next,
          onClear: () => cleared = true,
        ),
      ),
    );

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'query');
    await tester.pump();

    expect(value, 'query');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(value, '');
    expect(cleared, isTrue);
  });

  testWidgets('UiBottomSheet opens and closes from helper', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open sheet',
              onPressed: () {
                UiBottomSheet.show<void>(
                  context: context,
                  builder: (_) => const UiBottomSheet(
                    title: 'Sheet title',
                    description: 'Sheet description',
                    child: Text('Sheet body'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(UiBottomSheet), findsOneWidget);
    expect(find.text('Sheet title'), findsOneWidget);
    expect(find.text('Sheet body'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(UiBottomSheet), findsNothing);
  });

  testWidgets('UiTabs calls onChanged when an item is selected', (
    tester,
  ) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      _TestApp(
        child: UiTabs(
          selectedIndex: selectedIndex,
          items: const ['Free creation', 'AI script', 'Video copy'],
          onChanged: (index) => selectedIndex = index,
        ),
      ),
    );

    await tester.tap(find.text('AI script'));
    await tester.pump();

    expect(selectedIndex, 1);
  });

  testWidgets('UiTabs updates controller when an item is selected', (
    tester,
  ) async {
    final controller = UiTabsController(0);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: UiTabs(
          controller: controller,
          items: const ['Free creation', 'AI script', 'Video copy'],
        ),
      ),
    );

    await tester.tap(find.text('Video copy'));
    await tester.pump();

    expect(controller.value, 2);
    expect(controller.selectedIndex, 2);
  });

  testWidgets('UiTabs requires selected index to be within items', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(child: UiTabs(selectedIndex: 2, items: ['Free creation'])),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('UiTabs requires either selectedIndex or controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(child: UiTabs(items: ['Free creation'])),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('UiTabs accepts either selectedIndex or controller', (
    tester,
  ) async {
    final controller = UiTabsController(0);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: UiTabs(
          selectedIndex: 0,
          controller: controller,
          items: const ['Free creation'],
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiTheme.light().toThemeData(),
      home: Scaffold(body: Center(child: child)),
    );
  }
}
