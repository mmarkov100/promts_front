import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';

/// Абстрактный диалог настроек чата:
/// – собирает одинаковые поля (температура, контекст, переключатели),
/// – рендерит title и действия.
/// – дочерний класс задает, что показывать (звездочку, дату, id нейросети).
abstract class AbstractChatSettingsDialog extends StatefulWidget {
  final String title;
  final int? chatId;
  final String? dateCreate; // null для Create-dialog
  final bool initialStarred;
  final int? initialModelId;
  final double initialTemperature;
  final String initialContext;
  final bool initialUseMemory;
  final bool initialUpdateMemory;
  final bool showStar;
  final bool showDate;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const AbstractChatSettingsDialog({
    super.key,
    required this.title,
    this.chatId,
    this.dateCreate,
    this.initialStarred = false,
    this.initialModelId,
    required this.initialTemperature,
    required this.initialContext,
    required this.initialUseMemory,
    required this.initialUpdateMemory,
    required this.showStar,
    required this.showDate,
    required this.onSave,
  });

  @override
  State<AbstractChatSettingsDialog> createState() =>
      _AbstractChatSettingsDialogState();
}

class _AbstractChatSettingsDialogState
    extends State<AbstractChatSettingsDialog> {
  late double _temperature;
  late int? _modelId;
  late List<double> _tempOptions;
  late TextEditingController _contextCtrl;
  late bool _useMemory;
  late bool _updateMemory;
  late bool _starred;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _temperature = widget.initialTemperature;
    _modelId = widget.initialModelId;
    _contextCtrl = TextEditingController(text: widget.initialContext);
    _useMemory = widget.initialUseMemory;
    _updateMemory = widget.initialUpdateMemory;
    _starred = widget.initialStarred;

    // предопределённые опции температуры + текущее значение
    _tempOptions = [0.0, 0.5, 1.0, 1.5, 2.0];
    if (!_tempOptions.contains(_temperature)) {
      _tempOptions.add(_temperature);
      _tempOptions.sort();
    }
  }

  @override
  void dispose() {
    _contextCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final data = <String, dynamic>{
      'chatId': widget.chatId,
      'modelUriId': _modelId,
      'temperature': _temperature,
      'context': _contextCtrl.text,
      'useMemory': _useMemory,
      'updateMemory': _updateMemory,
      'starredChat': _starred,
    };
    if (widget.showStar) data['starredChat'] = _starred;
    try {
      await widget.onSave(data);
      if (mounted) {
        Navigator.of(context).pop();
      }
      if (widget.chatId != null) {
        // ignore: use_build_context_synchronously
        WidgetSnackBar.showSuccess(context, 'Настройки сохранены');
      }
    } catch (e) {
      setState(() => _isSaving = false);
      // ignore: use_build_context_synchronously
      WidgetSnackBar.showError(context, 'Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // [ID чата и (опционально) дата создания]
              if (widget.chatId != null)
                Row(
                  children: [
                    const Text('ID чата: '),
                    Text(widget.chatId.toString(),
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    if (widget.showDate) ...[
                      const SizedBox(width: 16),
                      const Text('Создан: '),
                      Text(widget.dateCreate ?? '-',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              const SizedBox(height: 12),

              // Температура
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Температура:'),
                  DropdownButton<double>(
                    value: _temperature,
                    items: _tempOptions
                        .map((t) => DropdownMenuItem(
                            value: t, child: Text(t.toString())))
                        .toList(),
                    onChanged: (v) => setState(() => _temperature = v!),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Контекст
              const Align(
                  alignment: Alignment.centerLeft, child: Text('Контекст:')),
              TextField(
                controller: _contextCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                minLines: 3,
                maxLines: 6,
              ),
              const SizedBox(height: 12),

              // Switch-поля
              SwitchListTile(
                title: const Text('Использовать память'),
                value: _useMemory,
                onChanged: (v) => setState(() => _useMemory = v),
              ),
              SwitchListTile(
                title: const Text('Обновлять память'),
                value: _updateMemory,
                onChanged: (v) => setState(() => _updateMemory = v),
              ),

              // Звездочка
              if (widget.showStar)
                SwitchListTile(
                  title: const Text('Закрепить чат'),
                  value: _starred,
                  onChanged: (v) => setState(() => _starred = v),
                ),

              // здесь можно DropdownButton<NeuroEntity> c cubit-ом, пример пропускаем
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Удалить чат?'),
                content: const Text(
                    'История сообщений будет безвозвратно потеряна. Продолжить?'),
                actions: [
                  TextButton(
                    child: const Text('Отмена'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ElevatedButton(
                    child: const Text('Удалить', style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );

            if (ok == true) {
              await context.read<ChatCubit>().deleteChat(widget.chatId!, context);
              if (context.mounted) context.go('/chat');
            }
          },
          child: const Text('Удалить'),
        ),
        _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Сохранить'),
              ),
      ],
    );
  }
}
