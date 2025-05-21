import 'package:flutter/material.dart';
// Импортируем ваш файл с диалогом "Создание чат-бота"
// Убедитесь, что путь верный, например:

class WidgetChatBots extends StatefulWidget {
  const WidgetChatBots({super.key});

  @override
  State<WidgetChatBots> createState() => _WidgetChatBotsState();
}

class _WidgetChatBotsState extends State<WidgetChatBots> {
  // final TextEditingController _searchController = TextEditingController();

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
      "chatBotName": "Шеф-повар",
      "chatBotDesc": "Помогает с рецептами самых разных блюд.",
      "messagesToday": 11,
      "totalMessages": 114,
      "isSelectedByRedact": false
    },
    {
      "id": 4,
      "chatBotName": "Астролог",
      "chatBotDesc": "Поможет узнать гороскоп по вашему знаку задиака и не только.",
      "messagesToday": 124,
      "totalMessages": 1183,
      "isSelectedByRedact": true
    },
    {
      "id": 5,
      "chatBotName": "Советчик по путеществиям",
      "chatBotDesc": "Поможет узнать куда летают отдыхать люди в этом году.",
      "messagesToday": 192,
      "totalMessages": 1841,
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
  // void _searchChatBots() {
  //   final query = _searchController.text.trim().toLowerCase();
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredChatBots = List.from(_allChatBots);
  //     } else {
  //       _filteredChatBots = _allChatBots.where((bot) {
  //         final name = bot["chatBotName"]?.toString().toLowerCase() ?? "";
  //         return name.contains(query);
  //       }).toList();
  //     }
  //   });
  // }

  // /// Функция открытия окна "Создание чат-бота"
  // void _createChatBot() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // Открываем диалог "Создание чат-бота"
  //       return const WidgetCreateChatBots();
  //     },
  //   );
  // }

  /// Просмотр информации о чат-боте (иконка "!")
  void _showBotInfo(Map<String, dynamic> bot) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        final chatBotName = bot["chatBotName"] ?? "Без названия";
        final chatBotDesc = bot["chatBotDesc"] ?? "";
        final totalMessages = bot["totalMessages"] ?? 0;
        final messagesToday = bot["messagesToday"] ?? 0;
        final canUseMemory = bot["canUseMemory"] ?? false;
        final canUpdateMemory = bot["canUpdateMemory"] ?? false;
        final modelName = bot["modelUriName"] ?? "Yandex GPT 5 Pro";
        final dateCreate = bot["dateCreate"] ?? "3.03.2025";
        final contextChat = bot["context"] ?? "";

        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.9),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.85, // адаптация
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Характеристики чат-бота",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _infoField("Название:", chatBotName),
                      _infoField("Описание:", chatBotDesc, multiline: true),
                      _infoRow(
                          "Кол-во сообщений за всё время:", "$totalMessages"),
                      _infoRow("Кол-во сообщений за день:", "$messagesToday"),
                      _infoField("Контекст чата:", contextChat,
                          multiline: true),
                      _switchTile(
                          "Использовать ли память в чате?", canUseMemory),
                      _switchTile("Может ли чат изменять память пользователя?",
                          canUpdateMemory),
                      _infoRow("Исп-мая нейросеть:", modelName),
                      _infoRow("Дата создания:", dateCreate),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white60),
                            child: const Text("Отмена"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // логика перехода
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Начать общаться!"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Список чат-ботов",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredChatBots.length,
                itemBuilder: (context, index) {
                  final bot = _filteredChatBots[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bot["chatBotName"] ?? "Без названия",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bot["chatBotDesc"] ?? "Без описания",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Сегодня ${bot["messagesToday"] ?? 0} сообщений",
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.white70),
                          onPressed: () => _showBotInfo(bot),
                          tooltip: "Подробнее",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _infoField(String label, String value, {bool multiline = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          minLines: multiline ? 3 : 1,
          maxLines: multiline ? 5 : 1,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _switchTile(String label, bool value) {
  return SwitchListTile(
    value: value,
    onChanged: null,
    title: Text(label, style: const TextStyle(color: Colors.white)),
    activeColor: Colors.lightBlueAccent,
    contentPadding: EdgeInsets.zero,
  );
}
