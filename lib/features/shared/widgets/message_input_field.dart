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
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
              ),
              keyboardType: TextInputType.text,
              minLines: minLines,
              maxLines: maxLines,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send,
                color: enabled
                    ? const Color.fromARGB(255, 212, 212, 212)
                    : Colors.white24),
            onPressed: enabled ? onSend : null,
            tooltip: "Отправить",
          ),
        ],
      ),
    );
  }
}
