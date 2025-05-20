import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/message/view/widgets/code_block_builder.dart';

class TextBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isUser;

  const TextBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      constraints: const BoxConstraints(maxWidth: 550),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: MarkdownBody(
        data: message.text,
        selectable: true,
        builders: {
          'pre': CodeBlockBuilder(),
        },
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
          code: const TextStyle(
            backgroundColor: Colors.transparent,
            color: Colors.lightGreenAccent,
          ),
        ),
        sizedImageBuilder: (config) => Image.network(config.uri.toString()),
      ),
    );
  }
}
