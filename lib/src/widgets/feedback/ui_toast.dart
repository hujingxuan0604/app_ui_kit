import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class UiToast {
  const UiToast._();

  static void success(String message) {
    _show(message, ToastificationType.success, Icons.check_circle_rounded);
  }

  static void error(String message) {
    _show(message, ToastificationType.error, Icons.error_rounded);
  }

  static void warning(String message) {
    _show(message, ToastificationType.warning, Icons.warning_rounded);
  }

  static void info(String message) {
    _show(message, ToastificationType.info, Icons.info_rounded);
  }

  static void _show(String message, ToastificationType type, IconData icon) {
    toastification.dismissAll();
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: false,
      icon: Icon(icon, size: 18),
      title: Text(message),
    );
  }
}
