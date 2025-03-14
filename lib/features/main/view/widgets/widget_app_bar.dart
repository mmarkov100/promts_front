import 'package:flutter/material.dart';
import 'package:promts_application_1/features/user/view/widgets/widget_user_settings.dart';
import '../../../chatbot/view/widgets/widget_chat_bots.dart';

/// Класс, реализующий AppBar с одним колбэком для левого меню.
class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed; // для открытия левого Drawer

  const WidgetAppBar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Кнопка открытия NavigationDrawer (иконка "3 полоски")
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed,
          ),
          // Кнопка "Promts"
          TextButton(
            onPressed: () {
              // TODO: логика перехода на главный экран
            },
            child: const Text(
              "Promts",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          // Центр AppBar (название чата)
          const Expanded(
            child: Text(
              "Обычный чат-бот",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          // Кнопка настроек пользователя (иконка человечка)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => WidgetUserSettings(
                  email: "BoberKurwa@rambler.ru",
                  userId: 167491164,
                  balance: 191.61,
                  memoryEnabled: true,
                  aiCanUpdateMemory: true,
                  memory: "Имя пользователя Максим, из Перми (и т.д.)",
                  selectedModel: "DeepSeek V3",
                  availableModels: const [
                    "DeepSeek V3",
                    "DeepSeek R1",
                    "YandexGPT 5 Pro",
                    "YandexGPT 5 Lite",
                    "ChatGPT 4o mini",
                    "ChatGPT 4o",
                    "ChatGPT o1",
                    "Qwen-Max",
                    "Qwen-Turbo",
                  ],
                  onSave: (updatedData) {
                    // Здесь обрабатываем новые данные пользователя:
                    // updatedData['memory'], updatedData['memoryEnabled'], и т.д.
                    print("Новые настройки: $updatedData");
                    // TODO: отправить изменения на бэкенд
                  },
                ),
              );
            },
          ),
          // Кнопка открытия виджета чат-ботов
          IconButton(
            icon: const Icon(Icons.android),
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const Dialog(
                    child: SizedBox(
                      width: 600,
                      child: WidgetChatBots(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
