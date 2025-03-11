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
    ChatMessage(text: "Здравствуйте!", isUser: true),
    ChatMessage(text: "Привет, я бот!", isUser: false),
  ];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Отправка
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Добавляем сообщение пользователя
      _messages.add(ChatMessage(text: text, isUser: true));
      // Добавляем сообщения чата
      _messages.add(ChatMessage(text: "Это тестовое сообщение 1 фвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфвафвыфываыфваыфва", isUser: false));
    });
    _messageController.clear();
    // После построения нового сообщения, прокручиваем чат вниз
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // передаем контроллер
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
                    maxLines: 8,
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
      ),
    ),
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
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg.text),
      ),
    );
  }
}
