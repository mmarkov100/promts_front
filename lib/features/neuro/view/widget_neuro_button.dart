import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_create_settings.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/view/widget_neuro_chat_setting.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class WidgetNeuroButton extends StatefulWidget {
  final ChatEntity? currentChat;
  final UserEntity? currentUser;
  const WidgetNeuroButton({super.key, this.currentChat, this.currentUser});

  @override
  State<WidgetNeuroButton> createState() => _WidgetNeuroButtonState();
}

class _WidgetNeuroButtonState extends State<WidgetNeuroButton> {
  NeuroEntity? _selectedNeuro;
  NeuroEntity? _standardNeuro;
  bool _changedNeuro = false;
  bool _userLoaded = false;
  List<NeuroEntity> neuroList = [];

  @override
  void didUpdateWidget(covariant WidgetNeuroButton old) {
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

  // Открытие диалога настроек чата
  void _openSettingsDialog() {
    if (widget.currentChat != null) {
      final c = widget.currentChat!;
      showDialog(
        context: context,
        builder: (_) => WidgetNeuroChatSetting(
          chatId: c.id,
          temperature: c.temperature,
          contextChat: c.context,
          useMemory: c.useMemory,
          updateMemory: c.updateMemory,
          dateCreate: c.dateCreate.toString(),
          starredChat: c.starredChat,
          onSave: (data) {
            // TODO: здесь пока просто логируем/обновляем локально
            print("Новые настройки чата: \$data");
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => WidgetChatCreateSettings(
          chatId: 0,
          temperature: 1.0,
          contextChat: '',
          useMemory: false,
          updateMemory: false,
          onSave: (data) {
            // TODO: тут запрос на создание нового чата
            print("Создать чат с настройками: \$data");
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallWidth = MediaQuery.of(context).size.width < 350;

    return BlocBuilder<NeuroCubit, DataState<List<NeuroEntity>>>(
      builder: (context, neuroState) {
        if (neuroState is DataLoading<List<NeuroEntity>>) {
          return buildShowingMessage(
              isSmallWidth, "Идет загрузка..", "Пожалуйста подождите", true);
        } else if (neuroState is DataLoaded<List<NeuroEntity>>) {
          neuroList = neuroState.data;
          if (neuroList.isEmpty) {
            return buildShowingMessage(
                isSmallWidth, "Список нейросетей пуст", "Делать нечего)", true);
          }
          return BlocBuilder<UserCubit, DataState<UserEntity>>(
              builder: (context, userState) {
            if (userState is DataLoading<UserEntity> && !_userLoaded) {
              return buildShowingMessage(isSmallWidth, "Идет загрузка..",
                  "Пожалуйста подождите", true);
            }
            if (userState is DataError<UserEntity>) {
              return buildShowingMessage(isSmallWidth, "Ошибка в загрузке",
                  "Пожалуйста обновите страницу", false);
            }
            if (userState is DataLoaded<UserEntity> && !_userLoaded) {
              // инициализация из профиля
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
                                    neuro.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                          onChanged: (neuro) {
                            if (neuro != null) {
                              setState(() {
                                _changedNeuro = true;
                                _selectedNeuro = neuro;
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
            }
            return Container();
          });
        } else if (neuroState is DataError<List<NeuroEntity>>) {
          return buildShowingMessage(isSmallWidth, "Ошибка в загрузке",
              "Пожалуйста обновите страницу", false);
        }
        return Container();
      },
    );
  }

  Widget buildShowingMessage(
      bool isSmallWidth, String titleText, String desc, bool isLoading) {
    return Row(
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375, minHeight: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название нейросети
                Text(
                  titleText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 7),
      ],
    );
  }
}
