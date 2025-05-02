import 'package:flutter/material.dart';

class HomeInputField extends StatelessWidget {
  final VoidCallback handleSend;
  const HomeInputField({
    super.key,
    required TextEditingController messageController, required this.handleSend,
  }) : _messageController = messageController;

  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: "Введите сообщение",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: handleSend,
            tooltip: "Отправить",
          ),
        ],
      ),
    );
  }
}
