import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../buttons/ui_icon_action_button.dart';

class UiBottomSheet extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final List<Widget> actions;
  final bool showDragHandle;
  final bool showCloseButton;
  final bool scrollable;
  final double maxWidth;
  final double maxHeightFactor;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry actionsPadding;

  const UiBottomSheet({
    super.key,
    this.title,
    this.description,
    required this.child,
    this.actions = const [],
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.scrollable = true,
    this.maxWidth = 560,
    this.maxHeightFactor = 0.86,
    this.headerPadding = const EdgeInsets.fromLTRB(
      UiSpacing.space5,
      UiSpacing.space2,
      UiSpacing.space5,
      UiSpacing.space3,
    ),
    this.contentPadding = const EdgeInsets.fromLTRB(
      UiSpacing.space5,
      0,
      UiSpacing.space5,
      UiSpacing.space5,
    ),
    this.actionsPadding = const EdgeInsets.fromLTRB(
      UiSpacing.space5,
      0,
      UiSpacing.space5,
      UiSpacing.space5,
    ),
  }) : assert(maxHeightFactor > 0 && maxHeightFactor <= 1);

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
    bool isScrollControlled = true,
    Color? barrierColor,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      routeSettings: routeSettings,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * maxHeightFactor;

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(UiRadii.xxl),
                ),
                border: Border.all(color: theme.border),
                boxShadow: theme.shadowMd,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDragHandle) _DragHandle(color: theme.borderHover),
                    if (_hasHeader) _Header(sheet: this, theme: theme),
                    Flexible(
                      child: scrollable
                          ? SingleChildScrollView(
                              padding: contentPadding,
                              child: child,
                            )
                          : Padding(padding: contentPadding, child: child),
                    ),
                    if (actions.isNotEmpty) _Actions(sheet: this, theme: theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasHeader =>
      title != null || description != null || showCloseButton;
}

class _DragHandle extends StatelessWidget {
  final Color color;

  const _DragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: UiSpacing.space2),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(UiRadii.sm),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UiBottomSheet sheet;
  final UiThemeData theme;

  const _Header({required this.sheet, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sheet.headerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sheet.title != null)
                  Text(
                    sheet.title!,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (sheet.description != null &&
                    sheet.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: UiSpacing.space1),
                  Text(
                    sheet.description!,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (sheet.showCloseButton) ...[
            const SizedBox(width: UiSpacing.space3),
            UiIconActionButton(
              icon: Icons.close_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
              size: 30,
              iconSize: 18,
              radius: UiRadii.md,
              backgroundColor: theme.surfaceLight,
              borderColor: theme.border,
            ),
          ],
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final UiBottomSheet sheet;
  final UiThemeData theme;

  const _Actions({required this.sheet, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sheet.actionsPadding,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.border)),
      ),
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        spacing: UiSpacing.space2,
        overflowSpacing: UiSpacing.space2,
        children: sheet.actions,
      ),
    );
  }
}
