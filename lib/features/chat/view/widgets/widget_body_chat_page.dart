import 'package:flutter/material.dart';
import 'package:promts_application_1/features/chat/view/widgets/chat_input_field.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/message/view/widgets/widget_message_bubble.dart';

class WidgetChatPage extends StatefulWidget {
  final int? chatId;
  const WidgetChatPage({super.key, this.chatId});

  @override
  // ignore: library_private_types_in_public_api
  _WidgetChatPageState createState() => _WidgetChatPageState();
}

class _WidgetChatPageState extends State<WidgetChatPage> {
  final List<MessageEntity> _messages = [
    MessageEntity(
      id: 1,
      chatId: 1,
      modelUriId: 1,
      oldMessage: false,
      role: 'USER',
      text: 'Здравствуйте!',
      type: 'MESSAGE',
      dateCreate: DateTime.now(),
    ),
    MessageEntity(
      id: 2,
      chatId: 1,
      modelUriId: 1,
      oldMessage: false,
      role: 'bot',
      text: 'Привет, я бот!',
      type: 'ASSISTANT',
      dateCreate: DateTime.now(),
    ),
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
      _messages.add(MessageEntity(
        id: _messages.length + 1,
        chatId: 1,
        modelUriId: 1,
        oldMessage: false,
        role: 'USER',
        text: text,
        type: 'MESSAGE',
        dateCreate: DateTime.now(),
      ));
      _messages.add(MessageEntity(
        id: _messages.length + 1,
        chatId: 1,
        modelUriId: 1,
        oldMessage: false,
        role: 'ASSISTANT',
        text: """
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

А чтобы добавить изображение, используйте такой формат:

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
""",
        type: 'MESSAGE',
        dateCreate: DateTime.now(),
      ));
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
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return WidgetMessageBubble(message: message);
                },
              ),
            ),
            ChatInputField(
              messageController: _messageController,
              sendMessage: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
