import 'package:flutter/material.dart';

class WidgetNeuroChatSetting extends StatefulWidget {
  final int chatId;               // ID чата
  final double temperature;       // Температура чата
  final String contextChat;       // Контекст чата
  final bool useMemory;           // Использовать ли память в чате?
  final bool updateMemory;        // Может ли чат изменять память пользователя?
  final String dateCreate;        // Дата создания (строкой)
  final bool starredChat;         // Закреплён ли чат
  final ValueChanged<Map<String, dynamic>> onSave; // Колбэк при сохранении

  const WidgetNeuroChatSetting({
    super.key,
    required this.chatId,
    required this.temperature,
    required this.contextChat,
    required this.useMemory,
    required this.updateMemory,
    required this.dateCreate,
    required this.starredChat,
    required this.onSave,
  });

  @override
  State<WidgetNeuroChatSetting> createState() => _WidgetNeuroChatSettingState();
}

class _WidgetNeuroChatSettingState extends State<WidgetNeuroChatSetting> {
  late double _temperature;
  late TextEditingController _contextController;
  late bool _useMemory;
  late bool _updateMemory;
  late bool _starredChat;

  @override
  void initState() {
    super.initState();
    _temperature = widget.temperature;
    _contextController = TextEditingController(text: widget.contextChat);
    _useMemory = widget.useMemory;
    _updateMemory = widget.updateMemory;
    _starredChat = widget.starredChat;
  }

  @override
  void dispose() {
    _contextController.dispose();
    super.dispose();
  }

  /// Нажатие на кнопку "Сохранить"
  void _handleSave() {
    final updatedData = {
      'chatId': widget.chatId,
      'temperature': _temperature,
      'contextChat': _contextController.text,
      'useMemory': _useMemory,
      'updateMemory': _updateMemory,
      'dateCreate': widget.dateCreate,
      'starredChat': _starredChat,
    };
    widget.onSave(updatedData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Настройки чата"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ID чата
            Row(
              children: [
                const Text("ID чата: "),
                Text(
                  widget.chatId.toString(),
                  style: const TextStyle(color: Colors.blue),
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

            // Контекст чата
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Контекст чата:"),
            ),
            TextField(
              controller: _contextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 8),

            // Использовать ли память в чате?
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

            // Может ли чат изменять память?
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
            const SizedBox(height: 8),

            // Дата создания (read-only)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Дата создания:"),
                Text(widget.dateCreate),
              ],
            ),
            const SizedBox(height: 8),

            // Закрепить чат?
            Row(
              children: [
                const Expanded(child: Text("Закрепить чат?")),
                Switch(
                  value: _starredChat,
                  onChanged: (val) {
                    setState(() {
                      _starredChat = val;
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
