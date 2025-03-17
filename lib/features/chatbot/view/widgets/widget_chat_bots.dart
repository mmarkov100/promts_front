import 'package:flutter/material.dart';
// Импортируем ваш файл с диалогом "Создание чат-бота"
// Убедитесь, что путь верный, например:
import 'package:promts_application_1/features/chatbot/view/widgets/widget_create_chat_bots.dart';

class WidgetChatBots extends StatefulWidget {
  const WidgetChatBots({super.key});

  @override
  State<WidgetChatBots> createState() => _WidgetChatBotsState();
}

class _WidgetChatBotsState extends State<WidgetChatBots> {
  final TextEditingController _searchController = TextEditingController();

  /// Пример данных о чат-ботах (в реальном приложении вы можете получать их с бэкенда).
  final List<Map<String, dynamic>> _allChatBots = [
    {
      "id": 1,
      "chatBotName": "Помощник по программированию",
      "chatBotDesc": "Помогает с вопросами по Python, Java и другим языкам.",
      "messagesToday": 123,
      "totalMessages": 1000,
      "isSelectedByRedact": true
    },
    {
      "id": 2,
      "chatBotName": "Финансовый советник",
      "chatBotDesc": "Помогает с вопросами по инвестициям и бюджету.",
      "messagesToday": 87,
      "totalMessages": 500,
      "isSelectedByRedact": false
    },
    {
      "id": 3,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
            {
      "id": 4,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 5,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 6,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 7,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 8,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 9,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 10,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 11,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 12,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
        {
      "id": 13,
      "chatBotName": "Новый помощник",
      "chatBotDesc": "Описание нового помощника.",
      "messagesToday": 0,
      "totalMessages": 0,
      "isSelectedByRedact": false
    },
  ];

  /// Список отфильтрованных чат-ботов (поиск).
  List<Map<String, dynamic>> _filteredChatBots = [];

  @override
  void initState() {
    super.initState();
    // Изначально показываем всех чат-ботов
    _filteredChatBots = List.from(_allChatBots);
  }

  /// Логика поиска чат-ботов
  void _searchChatBots() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChatBots = List.from(_allChatBots);
      } else {
        _filteredChatBots = _allChatBots.where((bot) {
          final name = bot["chatBotName"]?.toString().toLowerCase() ?? "";
          return name.contains(query);
        }).toList();
      }
    });
  }

  /// Функция открытия окна "Создание чат-бота"
  void _createChatBot() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Открываем диалог "Создание чат-бота"
        return const WidgetCreateChatBots();
      },
    );
  }

  /// Просмотр информации о чат-боте (иконка "!")
void _showBotInfo(Map<String, dynamic> bot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Извлекаем данные из `bot`
      final chatBotName = bot["chatBotName"] ?? "Без названия";
      final chatBotDesc = bot["chatBotDesc"] ?? "";
      final totalMessages = bot["totalMessages"] ?? 0;
      final messagesToday = bot["messagesToday"] ?? 0;
      final canUseMemory = bot["canUseMemory"] ?? false;
      final canUpdateMemory = bot["canUpdateMemory"] ?? false;
      const modelName = "Yandex GPT 5 Pro"; 
      // ^ Или если в bot есть поле bot["modelUriName"], используйте его
      const dateCreate = "3.03.2025"; 
      // ^ Замените на реальное поле, если есть bot["dateCreate"], 
      //   иначе можно оставить статическое

      final contextChat = bot["context"] ?? ""; 
      // ^ Если в bot хранится контекст под другим ключом, подставьте его.

      return AlertDialog(
        title: const Text("Характеристики чат-бота"),
        content: SizedBox(
          width:400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Название
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Название:"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: chatBotName),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Описание
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Описание:"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: chatBotDesc),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      minLines: 3,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Кол-во сообщений за все время
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Кол-во сообщений за все время:"),
                  Text("$totalMessages"),
                ],
              ),
              const SizedBox(height: 6),

              // Кол-во сообщений за день
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Кол-во сообщений за день:"),
                  Text("$messagesToday"),
                ],
              ),
              const SizedBox(height: 10),

              // Контекст чата (текст)
              const Text("Контекст чата:"),
              const SizedBox(height: 6),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: contextChat),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 3,
              ),
              const SizedBox(height: 8),

              // Использовать ли память (Switch, read-only)
              Row(
                children: [
                  const Expanded(child: Text("Использовать ли память в чате?")),
                  Switch(
                    value: canUseMemory,
                    onChanged: null, // null => Switch недоступен для изменения
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Может ли чат изменять память (Switch, read-only)
              Row(
                children: [
                  const Expanded(child: Text("Может ли чат изменять память пользователя?")),
                  Switch(
                    value: canUpdateMemory,
                    onChanged: null,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Используемая нейросеть
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Исп-мая нейросеть:"),
                  Text(modelName),
                ],
              ),
              const SizedBox(height: 10),

              // Дата создания
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Дата создания:"),
                  Text(dateCreate),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () {
              // Логика "Начать общаться!"
              Navigator.of(context).pop();
              // Например, можно создать чат по этому боту или перейти на экран чата
            },
            child: const Text("Начать общаться!"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Заголовок (необязательно)
          const ListTile(
            title: Text(
              "Список чат-ботов",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Строка поиска + кнопка создания чат-бота + кнопка поиска
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Кнопка создания своего чат-бота (слева)
                ElevatedButton(
                  onPressed: _createChatBot,
                  child: const Text("+"),
                ),
                const SizedBox(width: 8),
                // Строка поиска чатов по названию
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Поиск чат-ботов",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _searchChatBots(),
                  ),
                ),
                const SizedBox(width: 8),
                // Кнопка поиска
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchChatBots,
                ),
              ],
            ),
          ),
          // Список чат-ботов
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChatBots.length,
              itemBuilder: (context, index) {
                final bot = _filteredChatBots[index];
                return ListTile(
                  title: Text(bot["chatBotName"] ?? "Без названия"),
                  subtitle: Text(
                    (bot["chatBotDesc"] ?? "Без описания") +
                        "\nСегодня ${bot["messagesToday"]} сообщений",
                  ),
                  // Кнопка для просмотра информации о чат-боте (иконка "!")
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showBotInfo(bot),
                  ),
                  onTap: () {
                    // Закрываем Drawer
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
