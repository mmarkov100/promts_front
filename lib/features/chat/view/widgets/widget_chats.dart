import 'package:flutter/material.dart';

/// NavigationDrawer, который показывает список чатов пользователя.
class WidgetChats extends StatefulWidget {
  const WidgetChats({super.key});

  @override
  State<WidgetChats> createState() => _WidgetChatsState();
}

class _WidgetChatsState extends State<WidgetChats> {
  final TextEditingController _searchController = TextEditingController();

  // Список чатов для примера
  final List<String> _chats = [
    "Первый чат",
    "Второй чат",
    "Третий чат",
    "Четвёртый чат",
  ];

  // Результаты поиска
  List<String> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    // Изначально показываем все чаты
    _filteredChats = List.from(_chats);
  }

  // Логика поиска
  void _searchChats() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_chats);
      } else {
        _filteredChats = _chats.where((chat) {
          return chat.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Drawer по умолчанию «накрывает» экран, 
    // но ширину Drawer мы будем ограничивать в Scaffold (см. далее).
    return SafeArea(
      child: Column(
        children: [
          // Заголовок (необязательно)
          const ListTile(
            title: Text(
              "Мои чаты",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Строка поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Поле ввода
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Поиск чатов",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _searchChats();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Кнопка поиска
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchChats,
                ),
              ],
            ),
          ),

          // Список чатов
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChats.length,
              itemBuilder: (context, index) {
                final chatName = _filteredChats[index];
                return ListTile(
                  title: Text(chatName),
                  onTap: () {
                    // Закрываем Drawer
                    Navigator.of(context).pop();
                    // Доп. логика: переход к экрану чата
                    print("Открываем чат: $chatName");
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
