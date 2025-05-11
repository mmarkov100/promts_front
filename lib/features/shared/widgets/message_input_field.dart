// lib/features/shared/widgets/message_input_field.dart
import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final int minLines;
  final int maxLines;
  final BoxConstraints constraints;
  final bool enabled;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
    this.minLines = 1,
    this.maxLines = 8,
    this.constraints = const BoxConstraints(maxWidth: 900),
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 196, 194, 194),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: minLines,
              maxLines: maxLines,
            ),
          ),
          const SizedBox(width: 8),
          if (enabled)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSend,
              tooltip: "Отправить",
            ),
          if (!enabled)
            const IconButton(
              icon: Icon(Icons.send),
              onPressed: null,
              tooltip: "Отправить",
            ),
        ],
      ),
    );
  }
}
