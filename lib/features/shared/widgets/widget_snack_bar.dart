import 'package:flutter/material.dart';
import 'package:promts_application_1/features/shared/widgets/memory_update_sheet.dart';

class WidgetSnackBar {
  static void showError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String successMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showMemoryChange({
    required BuildContext context,
    required String oldMemory,
    required String newMemory,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Память пользователя обновлена'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Подробнее',
          onPressed: () => _openMemorySheet(context, oldMemory, newMemory),
        ),
      ),
    );
  }

  static void _openMemorySheet(BuildContext ctx, String oldMem, String newMem) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) => MemoryUpdateSheet(
        oldMemory: oldMem,
        newMemory: newMem,
      ),
    );
  }
}
