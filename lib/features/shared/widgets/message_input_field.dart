// lib/features/shared/widgets/message_input_field.dart
import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final int minLines;
  final int maxLines;
  final BoxConstraints constraints;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
    this.minLines = 1,
    this.maxLines = 8,
    this.constraints =
        const BoxConstraints(maxWidth: 900),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              keyboardType: TextInputType.multiline,
              minLines: minLines,
              maxLines: maxLines,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
            tooltip: "Отправить",
          ),
        ],
      ),
    );
  }
}
