import 'package:flutter/material.dart';

import 'ui_dialog_shell.dart';

class UiContentDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  final double width;
  final String? description;

  const UiContentDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.width = 420,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return UiDialogShell(
      title: UiDialogTitle(title: title),
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null && description!.trim().isNotEmpty) ...[
              UiDialogDescription(text: description!),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
      actions: actions,
    );
  }
}
