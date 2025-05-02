import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/message/view/widgets/message_actions.dart';
import 'package:promts_application_1/features/message/view/widgets/text_bubble.dart';

class WidgetMessageBubble extends StatelessWidget {
  final MessageEntity message;
  const WidgetMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext c) {
    final isUser = message.role == 'USER';
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          TextBubble(message: message, isUser: isUser),
          const SizedBox(height: 2),
          Text(
            DateFormat('HH:mm, d.M.y').format(message.dateCreate),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          MessageActions(message: message),
        ],
      ),
    );
  }
}
