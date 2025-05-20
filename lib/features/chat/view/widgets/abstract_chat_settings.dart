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

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.lightBlueAccent,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),

            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            if (widget.chatId != null)
              Row(
                children: [
                  const Text('ID чата: ',
                      style: TextStyle(color: Colors.white70)),
                  Text('${widget.chatId}',
                      style: const TextStyle(color: Colors.blueAccent)),
                  if (widget.showDate) ...[
                    const SizedBox(width: 16),
                    const Text('Создан: ',
                        style: TextStyle(color: Colors.white70)),
                    Text(widget.dateCreate ?? '-',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ],
              ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Температура:',
                    style: TextStyle(color: Colors.white)),
                DropdownButton<double>(
                  value: _temperature,
                  dropdownColor: Colors.black87,
                  style: const TextStyle(color: Colors.white),
                  items: _tempOptions
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.toString()),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _temperature = v!),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('Контекст:', style: TextStyle(color: Colors.white))),
            const SizedBox(height: 4),
            TextField(
              controller: _contextCtrl,
              style: const TextStyle(color: Colors.white),
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Переключатели
            _buildSwitchTile('Использовать память', _useMemory,
                (v) => setState(() => _useMemory = v)),
            _buildSwitchTile('Обновлять память', _updateMemory,
                (v) => setState(() => _updateMemory = v)),
            if (widget.showStar)
              _buildSwitchTile('Закрепить чат', _starred,
                  (v) => setState(() => _starred = v)),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Отмена',
                      style: TextStyle(color: Colors.white70)),
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
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(179, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Отмена'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.8),
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              shadowColor:
                                  const Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.2),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      await context
                          .read<ChatCubit>()
                          .deleteChat(widget.chatId!, context);
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _handleSave,
                        child: const Text('Сохранить'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
