import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';

class UiDialogShell extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry actionsPadding;

  const UiDialogShell({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.titlePadding = const EdgeInsets.fromLTRB(20, 20, 20, 12),
    this.contentPadding = const EdgeInsets.fromLTRB(20, 0, 20, 18),
    this.actionsPadding = const EdgeInsets.fromLTRB(20, 0, 20, 18),
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return AlertDialog(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.components.dialog.radius),
        side: BorderSide(color: theme.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      actionsPadding: actionsPadding,
      title: title,
      content: content,
      actions: actions,
    );
  }
}

class UiDialogTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;

  const UiDialogTitle({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final titleText = Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: theme.textPrimary,
      ),
    );

    if (icon == null) {
      return titleText;
    }

    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? theme.primary),
        const SizedBox(width: 10),
        Expanded(child: titleText),
      ],
    );
  }
}

class UiDialogDescription extends StatelessWidget {
  final String text;
  final double fontSize;
  final double height;

  const UiDialogDescription({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.height = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return Text(
      text,
      style: TextStyle(
        color: theme.textSecondary,
        fontSize: fontSize,
        height: height,
      ),
    );
  }
}
