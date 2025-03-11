import 'package:flutter/material.dart';

class WidgetChatCreateSettings extends StatefulWidget {
  final int chatId;              // ID чата
  final double temperature;      // Температура чата
  final String contextChat;      // Контекст (правила) чата
  final bool useMemory;          // Использовать ли память в чате?
  final bool updateMemory;       // Может ли чат изменять память пользователя?

  /// Колбэк, который вызывается при нажатии "Сохранить".
  /// Возвращает все обновлённые данные (в виде Map) в onSave().
  final ValueChanged<Map<String, dynamic>> onSave;

  const WidgetChatCreateSettings({
    super.key,
    required this.chatId,
    required this.temperature,
    required this.contextChat,
    required this.useMemory,
    required this.updateMemory,
    required this.onSave,
  });

  @override
  State<WidgetChatCreateSettings> createState() => _WidgetChatCreateSettingsState();
}

class _WidgetChatCreateSettingsState extends State<WidgetChatCreateSettings> {
  late double _temperature;
  late TextEditingController _contextController;
  late bool _useMemory;
  late bool _updateMemory;

  @override
  void initState() {
    super.initState();
    _temperature = widget.temperature;
    _contextController = TextEditingController(text: widget.contextChat);
    _useMemory = widget.useMemory;
    _updateMemory = widget.updateMemory;
  }

  @override
  void dispose() {
    _contextController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Собираем данные, которые надо сохранить
    final updatedData = {
      'chatId': widget.chatId,
      'temperature': _temperature,
      'contextChat': _contextController.text,
      'useMemory': _useMemory,
      'updateMemory': _updateMemory,
    };
    // Вызываем колбэк, передавая обновлённые данные
    widget.onSave(updatedData);
    // Закрываем диалог
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Создание чата"),
      content: SizedBox(
        width: 400,   // Зафиксированная ширина окна
        height: 350,  // Зафиксированная высота окна
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // (1) ID чата
            Row(
              children: [
                const Text("ID чата: "),
                Text(widget.chatId.toString()),
              ],
            ),
            const SizedBox(height: 8),

            // (2) Температура чата (пример с DropdownButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Температура чата:"),
                DropdownButton<double>(
                  value: _temperature,
                  items: [0.0, 0.5, 1.0, 1.5, 2.0].map((temp) {
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
            const SizedBox(height: 8),

            // (3) Контекст чата (многострочное поле)
            
            TextField(
              controller: _contextController,
              decoration: const InputDecoration(
                labelText: "Контекст чата",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(height: 8),

            // (4) Использовать ли память в данном чате?
            Row(
              children: [
                const Expanded(child: Text("Использовать ли память в чате?")),
                Switch(
                  value: _useMemory,
                  onChanged: (val) {
                    setState(() {
                      _useMemory = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // (5) Может ли чат изменять память?
            Row(
              children: [
                const Expanded(child: Text("Может ли чат изменять память пользователя?")),
                Switch(
                  value: _updateMemory,
                  onChanged: (val) {
                    setState(() {
                      _updateMemory = val;
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
          onPressed: _handleSave,
          child: const Text("Сохранить"),
        ),
      ],
    );
  }
}
