import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../buttons/ui_button.dart';
import '../dialogs/ui_dialog_shell.dart';

abstract class UiPanelEditableState<D> {
  bool hasChangesFrom(D original);
}

mixin UiPanelEditMixin<T extends StatefulWidget> on State<T> {
  int? expandedIndex;
  int? selectedIndex;
  final Map<int, bool> hasChanges = {};

  void checkUnsavedChanges(int index, VoidCallback onConfirm) {
    if (hasChanges[index] == true) {
      showUnsavedDialog(index, onConfirm);
      return;
    }
    onConfirm();
  }

  void showUnsavedDialog(int index, VoidCallback onConfirm) {
    final theme = context.uiTheme;
    showDialog(
      context: context,
      builder: (dialogContext) => _UnsavedChangesDialog(
        theme: theme,
        message: getUnsavedMessage(index),
        onDiscard: () {
          Navigator.of(dialogContext).pop();
          discardChanges(index);
          onConfirm();
        },
        onContinue: () => Navigator.of(dialogContext).pop(),
        onSave: () {
          Navigator.of(dialogContext).pop();
          saveChanges(index);
          onConfirm();
        },
      ),
    );
  }

  String getUnsavedMessage(int index) => '当前内容有未保存的修改，是否保存？';

  void discardChanges(int index) {
    setState(() {
      expandedIndex = null;
      hasChanges[index] = false;
    });
  }

  void saveChanges(int index);

  void toggleExpanded(int index) {
    if (expandedIndex == index) {
      checkUnsavedChanges(index, () {
        setState(() {
          expandedIndex = null;
        });
      });
      return;
    }

    if (expandedIndex != null) {
      final previousIndex = expandedIndex!;
      checkUnsavedChanges(previousIndex, () {
        setState(() {
          expandedIndex = index;
        });
      });
      return;
    }

    setState(() {
      expandedIndex = index;
    });
  }

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

mixin UiPanelSingleEditMixin<T extends StatefulWidget> on State<T> {
  bool isExpanded = false;
  bool hasChanges = false;

  void checkUnsavedChanges(VoidCallback onConfirm) {
    if (hasChanges) {
      showUnsavedDialog(onConfirm);
      return;
    }
    onConfirm();
  }

  void showUnsavedDialog(VoidCallback onConfirm) {
    final theme = context.uiTheme;
    showDialog(
      context: context,
      builder: (dialogContext) => _UnsavedChangesDialog(
        theme: theme,
        message: getUnsavedMessage(),
        onDiscard: () {
          Navigator.of(dialogContext).pop();
          discardChanges();
          onConfirm();
        },
        onContinue: () => Navigator.of(dialogContext).pop(),
        onSave: () {
          Navigator.of(dialogContext).pop();
          saveChanges();
          onConfirm();
        },
      ),
    );
  }

  String getUnsavedMessage() => '当前内容有未保存的修改，是否保存？';

  void discardChanges() {
    setState(() {
      isExpanded = false;
      hasChanges = false;
    });
  }

  void saveChanges();

  void toggleExpanded() {
    if (isExpanded) {
      checkUnsavedChanges(() {
        setState(() {
          isExpanded = false;
        });
      });
      return;
    }

    setState(() {
      isExpanded = true;
    });
  }
}

class _UnsavedChangesDialog extends StatelessWidget {
  final UiThemeData theme;
  final String message;
  final VoidCallback onDiscard;
  final VoidCallback onContinue;
  final VoidCallback onSave;

  const _UnsavedChangesDialog({
    required this.theme,
    required this.message,
    required this.onDiscard,
    required this.onContinue,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return UiDialogShell(
      title: Text(
        '未保存的修改',
        style: TextStyle(
          color: theme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: UiDialogDescription(text: message, fontSize: 14),
      actions: [
        UiButton(
          label: '放弃修改',
          onPressed: onDiscard,
          variant: UiButtonVariant.secondary,
          size: UiButtonSize.small,
        ),
        UiButton(
          label: '继续编辑',
          onPressed: onContinue,
          variant: UiButtonVariant.ghost,
          size: UiButtonSize.small,
        ),
        UiButton(label: '保存', onPressed: onSave, size: UiButtonSize.small),
      ],
    );
  }
}
