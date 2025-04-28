import 'package:flutter/material.dart';

/// Диалоговое окно «Создание чат-бота»
class WidgetCreateChatBots extends StatefulWidget {
  const WidgetCreateChatBots({super.key});

  @override
  State<WidgetCreateChatBots> createState() => _WidgetCreateChatBotsState();
}

class _WidgetCreateChatBotsState extends State<WidgetCreateChatBots> {
  // Поля для ввода (название, описание, контекст)
  final TextEditingController _botNameController = TextEditingController();
  final TextEditingController _botDescController = TextEditingController();
  final TextEditingController _botContextController = TextEditingController();

  // Температура (dropdown)
  double _temperature = 1.0;
  final List<double> _tempValues = [0.0, 0.5, 1.0, 1.5, 2.0];

  // Используемая нейросеть (dropdown)
  String _selectedNetwork = "Yandex GPT 5 pro";
  final List<String> _availableNetworks = [
    "DeepSeek V3",
    "DeepSeek R1",
    "Yandex GPT 5 pro",
    "Yandex GPT 5 Lite",
    "ChatGPT 4o mini",
    "ChatGPT 4o",
    "ChatGPT o1",
    "Qwen-Max",
    "Qwen-Turbo",
  ];

  // Флаги (Switch) для различных настроек
  bool _canEditModel = true; // Можно ли изменять модель чата?
  bool _canEditContext = true; // Можно ли менять контекст чата?
  bool _canUseMemory = false; // Может ли чат использовать память?
  bool _canUpdateMemory = false; // Может ли чат обновлять память пользователя?

  @override
  void dispose() {
    _botNameController.dispose();
    _botDescController.dispose();
    _botContextController.dispose();
    super.dispose();
  }

  /// Нажатие на кнопку «Создать»
  void _handleCreate() {
    // final newBotData = {
    //   "botName": _botNameController.text.trim(),
    //   "botDesc": _botDescController.text.trim(),
    //   "temperature": _temperature,
    //   "modelUriName": _selectedNetwork,
    //   "canEditModel": _canEditModel,
    //   "context": _botContextController.text.trim(),
    //   "canEditContext": _canEditContext,
    //   "canUseMemory": _canUseMemory,
    //   "canUpdateMemory": _canUpdateMemory,
    // };

    // Закрываем диалог
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Создание чат-бота"),
      content: SizedBox(
        width: 400, // Зафиксированная ширина окна

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Название чат-бота
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Название чат-бота:"),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _botNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Описание чат-бота
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Описание чат-бота:"),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _botDescController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Температура
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Температура чата:"),
                DropdownButton<double>(
                  value: _temperature,
                  items: _tempValues.map((temp) {
                    return DropdownMenuItem<double>(
                      value: temp,
                      child: Text(temp.toString()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _temperature = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Используемая нейросеть
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Используемая нейросеть:"),
                DropdownButton<String>(
                  value: _selectedNetwork,
                  items: _availableNetworks.map((net) {
                    return DropdownMenuItem<String>(
                      value: net,
                      child: Text(net),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedNetwork = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Можно ли изменять модель чата?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Можно ли изменять модель чата?"),
                Switch(
                  value: _canEditModel,
                  onChanged: (val) {
                    setState(() {
                      _canEditModel = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Контекст чата
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Контекст чата:"),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _botContextController,
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

            // Можно ли менять контекст чата?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Можно ли менять контекст чата?"),
                Switch(
                  value: _canEditContext,
                  onChanged: (val) {
                    setState(() {
                      _canEditContext = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Может ли чат использовать память?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Может ли чат использовать память?"),
                Switch(
                  value: _canUseMemory,
                  onChanged: (val) {
                    setState(() {
                      _canUseMemory = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Может ли чат обновлять память?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Может ли чат обновлять память пользователя?"),
                Switch(
                  value: _canUpdateMemory,
                  onChanged: (val) {
                    setState(() {
                      _canUpdateMemory = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: _handleCreate,
          child: const Text("Создать"),
        ),
      ],
    );
  }
}
