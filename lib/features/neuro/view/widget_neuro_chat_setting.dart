import 'package:flutter/material.dart';

class WidgetNeuroChatSetting extends StatefulWidget {
  final int chatId; // ID чата
  final double temperature; // Температура чата
  final String contextChat; // Контекст чата
  final bool useMemory; // Использовать ли память в чате?
  final bool updateMemory; // Может ли чат изменять память?
  final String dateCreate; // Дата создания
  final bool starredChat; // Закреплён ли чат
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
  late List<double> _tempOptions; // <-- добавили
  late TextEditingController _contextController;
  late bool _useMemory;
  late bool _updateMemory;
  late bool _starredChat;

  @override
  void initState() {
    super.initState();
    _temperature = widget.temperature;

    // Собираем базовый список и добавляем в него текущее значение, если его там нет
    _tempOptions = [0.0, 0.5, 1.0, 1.5, 2.0];
    if (!_tempOptions.contains(_temperature)) {
      _tempOptions.add(_temperature);
      _tempOptions.sort();
    }

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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // ID
          Row(children: [
            const Text("ID чата: "),
            Text(widget.chatId.toString(),
                style: const TextStyle(color: Colors.blue)),
          ]),
          const SizedBox(height: 8),

          // Температура
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Температура чата:"),
              DropdownButton<double>(
                value: _temperature,
                items: _tempOptions.map((t) {
                  return DropdownMenuItem<double>(
                    value: t,
                    child: Text(t.toString()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _temperature = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Контекст
          const Align(
              alignment: Alignment.centerLeft, child: Text("Контекст чата:")),
          TextField(
            controller: _contextController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 8),

          // Использовать память?
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Использовать память?"),
            Switch(
                value: _useMemory,
                onChanged: (v) => setState(() => _useMemory = v)),
          ]),
          const SizedBox(height: 8),

          // Обновлять память?
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Обновлять память?"),
            Switch(
                value: _updateMemory,
                onChanged: (v) => setState(() => _updateMemory = v)),
          ]),
          const SizedBox(height: 8),

          // Закреплён ли чат?
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Закрепить чат?"),
            Switch(
                value: _starredChat,
                onChanged: (v) => setState(() => _starredChat = v)),
          ]),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отмена")),
        ElevatedButton(onPressed: _handleSave, child: const Text("Сохранить")),
      ],
    );
  }
}
