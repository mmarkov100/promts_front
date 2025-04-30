import 'package:flutter/material.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_snack_bar.dart';

class WidgetChatSettings extends StatefulWidget {
  final int chatId; // ID чата
  final double temperature; // Температура чата
  final String contextChat; // Контекст чата
  final bool useMemory; // Использовать ли память в чате?
  final bool updateMemory; // Может ли чат изменять память?
  final String dateCreate; // Дата создания
  final bool starredChat; // Закреплён ли чат
  final Future<void> Function(Map<String, dynamic>) onSave;
  final int? usedNeuroId;
  final bool canEditContext;
  final bool canUseMemory;
  final bool canUpdateMemory;
  final bool canEditModelUri;

  const WidgetChatSettings({
    super.key,
    required this.chatId,
    required this.temperature,
    required this.contextChat,
    required this.useMemory,
    required this.updateMemory,
    required this.dateCreate,
    required this.starredChat,
    required this.onSave,
    required this.canEditContext,
    required this.canUseMemory,
    required this.canUpdateMemory,
    required this.usedNeuroId,
    required this.canEditModelUri,
  });

  @override
  State<WidgetChatSettings> createState() => _WidgetChatSettingsState();
}

class _WidgetChatSettingsState extends State<WidgetChatSettings> {
  late double _temperature;
  late List<double> _tempOptions;
  late TextEditingController _contextController;
  late bool _useMemory;
  late bool _updateMemory;
  late bool _starredChat;
  bool _isSaving = false;

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

  Future<void> _handleSave() async {
    final updatedData = {
      'chatId': widget.chatId,
      'modelUriId': widget.usedNeuroId,
      'temperature': _temperature,
      'context': _contextController.text,
      'useMemory': _useMemory,
      'updateMemory': _updateMemory,
      'starredChat': _starredChat,
    };

    setState(() => _isSaving = true); // показываем loader

    try {
      await widget.onSave(updatedData); // ждём запрос
      if (mounted) Navigator.of(context).pop(); // закрываем окно
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Настройки сохранены')),
      );
    } catch (e) {
      setState(() => _isSaving = false); // вернём кнопку
      WidgetSnackBar.showError(context, 'Ошибка: $e');
    }
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
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          _isSaving
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              : ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('Сохранить'),
                ),
        ]);
  }
}
