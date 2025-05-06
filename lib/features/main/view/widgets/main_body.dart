import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/view/widgets/chat_view.dart';
import 'package:promts_application_1/features/main/view/widgets/home_view.dart';
import 'package:promts_application_1/features/neuro/view/neuro_button.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class MainBody extends StatefulWidget {
  final ChatEntity? chatEntity;
  final int? chatId;
  final ValueChanged<String> openChatWithMessageWithText;
  final ValueChanged<Map<String, dynamic>> onChatCreateSettings;
  final bool showChat;
  final bool isCreatingChat;
  const MainBody({
    super.key,
    this.chatEntity,
    required this.openChatWithMessageWithText,
    required this.showChat,
    required this.isCreatingChat,
    this.chatId,
    required this.onChatCreateSettings,
  });

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  int? _overrideModelId;

  @override
  void didUpdateWidget(covariant MainBody old) {
    super.didUpdateWidget(old);
    // При переходе в другой чат сбрасываем переопределение
    if (widget.chatId != old.chatId) _overrideModelId = null;
  }

  // Сюда попадают данные из NeuroButton и/или настроек создаваемого чата
  void _handleDraft(Map<String, dynamic> data) {
    if (data.containsKey('modelUriId')) {
      setState(() => _overrideModelId = data['modelUriId'] as int?);
    }
    // Чтобы сохранить прежнее поведение, прокидываем наружу
    widget.onChatCreateSettings(data);
  }

  @override
  Widget build(BuildContext context) {
    final hasChat = widget.chatEntity != null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserCubit, DataState<UserEntity>>(
            builder: (context, userState) {
              UserEntity? user;
              if (userState is DataLoaded<UserEntity>) user = userState.data;

              return NeuroButton(
                currentChat: widget.chatEntity,
                currentUser: user,
                onChatCreateSettings: _handleDraft,
              );
            },
          ),
        ),
        Expanded(
          child: hasChat
              ? ChatView(
                  chat: widget.chatEntity!,
                  chatId: widget.chatId!,
                  overrideModelId: _overrideModelId,
                )
              : widget.showChat
                  ? const Center(child: CircularProgressIndicator())
                  : HomeView(
                      isCreatingChat: widget.isCreatingChat,
                      openChatWithMessage: widget.openChatWithMessageWithText,
                    ),
        ),
      ],
    );
  }
}
