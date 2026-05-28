# app_ui_kit

Reusable Flutter UI foundation extracted from StoryFlow.

## Features

- Light and dark themes with reusable design tokens
- Semantic colors, spacing, radii, typography, shadows, motion and state layers
- Buttons, icon buttons, inputs, cards, selectable surfaces, badges and panels
- Form dialogs, color picker, toast feedback, avatar and avatar picker widgets
- Navigation/sidebar primitives and common display components

## Usage

```dart
import 'package:app_ui_kit/app_ui_kit.dart';

MaterialApp(
  theme: UiTheme.light().toThemeData(),
  darkTheme: UiTheme.dark().toThemeData(),
  home: const App(),
);
```

```dart
UiButton(
  label: '保存',
  icon: const Icon(Icons.save_rounded),
  onPressed: () {},
)
```

```dart
UiInput(
  label: '名称',
  hintText: '请输入名称',
  onChanged: (value) {},
)
```

## Example

The example app is a component catalog that covers tokens, themes, buttons,
inputs, display widgets, surfaces, navigation, panels, dialogs, avatar widgets,
feedback and common recipes.

```bash
cd packages/app_ui_kit/example
flutter run
```

## Package Boundary

This package must not import StoryFlow business modules. Keep project, asset,
shot, segment, magic book and AI generation concepts outside this package.
