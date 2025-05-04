import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';
import 'package:promts_application_1/features/message/view/widgets/widget_message_bubble.dart';
import 'package:promts_application_1/features/shared/widgets/message_input_field.dart';

class ChatView extends StatelessWidget {
  final int chatId;
  const ChatView({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (_) => context.read<MessageCubit>(),
      child: const _ChatViewBody(),
    );
  }
}

/// Вынесено в отдельный виджет‑телефон, чтобы не плодить логику BlocProvider
class _ChatViewBody extends StatefulWidget {
  const _ChatViewBody();

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<_ChatViewBody> {
  final _scroll = ScrollController();
  final _input = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MessageCubit, DataState<List<MessageEntity>>>(
            builder: (context, state) {
              if (state is DataLoading) {
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
                return ListView.builder(
                  controller: _scroll,
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => WidgetMessageBubble(message: msgs[i]),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        MessageInputField(
          controller: _input,
          hintText: "Введите сообщение",
          onSend: () {},
        ),
      ],
    );
  }
}
