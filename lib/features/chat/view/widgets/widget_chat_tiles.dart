import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';

class WidgetChatTiles extends StatefulWidget {
  final String query;
  final VoidCallback closeChat;
  final int? activeChatId;
  const WidgetChatTiles(
      {super.key,
      required this.query,
      required this.closeChat,
      this.activeChatId});

  @override
  State<WidgetChatTiles> createState() => _WidgetChatTilesState();
}

class _WidgetChatTilesState extends State<WidgetChatTiles> {
  bool _isNavigating = false;

  void _selectChat(ChatEntity chat) {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    context.read<MessageCubit>().removeMessages();
    Navigator.of(context).pop();
    context.read<MessageCubit>().fetch(chat.id);
    context.go('/chat/${chat.id}');

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isNavigating = false);
    });
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
          final bool isActive = chat.id == widget.activeChatId;
          return ListTile(
            selected: isActive,
            selectedTileColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
            leading: chat.starredChat
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.chat_bubble_outline),
            title: Text(
              chat.chatName,
              style: isActive
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
            onTap: () => _selectChat(chat),
            onLongPress: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Удалить чат?'),
                  content: Text('«${chat.chatName}» будет удалён. Продолжить?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Отмена')),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              );

              if (ok == true) {
                await context.read<ChatCubit>().deleteChat(chat.id, context);
                if (chat.id == widget.activeChatId && mounted) {
                  context.read<MessageCubit>().removeMessages();
                  context.go('/chat'); // закрываем экран, если он был открыт
                }
              }
            },
          );
        },
      );
    }
  }
}
