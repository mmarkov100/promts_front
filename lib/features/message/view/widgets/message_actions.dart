import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';

class MessageActions extends StatefulWidget {
  final MessageEntity message;
  const MessageActions({super.key, required this.message});

  @override
  State<MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends State<MessageActions> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(
        ClipboardData(text: widget.message.text));
    setState(() => _copied = true);

    WidgetSnackBar.showSuccess(context, "Успешно скопировано");

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кнопка копирования (всегда)
        IconButton(
          icon: const Icon(Icons.copy),
          iconSize: 16,
          onPressed: _copied ? null : _handleCopy,
        ),
        // Кнопка перегенерации (только для сообщений чат-бота)
        if (!(widget.message.role == "USER"))
          IconButton(
            icon: const Icon(Icons.autorenew), // "зацикленная стрелка"
            iconSize: 16,
            onPressed: () {
              // Пока без реализации
            },
          ),
        // Кнопка удаления (только для сообщений пользователя)
        if (widget.message.role == "USER")
          IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 16,
            onPressed: () {
              // Пока без реализации
            },
          ),
      ],
    );
  }
}
