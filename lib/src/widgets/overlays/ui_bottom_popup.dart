import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../buttons/ui_icon_action_button.dart';

class UiBottomPopup extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final Widget? leading;
  final Widget? footer;
  final bool showDragHandle;
  final bool showCloseButton;
  final bool scrollable;
  final bool showFooterDivider;
  final double? maxWidth;
  final double? maxHeight;
  final double? maxHeightFactor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry footerPadding;
  final VoidCallback? onClose;

  const UiBottomPopup({
    super.key,
    this.title,
    this.description,
    required this.child,
    this.leading,
    this.footer,
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.scrollable = true,
    this.showFooterDivider = true,
    this.maxWidth,
    this.maxHeight,
    this.maxHeightFactor,
    this.padding,
    this.headerPadding,
    this.contentPadding,
    this.footerPadding = const EdgeInsets.fromLTRB(
      UiSpacing.space5,
      0,
      UiSpacing.space5,
      UiSpacing.space5,
    ),
    this.onClose,
  });

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
    final popupTheme = theme.components.bottomPopup;
    final mediaQuery = MediaQuery.of(context);
    final effectiveMaxHeightFactor =
        maxHeightFactor ?? popupTheme.maxHeightFactor;
    assert(
      effectiveMaxHeightFactor > 0 && effectiveMaxHeightFactor <= 1,
      'UiBottomPopup maxHeightFactor must be in 0...1.',
    );

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? popupTheme.maxWidth,
            maxHeight:
                maxHeight ?? mediaQuery.size.height * effectiveMaxHeightFactor,
          ),
          child: Padding(
            padding: padding ?? popupTheme.padding,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(popupTheme.radius),
                  ),
                  border: Border.all(color: theme.border),
                  boxShadow: theme.shadowMd,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDragHandle) _DragHandle(theme: theme),
                      if (_hasHeader) _Header(popup: this, theme: theme),
                      Flexible(
                        child: scrollable
                            ? SingleChildScrollView(
                                padding:
                                    contentPadding ?? popupTheme.contentPadding,
                                child: child,
                              )
                            : Padding(
                                padding:
                                    contentPadding ?? popupTheme.contentPadding,
                                child: child,
                              ),
                      ),
                      if (footer != null) _Footer(popup: this, theme: theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasHeader {
    return title != null ||
        description != null ||
        leading != null ||
        showCloseButton;
  }
}

class _DragHandle extends StatelessWidget {
  final UiThemeData theme;

  const _DragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    final popupTheme = theme.components.bottomPopup;
    return Padding(
      padding: const EdgeInsets.only(top: UiSpacing.space2),
      child: Container(
        width: popupTheme.dragHandleWidth,
        height: popupTheme.dragHandleHeight,
        decoration: BoxDecoration(
          color: theme.borderHover,
          borderRadius: BorderRadius.circular(UiRadii.sm),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UiBottomPopup popup;
  final UiThemeData theme;

  const _Header({required this.popup, required this.theme});

  @override
  Widget build(BuildContext context) {
    final popupTheme = theme.components.bottomPopup;
    return Padding(
      padding: popup.headerPadding ?? popupTheme.headerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (popup.leading != null) ...[
            IconTheme(
              data: IconThemeData(color: theme.primary, size: UiSpacing.iconMd),
              child: popup.leading!,
            ),
            const SizedBox(width: UiSpacing.space3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (popup.title != null)
                  Text(
                    popup.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (popup.description != null &&
                    popup.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: UiSpacing.space1),
                  Text(
                    popup.description!,
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
          if (popup.showCloseButton) ...[
            const SizedBox(width: UiSpacing.space3),
            UiIconActionButton(
              icon: Icons.close_rounded,
              onPressed:
                  popup.onClose ?? () => Navigator.of(context).maybePop(),
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

class _Footer extends StatelessWidget {
  final UiBottomPopup popup;
  final UiThemeData theme;

  const _Footer({required this.popup, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: popup.footerPadding,
      decoration: BoxDecoration(
        border: popup.showFooterDivider
            ? Border(top: BorderSide(color: theme.border))
            : null,
      ),
      child: popup.footer,
    );
  }
}
