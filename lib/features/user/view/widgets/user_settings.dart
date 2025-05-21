import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/user/view/widgets/exit_confirm.dart';

class UserSettings extends StatefulWidget {
  final UserEntity userEntity;
  final int selectedModelId;
  final List<NeuroModel> availableModels;
  final ValueChanged<Map<String, dynamic>> onSave;

  const UserSettings({
    super.key,
    required this.userEntity,
    required this.selectedModelId,
    required this.availableModels,
    required this.onSave,
  });

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late TextEditingController _memoryController;
  late bool _memoryEnabled;
  late bool _aiCanUpdateMemory;
  late int _selectedModelId;

  @override
  void initState() {
    super.initState();
    _initFromEntity(widget.userEntity);
  }

  void _logout() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    context.read<UserCubit>().emit(DataInitial<UserEntity>());
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    context.read<ChatCubit>().emit(DataInitial<List<ChatEntity>>());
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    context.read<NeuroCubit>().emit(DataInitial<List<NeuroEntity>>());
    context.read<MessageCubit>().removeMessages();

    context.read<AuthCubit>().logout();
  }

  void _initFromEntity(UserEntity user) {
    _memoryController = TextEditingController(text: user.memory);
    _memoryEnabled = user.memoryEnabled!;
    _aiCanUpdateMemory = user.aiCanUpdateMemory!;
    _selectedModelId = widget.selectedModelId;
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
    final userState = context.watch<UserCubit>().state;
    final user = userState is DataLoaded<UserEntity>
        ? userState.data
        : widget.userEntity;

    _memoryController.text = user.memory;

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.05),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Настройки пользователя",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    tooltip: 'Обновить',
                    onPressed: _refreshSettings,
                  )
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Прокручиваемая часть
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _infoRow("Эл. почта:", user.email),
                      _infoRow("ID:", user.id.toString()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Баланс:",
                              style: TextStyle(color: Colors.white70)),
                          Text("${user.money.toStringAsFixed(2)} руб.",
                              style: const TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white70),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSwitch(
                          "Использовать ли память в новых чатах?",
                          _memoryEnabled,
                          (val) => setState(() => _memoryEnabled = val)),
                      _buildSwitch(
                          "Могут ли новые чаты изменять память пользователя?",
                          _aiCanUpdateMemory,
                          (val) => setState(() => _aiCanUpdateMemory = val)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Модель чата:",
                              style: TextStyle(color: Colors.white70)),
                          DropdownButton<int>(
                            value: _selectedModelId,
                            dropdownColor: Colors.black87,
                            style: const TextStyle(color: Colors.white),
                            items: widget.availableModels.map((model) {
                              return DropdownMenuItem<int>(
                                value: model.id,
                                child: Text(model.name!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedModelId = val);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text("Память пользователя:",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _memoryController,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.06),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ExitConfirm(onExit: _logout),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Выйти"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.white54),
                    child: const Text("Отмена"),
                  ),
                  ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Сохранить"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(value,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.lightBlueAccent,
      contentPadding: EdgeInsets.zero,
    );
  }
}
