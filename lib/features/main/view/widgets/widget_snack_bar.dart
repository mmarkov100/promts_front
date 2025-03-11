import 'package:flutter/material.dart';

class WidgetSnackBar {
  /// Показывает SnackBar с текстом ошибки [errorMessage].
  /// Цвет фона — красный, длительность — 3 секунды.
  static void showError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
