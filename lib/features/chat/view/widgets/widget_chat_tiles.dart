import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';

class WidgetChatTiles extends StatefulWidget {
  final String query;
  const WidgetChatTiles(
      {super.key, required this.query});

  @override
  State<WidgetChatTiles> createState() => _WidgetChatTilesState();
}

class _WidgetChatTilesState extends State<WidgetChatTiles> {
  
  void _selectChat(ChatEntity chat) {
    Navigator.of(context).pop();
    context.read<MessageCubit>().fetch(chat.id);
    context.go('/chat/${chat.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatCubit, DataState<List<ChatEntity>>>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataError) {
            return const Center(child: Text('Ошибка в загрузке чатов'));
          } else if (state is DataLoaded<List<ChatEntity>>) {
            return chatDataLoaded(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget chatDataLoaded(DataLoaded<List<ChatEntity>> state) {
    {
      final sorted = [...state.data]..sort((a, b) {
          if (a.starredChat && !b.starredChat) return -1;
          if (!a.starredChat && b.starredChat) return 1;
          return b.dateEdit.compareTo(a.dateEdit);
        });

      final filtered = widget.query.isEmpty
          ? sorted
          : sorted
              .where(
                  (chat) => chat.chatName.toLowerCase().contains(widget.query))
              .toList();

      if (filtered.isEmpty) {
        return const Center(child: Text('Чатов не найдено'));
      }

      return ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (ctx, idx) {
          final chat = filtered[idx];
          return ListTile(
            leading: chat.starredChat
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.chat_bubble_outline),
            title: Text(chat.chatName),
            onTap: () => _selectChat(chat),
          );
        },
      );
    }
  }
}
