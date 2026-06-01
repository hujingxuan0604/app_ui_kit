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

  testWidgets('UiSelect calls onChanged when an option is selected', (
    tester,
  ) async {
    String? selected = 'draft';

    await tester.pumpWidget(
      MaterialApp(
        theme: UiTheme.light().toThemeData(),
        home: Scaffold(
          body: UiSelect<String>(
            label: 'Status',
            value: selected,
            options: const [
              UiSelectOption(value: 'draft', label: 'Draft'),
              UiSelectOption(value: 'published', label: 'Published'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('Draft'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Published').last);
    await tester.pumpAndSettle();

    expect(selected, 'published');
  });

  testWidgets('UiSelect requires value to match exactly one option', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UiTheme.light().toThemeData(),
        home: Scaffold(
          body: UiSelect<String>(
            value: 'missing',
            options: const [UiSelectOption(value: 'draft', label: 'Draft')],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
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
