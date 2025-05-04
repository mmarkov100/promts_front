import 'package:flutter/material.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';

class MessageActions extends StatefulWidget {
  final MessageEntity message;
  const MessageActions({super.key, required this.message});

  @override
  State<MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends State<MessageActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кнопка копирования (всегда)
        IconButton(
          icon: const Icon(Icons.copy),
          iconSize: 16,
          onPressed: () {
            // Пока без реализации
          },
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
