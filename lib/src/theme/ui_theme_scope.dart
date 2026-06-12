import 'package:flutter/widgets.dart';

import 'ui_theme_controller.dart';

class UiThemeScope extends InheritedNotifier<UiThemeController> {
  const UiThemeScope({
    super.key,
    required UiThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static UiThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UiThemeScope>();
    assert(scope != null, 'UiThemeScope not found in context.');
    return scope!.notifier!;
  }

  static UiThemeController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UiThemeScope>()?.notifier;
  }

  @Deprecated('Use maybeOf instead.')
  static UiThemeController? maybeControllerOf(BuildContext context) {
    return maybeOf(context);
  }

  @Deprecated('Use of instead.')
  static UiThemeController controllerOf(BuildContext context) {
    return of(context);
  }

  static UiThemeController? read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<UiThemeScope>();
    final widget = element?.widget;
    if (widget is UiThemeScope) {
      return widget.notifier;
    }
    return null;
  }
}

extension UiThemeControllerBuildContext on BuildContext {
  UiThemeController get uiThemeController {
    return UiThemeScope.of(this);
  }

  UiThemeController? get maybeUiThemeController {
    return UiThemeScope.maybeOf(this);
  }
}
