import 'package:flutter/material.dart';

/// Виджет чат-ботов (endDrawer), в котором есть:
///  - Кнопка создания чат-бота (слева),
///  - Строка поиска и кнопка поиска,
///  - Список чат-ботов, каждый элемент имеет иконку "!" для просмотра инфо.
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

  /// Создание нового чат-бота (пока просто пример)
  void _createChatBot() {
    // Закрываем Drawer
    Navigator.of(context).pop();
    // TODO: здесь логика для экрана создания чат-бота
    print("Открыть экран создания нового чат-бота");
  }

  /// Просмотр информации о чат-боте (иконка "!")
  void _showBotInfo(Map<String, dynamic> bot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(bot["chatBotName"] ?? "Чат-бот"),
        content: Text(bot["chatBotDesc"] ?? "Без описания"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Закрыть"),
          ),
        ],
      ),
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
                // (5.3) Кнопка создания своего чат-бота (слева)
                ElevatedButton(
                  onPressed: _createChatBot,
                  child: const Text("Создать чат-бота"),
                ),
                const SizedBox(width: 8),
                // (5.1) Строка поиска чатов по названию
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
                // (5.1.1) Кнопка поиска
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchChatBots,
                ),
              ],
            ),
          ),
          // (5.2) Список чат-ботов
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChatBots.length,
              itemBuilder: (context, index) {
                final bot = _filteredChatBots[index];
                return ListTile(
                  title: Text(bot["chatBotName"] ?? "Без названия"),
                  subtitle: Text(bot["chatBotDesc"] ?? "Без описания"),
                  // (5.2.1) Кнопка для просмотра информации о чат-боте (иконка "!")
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showBotInfo(bot),
                  ),
                  onTap: () {
                    // Закрываем Drawer
                    Navigator.of(context).pop();
                    // TODO: логика открытия/использования выбранного чат-бота
                    print("Выбран чат-бот: ${bot["chatBotName"]}");
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
