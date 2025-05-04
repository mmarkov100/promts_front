import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
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
    // MessageCubit уже есть выше в дереве, повторно не провайдим
    return _ChatViewBody(
      chat: chat,
      overrideModelId: overrideModelId,
    );
  }
}

/// Вынесено в отдельный виджет‑телефон, чтобы не плодить логику BlocProvider
class _ChatViewBody extends StatefulWidget {
  final ChatEntity chat; // новый
  final int? overrideModelId;
  const _ChatViewBody({required this.chat, required this.overrideModelId});

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<_ChatViewBody> {
  final _scroll = ScrollController();
  final _input = TextEditingController();
  bool _waiting = false;

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _handleSend() async {
    final txt = _input.text.trim();
    if (txt.isEmpty) return;

    final modelId = widget.overrideModelId ?? widget.chat.modelUriId;

    setState(() => _waiting = true); // ⬅️ показали индикатор
    await context.read<MessageCubit>().send(
          chatId: widget.chat.id,
          modelUriId: modelId,
          text: txt,
          context: context,
        );
    setState(() => _waiting = false); // ⬅️ скрыли индикатор

    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MessageCubit, DataState<List<MessageEntity>>>(
            builder: (context, state) {
              print(state.toString());
              if (state is DataLoading || state is DataInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DataError) {
                return const Center(
                    child: Text(
                        "Ошибка в загрузке сообщений, перезагрузите страницу"));
              }
              if (state is DataLoaded<List<MessageEntity>>) {
                final msgs = state.data;
                // автоскролл вниз
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scroll.jumpTo(_scroll.position.maxScrollExtent);
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
                } else {
                  return const Center(
                      child: Text("Напишите первое сообщение!"));
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        // Индикатор «Ассистент отвечает»
        if (_waiting)
          const Padding(
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
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            bottomInset + 56 + 8,
          ),
          child: MessageInputField(
            controller: _input,
            hintText: "Введите сообщение",
            onSend: _handleSend,
          ),
        ),
      ],
    );
  }
}
