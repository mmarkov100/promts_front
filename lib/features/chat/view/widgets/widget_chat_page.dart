import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_message.dart';

class WidgetChatPage extends StatefulWidget {
  const WidgetChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messages.add(ChatMessage(text: """
Вот пример кода на Dart, в котором содержится длинный текст с Markdown-разметкой:

```dart
final String markdownText = '''
# Заголовок первого уровня

Добро пожаловать в пример Markdown-разметки, который можно использовать прямо в коде. Markdown позволяет легко форматировать текст, добавлять ссылки, изображения, таблицы, код и многое другое.

## Заголовок второго уровня

### Основные возможности Markdown

Markdown поддерживает следующие элементы:

- **Выделенный текст**: можно использовать **жирный** или *курсив* для выделения текста.
- **Списки**:
  - Ненумерованные списки с использованием дефисов или звездочек.
  - Вложенные списки, как показано ниже:
    - Подэлемент 1
    - Подэлемент 2
- **Нумерованные списки**:
  1. Первый пункт
  2. Второй пункт
  3. Третий пункт

### Цитаты и разделители

> Это пример блока цитаты. Он используется для выделения цитируемых отрывков или важных сообщений.
>
> Можно добавить несколько строк в цитату.

---

### Код и программирование

Вы можете вставлять фрагменты кода как в строчку, используя обратные кавычки, например: `print("Hello, World!");`

А для форматирования целых блоков кода используйте тройные обратные кавычки:

```dart
// Пример кода на Dart
void main() {
  print("Привет, мир!");
}
```

### Ссылки и изображения

Для создания ссылок используйте следующий синтаксис:

[Официальный сайт Dart](https://dart.dev)

А чтобы добавить изображение, используйте такой формат:

![Пример изображения](https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1)

### Таблицы

Markdown позволяет создавать таблицы:

| Название    | Описание                | Пример       |
| ----------- | ----------------------- | ------------ |
| Элемент 1   | Первое значение         | Пример 1     |
| Элемент 2   | Второе значение         | Пример 2     |
| Элемент 3   | Третье значение         | Пример 3     |

### Дополнительный текст

Markdown — это простой и удобный способ создания форматированного текста. Он широко используется для:
- Документации к проектам
- README файлов на GitHub
- Веб-блогов и статей
- Форумов и систем комментариев

Надеюсь, этот пример поможет вам понять, как использовать Markdown-разметку прямо в коде!
''';
```

Теперь вы можете вставить этот код в ваше приложение и использовать переменную `markdownText` для дальнейшей обработки или отображения.
""", isUser: false));
    });

    _messageController.clear();
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

  Widget _buildMessageBubble(ChatMessage msg) {

    final alignment = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = msg.isUser ? Colors.blue[100] : Colors.grey[300];

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
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
                  data: msg.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                  imageBuilder: (uri, title, alt) {
                    return Image.network(uri.toString());
                  },
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
