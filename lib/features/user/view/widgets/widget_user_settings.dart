import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/user/view/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/view/cubit/user_state.dart';

class WidgetUserSettings extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSave;

  const WidgetUserSettings({
    super.key,
    required this.onSave,
  });

  @override
  State<WidgetUserSettings> createState() => _WidgetUserSettingsState();
}

class _WidgetUserSettingsState extends State<WidgetUserSettings> {
  bool isButtonEnable = false;
  late TextEditingController _memoryController;

  @override
  void initState() {
    super.initState();
    _memoryController = TextEditingController();
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }

  void _handleSave() {
    Navigator.of(context).pop();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Настройки пользователя"),
      content: SizedBox(
        width: 400,
        height: 400,
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserError) {
              return Center(child: Text("Ошибка: ${state.message}"));
            } else if (state is UserLoaded) {
              final user = state.user;
              final networks = state.networks;
              // Обновляем контроллер памяти, если данные пришли с бэкенда
              _memoryController.text = user.memory;
              isButtonEnable = true;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Эл. почта
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Эл. почта:"),
                      Flexible(child: Text(user.email)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 2) ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ID:"),
                      Text(user.id.toString()),
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
                          Text("${user.money.toStringAsFixed(2)} руб."),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                // Например, локальное увеличение баланса
                                // _balance += 10.0;
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
                      const Expanded(
                          child: Text("Использовать ли память в чатах?")),
                      Switch(
                        value: user.memoryEnabled,
                        onChanged: (val) {
                          setState(() {
                            // _memoryEnabled = val;
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
                          child: Text(
                              "Могут ли чаты изменять память пользователя?")),
                      Switch(
                        value: user.aiCanUpdateMemory,
                        onChanged: (val) {
                          setState(() {
                            // _aiCanUpdateMemory = val;
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
                      DropdownButton<String>(
                        value: networks[user.standardModelUriId].name,
                        items: networks.map((model) {
                          return DropdownMenuItem<String>(
                            value: model.name,
                            child: Text(model.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              // _selectedModel = networks.firstWhere((el) => el.name == val).name;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 7) Поле "Память"
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
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: isButtonEnable ? _handleSave : null,
          child: const Text("Сохранить"),
        ),
      ],
    );
  }
}
