import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final VoidCallback sendMessage;
  const ChatInputField({
    super.key,
    required TextEditingController messageController,
    required this.sendMessage,
  }) : _messageController = messageController;

  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Введите сообщение",
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 8,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
