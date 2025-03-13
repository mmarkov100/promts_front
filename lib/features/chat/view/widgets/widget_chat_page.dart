import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Пример модели сообщения
class ChatMessage {
  final String text; // Текст сообщения (с Markdown)
  final bool isUser; // true: сообщение от пользователя, false: от чат-бота

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class WidgetChatPage extends StatefulWidget {
  const WidgetChatPage({Key? key}) : super(key: key);

  @override
  _WidgetChatPageState createState() => _WidgetChatPageState();
}

class _WidgetChatPageState extends State<WidgetChatPage> {

  /// Пример списка сообщений (можно подгрузить с бэкенда)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  /// Сообщение (bubble) + кнопки под сообщением
  Widget _buildMessageBubble(ChatMessage msg) {
    // Определяем, как выравнивать контейнер
    final alignment = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
    // Цвет фона сообщения
    final bgColor = msg.isUser ? Colors.blue[100] : Colors.grey[300];

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Само "облако" сообщения
          Container(
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Показываем markdown
                MarkdownBody(
                  data: msg.text,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                ),
              ],
            ),
          ),
          // Время
          const SizedBox(height: 2),
          const Text(
            "14:04, 2.3.2025",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          // Кнопки под сообщением
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Кнопка копирования (всегда)
              IconButton(
                icon: const Icon(Icons.copy),
                iconSize: 16,
                onPressed: () {
                  // Пока без реализации
                },
              ),
              // Кнопка перегенерации (только для сообщений чат-бота)
              if (!msg.isUser)
                IconButton(
                  icon: const Icon(Icons.autorenew), // "зацикленная стрелка"
                  iconSize: 16,
                  onPressed: () {
                    // Пока без реализации
                  },
                ),
              // Кнопка удаления (только для сообщений пользователя)
              if (msg.isUser)
                IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 16,
                  onPressed: () {
                    // Пока без реализации
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
