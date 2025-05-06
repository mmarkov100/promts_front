import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/message/view/widgets/message_actions.dart';
import 'package:promts_application_1/features/message/view/widgets/text_bubble.dart';

class WidgetMessageBubble extends StatelessWidget {
  final MessageEntity message;
  const WidgetMessageBubble({super.key, required this.message});

  static final _fmt = DateFormat('HH:mm, d.M.y');

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Container(
      key: ValueKey(message.id),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          TextBubble(message: message, isUser: isUser),
          const SizedBox(height: 2),
          Text(
            _fmt.format(message.dateCreate),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          MessageActions(message: message),
        ],
      ),
    );
  }
}
