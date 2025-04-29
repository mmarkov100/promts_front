import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class WidgetUserSettings extends StatefulWidget {
  final UserEntity userEntity;
  final int selectedModelId;
  final List<NeuroModel> availableModels;
  final ValueChanged<Map<String, dynamic>> onSave;

  const WidgetUserSettings({
    super.key,
    required this.userEntity,
    required this.selectedModelId,
    required this.availableModels,
    required this.onSave,
  });

  @override
  State<WidgetUserSettings> createState() => _WidgetUserSettingsState();
}

class _WidgetUserSettingsState extends State<WidgetUserSettings> {
  late TextEditingController _memoryController;
  late bool _memoryEnabled;
  late bool _aiCanUpdateMemory;
  late int _selectedModelId;
  late double _balance;

  @override
  void initState() {
    super.initState();
    _initFromEntity(widget.userEntity);
  }

  void _initFromEntity(UserEntity user) {
    _memoryController = TextEditingController(text: user.memory);
    _memoryEnabled = user.memoryEnabled;
    _aiCanUpdateMemory = user.aiCanUpdateMemory;
    _selectedModelId = widget.selectedModelId;
    _balance = user.money;
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }

  void _refreshSettings() {
    context.read<UserCubit>().fetch();
  }

  void _handleSave() async {
    final updatedData = {
      'memory': _memoryController.text,
      'memoryEnabled': _memoryEnabled,
      'aiCanUpdateMemory': _aiCanUpdateMemory,
      'standardModelUriId': _selectedModelId,
    };

    context.read<UserCubit>().updateSettings(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text("Настройки пользователя"),
          const Spacer(),
          IconButton(
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSettings,
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Почта
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Эл. почта:"),
                Flexible(child: Text(widget.userEntity.email)),
              ],
            ),
            const SizedBox(height: 8),

            // 2) ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ID:"),
                Text(widget.userEntity.id.toString()),
              ],
            ),
            const SizedBox(height: 8),

            // 3) Баланс + кнопка "+"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Баланс:"),
                Row(
                  children: [
                    Text("${_balance.toStringAsFixed(2)} руб."),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _balance += 10.0;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 4) Использовать ли память?
            Row(
              children: [
                const Expanded(child: Text("Использовать ли память в новых чатах?")),
                Switch(
                  value: _memoryEnabled,
                  onChanged: (val) {
                    setState(() {
                      _memoryEnabled = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 5) Могут ли чаты изменять память?
            Row(
              children: [
                const Expanded(
                    child: Text("Могут ли новые чаты изменять память пользователя?")),
                Switch(
                  value: _aiCanUpdateMemory,
                  onChanged: (val) {
                    setState(() {
                      _aiCanUpdateMemory = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 6) Модель по умолчанию (Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Модель чата:"),
                DropdownButton<int>(
                  // текущее выбранное значение — это id
                  value: _selectedModelId,
                  items: widget.availableModels.map((model) {
                    return DropdownMenuItem<int>(
                      value: model.id, // id модели
                      child: Text(model.name), // имя, которое показываем
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedModelId = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 7) Поле "Память" - чтобы окно не растягивалось, используем Expanded + внутренний скролл
            Expanded(
              child: TextField(
                controller: _memoryController,
                decoration: const InputDecoration(
                  labelText: "Память пользователя",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
              ),
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
