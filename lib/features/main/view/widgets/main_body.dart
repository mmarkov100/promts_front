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
  final ValueChanged<String> openChatWithMessageWithText;
  final bool showChat;
  final bool isCreatingChat;
  const MainBody(
      {super.key,
      this.chatEntity,
      required this.openChatWithMessageWithText,
      required this.showChat,
      required this.isCreatingChat});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserCubit, DataState<UserEntity>>(
            builder: (context, userState) {
              UserEntity? user;
              if (userState is DataLoaded<UserEntity>) {
                user = userState.data;
              }
              return NeuroButton(
                currentChat: widget.chatEntity,
                currentUser: user,
              );
            },
          ),
        ),
        Expanded(
          child: widget.showChat
              ? ChatView(chatId: widget.chatEntity!.id)
              : HomeView(
                  isCreatingChat: widget.isCreatingChat,
                  openChatWithMessage: widget.openChatWithMessageWithText,
                ),
        ),
      ],
    );
  }
}
