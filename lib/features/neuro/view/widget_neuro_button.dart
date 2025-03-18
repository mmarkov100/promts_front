import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_state.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_create_settings.dart';

class WidgetNeuroButton extends StatefulWidget {
  const WidgetNeuroButton({super.key});

  @override
  State<WidgetNeuroButton> createState() => _WidgetNeuroButtonState();
}

class _WidgetNeuroButtonState extends State<WidgetNeuroButton> {
  String? _selectedNetwork;

  // Открытие диалога настроек чата
  void _openSettingsDialog() {
    showDialog(
      context: context,
      builder: (_) => WidgetChatCreateSettings(
        chatId: 54719041,
        temperature: 1.0,
        contextChat: "Описание...",
        useMemory: true,
        updateMemory: false,
        onSave: (updatedData) {
          // Обработка сохранения настроек
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallWidth = MediaQuery.of(context).size.width < 350;

    return BlocBuilder<NeuroCubit, NeuroState>(
      builder: (context, state) {
        if (state is NeuroLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NeuroLoaded) {
          final neuroList = state.neuroList;
          if (neuroList.isEmpty) {
            return const Text('Список нейросетей пуст');
          }
          // Если ещё не выбрана нейросеть, выбираем первую
          _selectedNetwork ??= neuroList.first.name;
          return Row(
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 375),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedNetwork,
                      items: neuroList.map((neuro) {
                        return DropdownMenuItem<String>(
                          value: neuro.name,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Название нейросети
                              Text(
                                neuro.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Описание (если есть)
                              if (neuro.desc.isNotEmpty)
                                Text(
                                  neuro.desc,
                                  style: TextStyle(
                                    fontSize: isSmallWidth ? 10 : 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedNetwork = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Кнопка настроек
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _openSettingsDialog,
              ),
            ],
          );
        } else if (state is NeuroError) {
          return Center(child: Text("Ошибка: ${state.message}"));
        }
        return Container();
      },
    );
  }
}
