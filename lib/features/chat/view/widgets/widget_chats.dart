import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';

class WidgetChats extends StatefulWidget {

  const WidgetChats({super.key});
  
  @override
  State<WidgetChats> createState() => _WidgetChatsState();
}

class _WidgetChatsState extends State<WidgetChats> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectChat(ChatEntity chat) {
    Navigator.of(context).pop();
    context.go('/chat/${chat.id}');
  }

  void _refreshChats() {
    context.read<ChatCubit>().fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "Мои чаты",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Обновить чаты',
              onPressed: _refreshChats,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск чатов',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatCubit, DataState<List<ChatEntity>>>(
              builder: (context, state) {
                if (state is DataLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DataError) {
                  return Center(child: Text('Ошибка: ${state.toString()}'));
                } else if (state is DataLoaded<List<ChatEntity>>) {
                  final sorted = [...state.data]
                    ..sort((a, b) {
                      if (a.starredChat && !b.starredChat) return -1;
                      if (!a.starredChat && b.starredChat) return 1;
                      return b.dateEdit.compareTo(a.dateEdit);
                    });

                  final filtered = _query.isEmpty
                      ? sorted
                      : sorted
                          .where((chat) =>
                              chat.chatName.toLowerCase().contains(_query))
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
                        subtitle: Text(
                          'Изменён: ${chat.dateEdit.toLocal().toIso8601String().split('T').first}',
                        ),
                        onTap: () => _selectChat(chat),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
