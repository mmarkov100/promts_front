import 'package:flutter/material.dart';

/// Модель сообщения
class ChatMessage {
  final String text;
  final bool isUser; // true: сообщение пользователя, false: сообщение нейросети

  ChatMessage({required this.text, required this.isUser});
}

class WidgetChatPage extends StatefulWidget {
  const WidgetChatPage({super.key});

  @override
  _WidgetChatPageState createState() => _WidgetChatPageState();
}

class _WidgetChatPageState extends State<WidgetChatPage> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Привет, я бот!", isUser: false),
    ChatMessage(text: "Здравствуйте!", isUser: true),
  ];
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Отправка нового сообщения от пользователя
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Добавляем сообщение пользователя
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _messageController.clear();

    // Здесь можно добавить логику для получения ответа от нейросети (isUser: false)
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Список сообщений
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _buildMessageBubble(msg);
            },
          ),
        ),
        // Поле ввода сообщения + кнопка отправки
        Container(
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
                  maxLines: 5,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Создаёт «пузырь» сообщения.
  /// Если сообщение пользователя (isUser = true), выравниваем его справа, иначе — слева.
  Widget _buildMessageBubble(ChatMessage msg) {
    final alignment = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = msg.isUser ? Colors.blue[100] : Colors.grey[300];

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg.text),
      ),
    );
  }
}
