import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/message/cubits/message_state.dart';
import 'package:promts_application_1/features/message/view/widgets/widget_message_bubble.dart';
import 'package:promts_application_1/features/shared/widgets/message_input_field.dart';

class ChatView extends StatelessWidget {
  final int chatId;
  final ChatEntity chat;
  final int? overrideModelId;
  const ChatView(
      {super.key,
      required this.chatId,
      required this.chat,
      this.overrideModelId});

  @override
  Widget build(BuildContext context) {
    return _ChatViewBody(
      chat: chat,
      overrideModelId: overrideModelId,
    );
  }
}

class _ChatViewBody extends StatefulWidget {
  final ChatEntity chat;
  final int? overrideModelId;
  const _ChatViewBody({required this.chat, required this.overrideModelId});

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<_ChatViewBody> {
  final _scroll = ScrollController();
  final _input = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _handleSend() {
    final txt = _input.text.trim();
    if (txt.isEmpty) return;

    final modelId = widget.overrideModelId ?? widget.chat.modelUriId;

    context.read<MessageCubit>().send(
          chatId: widget.chat.id,
          modelUriId: modelId,
          text: txt,
          context: context,
        );
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
                print("ChatView BlocBuilder state: $state");
                if (state is MessageLoadingHistory || state is MessageInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MessageError) {
                  return Center(
                      child: Text(
                          "Ошибка в загрузке сообщений: ${state.message}, перезагрузите страницу"));
                }
                if (state is MessageLoaded) {
                  final msgs = state.messages;
      
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scroll.hasClients) {
                      _scroll.jumpTo(_scroll.position.maxScrollExtent);
                    }
                  });
      
                  if (msgs.isNotEmpty) {
                    return SizedBox(
                      width: 1000,
                      child: ListView.builder(
                        controller: _scroll,
                        itemCount: msgs.length,
                        itemBuilder: (_, i) =>
                            WidgetMessageBubble(message: msgs[i]),
                      ),
                    );
                  } else if (!state.isGenerating) {
                    return const Center(
                        child: Text("Напишите первое сообщение!"));
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              bool isCurrentlyGenerating = false;
              if (state is MessageLoaded) {
                isCurrentlyGenerating = state.isGenerating;
              }
              if (isCurrentlyGenerating) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Ассистент печатает…'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              0,
              bottomInset + 56 + 8,
            ),
            child: BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
                bool inputFieldEnabled = true;
                if (state is MessageLoaded) {
                  inputFieldEnabled = !state.isGenerating;
                } else if (state is MessageLoadingHistory ||
                    state is MessageInitial) {
                  inputFieldEnabled = false;
                }
      
                return MessageInputField(
                  controller: _input,
                  hintText: "Введите сообщение",
                  onSend: _handleSend,
                  enabled: inputFieldEnabled,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
