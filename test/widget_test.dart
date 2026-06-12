import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UiThemeController loads and persists theme mode', () async {
    final store = _MemoryThemeModeStore(ThemeMode.dark);
    final controller = UiThemeController(store: store);
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.themeMode, ThemeMode.dark);
    expect(controller.isLoaded, isTrue);

    await controller.setThemeMode(ThemeMode.light);

    expect(store.themeMode, ThemeMode.light);
  });

  test('UiThemeController ignores repeated theme mode changes', () async {
    final store = _MemoryThemeModeStore(ThemeMode.dark);
    final controller = UiThemeController(store: store);
    addTearDown(controller.dispose);

    var notifications = 0;
    controller.addListener(() => notifications++);

    await controller.setThemeMode(ThemeMode.dark);
    await controller.setThemeMode(ThemeMode.dark);

    expect(controller.themeMode, ThemeMode.dark);
    expect(store.saveCount, 1);
    expect(notifications, 1);
  });

  testWidgets('UiThemeModeSwitch controls app theme mode', (tester) async {
    final controller = UiThemeController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      UiThemeApp(
        controller: controller,
        home: const Scaffold(body: UiThemeModeSwitch()),
      ),
    );

    expect(controller.themeMode, ThemeMode.system);

    await tester.tap(find.byIcon(Icons.dark_mode_rounded));
    await tester.pumpAndSettle();

    expect(controller.themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('UiThemeScope exposes the current controller', (tester) async {
    final controller = UiThemeController(initialMode: ThemeMode.dark);
    addTearDown(controller.dispose);

    UiThemeController? watched;
    UiThemeController? read;

    await tester.pumpWidget(
      UiThemeApp(
        controller: controller,
        home: Builder(
          builder: (context) {
            watched = UiThemeScope.of(context);
            read = UiThemeScope.read(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(watched, same(controller));
    expect(read, same(controller));
  });

  testWidgets('UiThemeModeTabs reports selected theme mode', (tester) async {
    final values = <ThemeMode>[];

    await tester.pumpWidget(
      _TestApp(
        child: UiThemeModeTabs(value: ThemeMode.system, onChanged: values.add),
      ),
    );

    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(values, [ThemeMode.dark]);
  });

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

  testWidgets('UiDropdown supports multiple selection', (tester) async {
    var selected = <String>['draft'];

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            theme: UiTheme.light().toThemeData(),
            home: Scaffold(
              body: UiDropdown<String>.multiple(
                label: 'Status',
                value: selected,
                clearable: true,
                options: const [
                  UiDropdownOption(value: 'draft', label: 'Draft'),
                  UiDropdownOption(value: 'published', label: 'Published'),
                  UiDropdownOption(value: 'archived', label: 'Archived'),
                ],
                onChanged: (values) {
                  setState(() => selected = values);
                },
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('Draft'), findsOneWidget);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Published').last);
    await tester.pumpAndSettle();

    expect(selected, ['draft', 'published']);
    expect(find.text('Draft, Published'), findsOneWidget);
    expect(find.text('Archived'), findsOneWidget);

    await tester.tap(find.text('Draft').last);
    await tester.pumpAndSettle();

    expect(selected, ['published']);
    expect(find.text('Published'), findsWidgets);

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(selected, isEmpty);
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

  testWidgets('UiCalendar selects single dates', (tester) async {
    DateTime? selected = DateTime(2026, 6, 3);

    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 360,
          child: UiCalendar(
            value: selected,
            initialMonth: DateTime(2026, 6),
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(selected, DateTime(2026, 6, 15));
  });

  testWidgets('UiCalendar supports multiple date selection', (tester) async {
    var selected = <DateTime>[DateTime(2026, 6, 3)];

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _TestApp(
            child: SizedBox(
              width: 360,
              child: UiCalendar.multiple(
                value: selected,
                initialMonth: DateTime(2026, 6),
                onChanged: (values) => setState(() => selected = values),
              ),
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('8').first);
    await tester.pumpAndSettle();

    expect(selected, [DateTime(2026, 6, 3), DateTime(2026, 6, 8)]);

    await tester.tap(find.text('3').first);
    await tester.pumpAndSettle();

    expect(selected, [DateTime(2026, 6, 8)]);
  });

  testWidgets('UiCalendar supports range selection', (tester) async {
    DateTimeRange? selected;

    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 360,
          child: UiCalendar.range(
            initialMonth: DateTime(2026, 6),
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('10').first);
    await tester.pumpAndSettle();

    expect(selected, isNull);

    await tester.tap(find.text('14').first);
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.start, DateTime(2026, 6, 10));
    expect(selected!.end, DateTime(2026, 6, 14));
  });

  testWidgets('UiDateTimePicker opens panel and confirms value', (
    tester,
  ) async {
    DateTime? selected = DateTime(2026, 6, 3, 14, 30);

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _TestApp(
            child: SizedBox(
              width: 320,
              child: UiDateTimePicker(
                label: 'Schedule',
                value: selected,
                mode: UiDateTimePickerMode.minute,
                title: 'Select schedule',
                onChanged: (value) => setState(() => selected = value),
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('2026-06-03 14:30'), findsOneWidget);

    await tester.tap(find.text('2026-06-03 14:30'));
    await tester.pumpAndSettle();

    expect(find.text('Select schedule'), findsOneWidget);
    expect(find.byType(UiBottomPopup), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(selected, DateTime(2026, 6, 3, 14, 30));
    expect(find.text('Select schedule'), findsNothing);
  });

  testWidgets('UiDateTimePicker wheel supports desktop mouse drag', (
    tester,
  ) async {
    DateTime? preview;

    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 320,
          child: UiDateTimePicker(
            label: 'Schedule',
            value: DateTime(2026, 6, 3, 14, 30),
            mode: UiDateTimePickerMode.minute,
            title: 'Select schedule',
            onPreviewChanged: (value) => preview = value,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('2026-06-03 14:30'));
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.down(
      tester.getCenter(find.byType(ListWheelScrollView).first),
    );
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveBy(const Offset(0, -120));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveBy(const Offset(0, -120));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(preview, isNotNull);
    expect(preview!.year, isNot(2026));
  });

  testWidgets('UiDateTimePicker minute mode renders one day column', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 320,
          child: UiDateTimePicker(
            label: 'Schedule',
            value: DateTime(2026, 1, 28, 14, 30),
            mode: UiDateTimePickerMode.minute,
            title: 'Select schedule',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('2026-01-28 14:30'));
    await tester.pumpAndSettle();

    expect(find.text('2026年'), findsOneWidget);
    expect(find.text('01月'), findsOneWidget);
    expect(find.text('28日'), findsOneWidget);
    expect(find.text('14时'), findsOneWidget);
    expect(find.text('30分'), findsOneWidget);
  });

  testWidgets('UiDateTimePicker clamps day when month changes', (tester) async {
    var previewChanged = false;

    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 320,
          child: UiDateTimePicker(
            label: 'Schedule',
            value: DateTime(2026, 3, 30, 14, 30),
            mode: UiDateTimePickerMode.minute,
            title: 'Select schedule',
            onPreviewChanged: (_) => previewChanged = true,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('2026-03-30 14:30'));
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.down(
      tester.getCenter(find.byType(ListWheelScrollView).at(1)),
    );
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveBy(const Offset(0, 120));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(previewChanged, isTrue);
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

  testWidgets('UiTextField defaults to medium size', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: UiTextField(label: 'Name', initialValue: 'StoryFlow'),
      ),
    );

    final field = tester.widget<UiTextField>(find.byType(UiTextField));
    final input = tester.widget<InputDecorator>(find.byType(InputDecorator));

    expect(field.size, UiTextFieldSize.medium);
    expect(
      input.decoration.contentPadding,
      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
    expect(input.decoration.constraints, const BoxConstraints(minHeight: 48));
    expect(tester.getSize(find.byType(InputDecorator)).height, 48);
  });

  testWidgets(
    'UiTextField keeps medium field height across adornments and error',
    (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: Column(
            children: [
              UiTextField(initialValue: 'StoryFlow'),
              UiTextField(
                initialValue: 'StoryFlow',
                prefix: Icon(Icons.person_outline),
              ),
              UiTextField(initialValue: 'Invalid', errorText: 'Required'),
            ],
          ),
        ),
      );

      final fields = find.byType(InputDecorator);

      expect(tester.getSize(fields.at(0)).height, 48);
      expect(tester.getSize(fields.at(1)).height, 48);
      expect(
        tester.getTopLeft(find.text('Required')).dy -
            tester.getTopLeft(fields.at(2)).dy,
        greaterThanOrEqualTo(48),
      );
    },
  );

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

  testWidgets('UiBottomPopup opens and closes from helper', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open popup',
              onPressed: () {
                UiBottomPopup.show<void>(
                  context: context,
                  builder: (_) => const UiBottomPopup(
                    title: 'Popup title',
                    description: 'Popup description',
                    child: Text('Popup body'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open popup'));
    await tester.pumpAndSettle();

    expect(find.byType(UiBottomPopup), findsOneWidget);
    expect(find.text('Popup title'), findsOneWidget);
    expect(find.text('Popup body'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(UiBottomPopup), findsNothing);
  });

  testWidgets('UiSideDrawer opens from the left by default', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open left drawer',
              onPressed: () {
                UiSideDrawer.show<void>(
                  context: context,
                  builder: (_) => const UiSideDrawer(
                    title: 'Left drawer',
                    child: Text('Left drawer body'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open left drawer'));
    await tester.pumpAndSettle();

    expect(find.byType(UiSideDrawer), findsOneWidget);
    expect(
      tester.widget<UiSideDrawer>(find.byType(UiSideDrawer)).side,
      UiSideDrawerSide.left,
    );
    expect(tester.getRect(find.text('Left drawer body')).left, lessThan(80));
  });

  testWidgets('UiSideDrawer opens from the right and closes from helper', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open right drawer',
              onPressed: () {
                UiSideDrawer.show<void>(
                  context: context,
                  side: UiSideDrawerSide.right,
                  builder: (_) => const UiSideDrawer(
                    side: UiSideDrawerSide.right,
                    title: 'Right drawer',
                    width: 280,
                    child: Text('Right drawer body'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open right drawer'));
    await tester.pumpAndSettle();

    expect(find.byType(UiSideDrawer), findsOneWidget);
    expect(
      tester.widget<UiSideDrawer>(find.byType(UiSideDrawer)).side,
      UiSideDrawerSide.right,
    );
    expect(
      tester.getRect(find.text('Right drawer body')).left,
      greaterThan(800 - 280),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(UiSideDrawer), findsNothing);
  });

  testWidgets('UiSideDrawer widthFactor follows screen width', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open factor drawer',
              onPressed: () {
                UiSideDrawer.show<void>(
                  context: context,
                  builder: (_) => const UiSideDrawer(
                    widthFactor: 0.5,
                    scrollable: false,
                    contentPadding: EdgeInsets.zero,
                    child: SizedBox.expand(key: ValueKey('factor-body')),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open factor drawer'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('factor-body'))).width,
      inInclusiveRange(396, 400),
    );
  });

  testWidgets('UiSideDrawer clamps oversized fixed width', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return UiButton(
              label: 'Open wide drawer',
              onPressed: () {
                UiSideDrawer.show<void>(
                  context: context,
                  builder: (_) => const UiSideDrawer(
                    width: 1200,
                    maxWidthFactor: 0.75,
                    scrollable: false,
                    contentPadding: EdgeInsets.zero,
                    child: SizedBox.expand(key: ValueKey('wide-body')),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open wide drawer'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('wide-body'))).width,
      inInclusiveRange(596, 600),
    );
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

  testWidgets('UiTabs renders rich items and switches content', (tester) async {
    final controller = UiTabsController(0);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: UiTabs(
          controller: controller,
          style: UiTabsStyle.underline,
          tabItems: const [
            UiTabItem(
              label: 'Overview',
              icon: Icons.dashboard_outlined,
              badgeLabel: '3',
              content: Text('Overview panel'),
            ),
            UiTabItem(
              label: 'Details',
              icon: Icons.grid_view_rounded,
              badgeLabel: '',
              content: Text('Details panel'),
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints ==
                const BoxConstraints(
                  minWidth: 14,
                  maxWidth: double.infinity,
                  minHeight: 14,
                  maxHeight: 14,
                ),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints ==
                const BoxConstraints.tightFor(width: 6, height: 6),
      ),
      findsOneWidget,
    );
    final indicatorFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints ==
              const BoxConstraints.tightFor(width: 20, height: 2),
    );
    expect(indicatorFinder, findsOneWidget);
    expect(
      tester
          .getRect(find.text('Overview'))
          .overlaps(tester.getRect(find.text('3'))),
      isFalse,
    );
    expect(
      tester.getRect(find.text('Overview')).bottom,
      lessThan(tester.getRect(indicatorFinder).top),
    );
    expect(find.text('Overview panel'), findsOneWidget);
    expect(find.text('Details panel'), findsNothing);

    await tester.tap(find.text('Details'));
    await tester.pump();

    expect(controller.selectedIndex, 1);
    expect(find.text('Overview panel'), findsNothing);
    expect(find.text('Details panel'), findsOneWidget);
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

  testWidgets('UiTabs accepts either string items or rich tabItems', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: UiTabs(
          selectedIndex: 0,
          items: ['Free creation'],
          tabItems: [UiTabItem(label: 'Rich item')],
        ),
      ),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });
}

class _MemoryThemeModeStore implements UiThemeModeStore {
  ThemeMode? themeMode;
  int saveCount = 0;

  _MemoryThemeModeStore([this.themeMode]);

  @override
  Future<ThemeMode?> loadThemeMode() async => themeMode;

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    saveCount += 1;
    this.themeMode = themeMode;
  }
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
