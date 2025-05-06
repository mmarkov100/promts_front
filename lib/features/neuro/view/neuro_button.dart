import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/view/widgets/chat_create_settings.dart';
import 'package:promts_application_1/features/chat/view/widgets/chat_settings.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/view/neuro_empty_message.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class NeuroButton extends StatefulWidget {
  final ChatEntity? currentChat;
  final UserEntity? currentUser;
  final ValueChanged<Map<String, dynamic>> onChatCreateSettings;
  const NeuroButton(
      {super.key,
      this.currentChat,
      this.currentUser,
      required this.onChatCreateSettings});

  @override
  State<NeuroButton> createState() => _NeuroButtonState();
}

class _NeuroButtonState extends State<NeuroButton> {
  NeuroEntity? _selectedNeuro;
  NeuroEntity? _standardNeuro;
  String _chatCreateContext = "";
  late bool _chatCreateUseMemory = widget.currentUser!.memoryEnabled!;
  late bool _chatUpdateMemory = widget.currentUser!.aiCanUpdateMemory!;
  double _chatCreateTemperature = 1;
  bool _changedNeuro = false;
  bool _userLoaded = false;
  List<NeuroEntity> neuroList = [];

  @override
  void didUpdateWidget(covariant NeuroButton old) {
    super.didUpdateWidget(old);
    if (widget.currentChat?.id != old.currentChat?.id) {
      setState(() {
        _changedNeuro = false;
        final id = widget.currentChat?.modelUriId ??
            widget.currentUser?.standartModelUriId;
        _selectedNeuro =
            neuroList.firstWhereOrNull((e) => e.id == id) ?? _standardNeuro;
      });
    }
  }

  void _openSettingsDialog() {
    if (widget.currentChat != null) {
      final c = widget.currentChat!;
      showDialog(
          context: context,
          builder: (_) => ChatSettings(
                chatId: c.id,
                dateCreate: c.dateCreate.toString(),
                initialStarred: c.starredChat,
                initialTemperature: c.temperature,
                initialContext: c.context,
                initialUseMemory: c.useMemory,
                initialUpdateMemory: c.updateMemory,
                initialModelId: _selectedNeuro?.id,
                onSave: (data) async {
                  await context.read<ChatCubit>().saveSettings(data);

                  if (data['modelUriId'] != null) {
                    widget.onChatCreateSettings(
                        {'modelUriId': data['modelUriId']});
                    setState(() {
                      _changedNeuro = true;
                      _selectedNeuro = neuroList
                          .firstWhere((e) => e.id == data['modelUriId']);
                    });
                  }
                },
              ));
    } else {
      // Показываем чат, который будет создан. Он создается, когда отправляется первое сообщение, поэтому не надо сохранять настройки на этом этапе
      showDialog(
          context: context,
          builder: (_) => ChatCreateSettings(
                initialUseMemory: _chatCreateUseMemory,
                initialUpdateMemory: _chatUpdateMemory,
                initialContext: _chatCreateContext,
                initialTemperature: _chatCreateTemperature,
                onSave: (data) async {
                  setState(() {
                    _chatCreateUseMemory = data["useMemory"];
                    _chatUpdateMemory = data["updateMemory"];
                    _chatCreateContext = data["context"];
                    _chatCreateTemperature = data["temperature"];
                  });
                  widget.onChatCreateSettings(data);
                },
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallWidth = MediaQuery.of(context).size.width < 350;
    _standardNeuro = neuroList.firstWhereOrNull(
            (e) => e.id == widget.currentUser?.standartModelUriId) ??
        _standardNeuro;

    return BlocBuilder<NeuroCubit, DataState<List<NeuroEntity>>>(
      builder: (context, neuroState) {
        if (neuroState is DataLoading<List<NeuroEntity>>) {
          return NeuroEmptyMessage(
              isSmallWidth: isSmallWidth,
              titleText: "Идет загрузка..",
              desc: "Пожалуйста подождите",
              isLoading: true);
        } else if (neuroState is DataLoaded<List<NeuroEntity>>) {
          neuroList = neuroState.data;
          if (neuroList.isEmpty) {
            return NeuroEmptyMessage(
                isSmallWidth: isSmallWidth,
                titleText: "Список нейросетей пуст",
                desc: "Делать нечего)",
                isLoading: true);
          }
          return BlocBuilder<UserCubit, DataState<UserEntity>>(
              builder: (context, userState) {
            if (userState is DataLoading<UserEntity> && !_userLoaded) {
              return NeuroEmptyMessage(
                  isSmallWidth: isSmallWidth,
                  titleText: "Идет загрузка..",
                  desc: "Пожалуйста подождите",
                  isLoading: true);
            }
            if (userState is DataError<UserEntity>) {
              return NeuroEmptyMessage(
                  isSmallWidth: isSmallWidth,
                  titleText: "Ошибка в загрузке",
                  desc: "Пожалуйста обновите страницу",
                  isLoading: false);
            }
            if (userState is DataLoaded<UserEntity> && !_userLoaded) {
              _standardNeuro = neuroList.firstWhereOrNull(
                  (e) => e.id == userState.data.standartModelUriId);
              _selectedNeuro = _standardNeuro;
              _userLoaded = true;
            }

            if (_userLoaded) {
              if (!_changedNeuro) {
                if (widget.currentChat == null) {
                  _selectedNeuro = _standardNeuro;
                } else {
                  final chatId = widget.currentChat!.modelUriId;
                  _selectedNeuro =
                      neuroList.firstWhereOrNull((e) => e.id == chatId) ??
                          _standardNeuro;
                  if (userState is DataLoaded<UserEntity>) {
                    _standardNeuro = neuroList.firstWhereOrNull(
                        (e) => e.id == userState.data.standartModelUriId);
                  }
                }
              }
              return Row(
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 375, minHeight: 50),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<NeuroEntity>(
                          isExpanded: true,
                          value: _selectedNeuro,
                          hint: const Text(
                              "Выберите нейросеть"), // вот эта строка
                          items: neuroList.map((neuro) {
                            return DropdownMenuItem<NeuroEntity>(
                              value: neuro,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Название нейросети
                                  Text(
                                    neuro.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Описание (если есть)
                                  if (neuro.desc!.isNotEmpty)
                                    Text(
                                      neuro.desc!,
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
                          onChanged: (neuro) {
                            if (neuro != null) {
                              setState(() {
                                _changedNeuro = true;
                                _selectedNeuro = neuro;
                              });
                              widget.onChatCreateSettings(
                                  {'modelUriId': neuro.id});
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
            }
            return Container();
          });
        } else if (neuroState is DataError<List<NeuroEntity>>) {
          return NeuroEmptyMessage(
              isSmallWidth: isSmallWidth,
              titleText: "Ошибка в загрузке",
              desc: "Пожалуйста обновите страницу",
              isLoading: false);
        }
        return Container();
      },
    );
  }
}
