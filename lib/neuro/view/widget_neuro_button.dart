import 'package:flutter/material.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_create_settings.dart';
/// Виджет выбора нейросети (DropdownButton) + кнопка настроек чата.
/// Максимальная ширина выпадающего списка ограничена 375 px.
class WidgetNeuroButton extends StatefulWidget {
  const WidgetNeuroButton({super.key});

  @override
  State<WidgetNeuroButton> createState() => _WidgetNeuroButtonState();
}

class _WidgetNeuroButtonState extends State<WidgetNeuroButton> {
  // По умолчанию выбранная нейросеть
  String _selectedNetwork = "DeepSeek V3";

  // Список доступных нейросетей с описаниями
  final List<Map<String, String>> _networks = [
    {
      'name': 'DeepSeek V3',
      'desc': 'Мощная модель для генерации текста.',
    },
    {
      'name': 'DeepSeek R1',
      'desc': 'Улучшенная модель DeepSeek.',
    },
    {
      'name': 'YandexGPT 5 pro',
      'desc': 'Самая продвинутая русская модель.',
    },
    {
      'name': 'YandexGPT 5 Lite',
      'desc': 'Упрощённая версия YandexGPT 5.',
    },
    {
      'name': 'ChatGPT 4o mini',
      'desc': 'Лёгкая версия ChatGPT 4o.',
    },
    {
      'name': 'ChatGPT 4o',
      'desc': 'Полноценная версия ChatGPT 4o.',
    },
    {
      'name': 'ChatGPT o1',
      'desc': 'Экспериментальная модель ChatGPT.',
    },
    {
      'name': 'Qwen-Max',
      'desc': 'Расширенная версия Qwen.',
    },
    {
      'name': 'Qwen-Turbo',
      'desc': 'Ускоренная версия Qwen.',
    },
  ];

  // Обрабатываем выбор новой нейросети
  void _onNetworkChanged(String newNetwork) {
    setState(() {
      _selectedNetwork = newNetwork;
    });
  }

  // Открываем окно настроек по центру экрана (пример с AlertDialog)
void _openSettingsDialog() {
  showDialog(
    context: context,
    builder: (_) => WidgetChatCreateSettings(
      chatId: 54719041,
      temperature: 1.0,
      contextChat: "Описание...",
      useMemory: true,
      updateMemory: false,
      onSave: (updatedData) {
        // Здесь обработка новых данных чата
        // updatedData['temperature'], updatedData['contextChat'], и т.д.
        print("Новые настройки чата: $updatedData");
        // TODO: отправить изменения на бэкенд
      },
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    // Проверяем, является ли устройство "очень узким" (для уменьшения шрифта описания, при желании)
    final isSmallWidth = MediaQuery.of(context).size.width < 350;

    return Row(
      children: [
        // Flexible, чтобы не «выталкивать» другие элементы
        Flexible(
          // ConstrainedBox ограничивает ширину в 375 пикселей максимум
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true, // Растягиваем до доступной ширины (но не более 375)
                value: _selectedNetwork,
                items: _networks.map((net) {
                  return DropdownMenuItem<String>(
                    value: net['name'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название нейросети
                        Text(
                          net['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Описание нейросети (ограничиваем 2 строками)
                        if (net['desc'] != null && net['desc']!.isNotEmpty)
                          Text(
                            net['desc']!,
                            style: TextStyle(
                              fontSize: isSmallWidth ? 10 : 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _onNetworkChanged(value);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Кнопка настроек (иконка шестерёнка)
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openSettingsDialog,
        ),
      ],
    );
  }
}
