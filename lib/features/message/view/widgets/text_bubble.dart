import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';

class TextBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isUser;

  const TextBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bgColor = isUser ? Colors.blue[100] : Colors.grey[300];

    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 550),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: message.text,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            sizedImageBuilder: (config) {
              return Image.network(config.uri.toString());
            },
          ),
        ],
      ),
    );
  }
}
