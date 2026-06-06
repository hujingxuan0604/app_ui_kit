import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_motion.dart';
import '../../tokens/ui_radii.dart';
import '../../tokens/ui_spacing.dart';
import '../buttons/ui_icon_action_button.dart';

enum UiSideDrawerSide { left, right }

class UiSideDrawer extends StatelessWidget {
  final UiSideDrawerSide side;
  final String? title;
  final String? description;
  final Widget child;
  final Widget? leading;
  final Widget? footer;
  final bool showCloseButton;
  final bool scrollable;
  final bool showFooterDivider;
  final bool useSafeArea;

  /// Fixed drawer width in logical pixels.
  ///
  /// Use either [width] or [widthFactor]. If the value is wider than
  /// [maxWidthFactor] allows, the drawer is clamped to the safe maximum.
  final double? width;

  /// Drawer width as a fraction of the app screen width.
  ///
  /// This is usually the better choice for responsive layouts. Use either
  /// [widthFactor] or [width].
  final double? widthFactor;

  /// Upper bound for the drawer width as a fraction of the app screen width.
  final double? maxWidthFactor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? footerPadding;
  final VoidCallback? onClose;

  const UiSideDrawer({
    super.key,
    this.side = UiSideDrawerSide.left,
    this.title,
    this.description,
    required this.child,
    this.leading,
    this.footer,
    this.showCloseButton = true,
    this.scrollable = true,
    this.showFooterDivider = true,
    this.useSafeArea = true,
    this.width,
    this.widthFactor,
    this.maxWidthFactor,
    this.padding,
    this.headerPadding,
    this.contentPadding,
    this.footerPadding,
    this.onClose,
  }) : assert(width == null || width > 0, 'UiSideDrawer width must be > 0.'),
       assert(
         widthFactor == null || (widthFactor > 0 && widthFactor <= 1),
         'UiSideDrawer widthFactor must be in 0...1.',
       ),
       assert(
         width == null || widthFactor == null,
         'UiSideDrawer accepts either width or widthFactor, not both.',
       );

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    UiSideDrawerSide side = UiSideDrawerSide.left,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
    Color? barrierColor,
    String? barrierLabel,
    RouteSettings? routeSettings,
    Duration transitionDuration = UiMotion.slow,
  }) {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (routeContext, _, __) => builder(routeContext),
      barrierDismissible: barrierDismissible,
      barrierLabel:
          barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.36),
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      transitionDuration: transitionDuration,
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: UiMotion.emphasized,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: side == UiSideDrawerSide.left
                ? const Offset(-1, 0)
                : const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final drawerTheme = theme.components.sideDrawer;
    final mediaQuery = MediaQuery.of(context);
    final effectiveMaxWidthFactor =
        maxWidthFactor ?? drawerTheme.maxWidthFactor;
    assert(
      effectiveMaxWidthFactor > 0 && effectiveMaxWidthFactor <= 1,
      'UiSideDrawer maxWidthFactor must be in 0...1.',
    );

    final screenWidth = mediaQuery.size.width;
    final maxWidth = screenWidth * effectiveMaxWidthFactor;
    final preferredWidth =
        width ??
        (widthFactor == null ? drawerTheme.width : screenWidth * widthFactor!);
    final effectiveWidth = preferredWidth.clamp(0.0, maxWidth).toDouble();

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Align(
        alignment: side._alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding ?? drawerTheme.padding,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: effectiveWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: side._borderRadius(drawerTheme.radius),
                  border: Border.all(color: theme.border),
                  boxShadow: theme.shadowMd,
                ),
                child: _safeArea(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_hasHeader) _Header(drawer: this, theme: theme),
                      Expanded(
                        child: scrollable
                            ? SingleChildScrollView(
                                padding:
                                    contentPadding ??
                                    drawerTheme.contentPadding,
                                child: child,
                              )
                            : Padding(
                                padding:
                                    contentPadding ??
                                    drawerTheme.contentPadding,
                                child: child,
                              ),
                      ),
                      if (footer != null) _Footer(drawer: this, theme: theme),
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

  Widget _safeArea(Widget child) {
    if (!useSafeArea) {
      return child;
    }
    return SafeArea(
      left: side == UiSideDrawerSide.left,
      right: side == UiSideDrawerSide.right,
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  final UiSideDrawer drawer;
  final UiThemeData theme;

  const _Header({required this.drawer, required this.theme});

  @override
  Widget build(BuildContext context) {
    final drawerTheme = theme.components.sideDrawer;
    return Padding(
      padding: drawer.headerPadding ?? drawerTheme.headerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (drawer.leading != null) ...[
            IconTheme(
              data: IconThemeData(color: theme.primary, size: UiSpacing.iconMd),
              child: drawer.leading!,
            ),
            const SizedBox(width: UiSpacing.space3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (drawer.title != null)
                  Text(
                    drawer.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (drawer.description != null &&
                    drawer.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: UiSpacing.space1),
                  Text(
                    drawer.description!,
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
          if (drawer.showCloseButton) ...[
            const SizedBox(width: UiSpacing.space3),
            UiIconActionButton(
              icon: Icons.close_rounded,
              onPressed:
                  drawer.onClose ?? () => Navigator.of(context).maybePop(),
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
  final UiSideDrawer drawer;
  final UiThemeData theme;

  const _Footer({required this.drawer, required this.theme});

  @override
  Widget build(BuildContext context) {
    final drawerTheme = theme.components.sideDrawer;
    return Container(
      padding: drawer.footerPadding ?? drawerTheme.footerPadding,
      decoration: BoxDecoration(
        border: drawer.showFooterDivider
            ? Border(top: BorderSide(color: theme.border))
            : null,
      ),
      child: drawer.footer,
    );
  }
}

extension on UiSideDrawerSide {
  Alignment get _alignment {
    switch (this) {
      case UiSideDrawerSide.left:
        return Alignment.centerLeft;
      case UiSideDrawerSide.right:
        return Alignment.centerRight;
    }
  }

  BorderRadius _borderRadius(double radius) {
    switch (this) {
      case UiSideDrawerSide.left:
        return BorderRadius.horizontal(right: Radius.circular(radius));
      case UiSideDrawerSide.right:
        return BorderRadius.horizontal(left: Radius.circular(radius));
    }
  }
}
