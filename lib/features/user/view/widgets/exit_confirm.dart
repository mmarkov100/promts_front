import 'package:flutter/material.dart';

class ExitConfirm extends StatelessWidget {
  final VoidCallback onExit; // <‑‑ новый параметр
  const ExitConfirm({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Подтверждение выхода"),
      content: const SizedBox(
        width: 300,
        height: 150,
        child: Center(
          child: Text(
            'Вы точно хотите выйти из аккаунта?',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отменить'),
        ),
        ElevatedButton(
          onPressed: () {
            onExit(); // вызов коллбэка
            Navigator.of(context).pop(); // закрываем диалог
          },
          child: const Text('Выйти'),
        ),
      ],
    );
  }
}
