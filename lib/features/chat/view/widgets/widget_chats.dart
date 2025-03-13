import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_short_entity.dart';
import 'package:promts_application_1/features/user/view/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/view/cubit/user_state.dart';

/// NavigationDrawer, который показывает список чатов пользователя.
class WidgetChats extends StatefulWidget {
  final ValueChanged<int> onChatSelected;

  const WidgetChats({super.key, required this.onChatSelected});

  @override
  State<WidgetChats> createState() => _WidgetChatsState();
}

class _WidgetChatsState extends State<WidgetChats> {
  final TextEditingController _searchController = TextEditingController();

  // Полный список чатов и отфильтрованный список
  List<ChatShortEntity> _chats = [];
  List<ChatShortEntity> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    // Обновляем фильтрацию при изменении текста
    _searchController.addListener(_searchChats);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchChats);
    _searchController.dispose();
    super.dispose();
  }

  // Функция фильтрации списка чатов по введённому запросу
  void _searchChats() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_chats);
      } else {
        _filteredChats = _chats
            .where((chat) => chat.chatName.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Заголовок
          const ListTile(
            title: Text(
              "Мои чаты",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Строка поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Поиск чатов",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchChats,
                ),
              ],
            ),
          ),
          // Список чатов через BlocBuilder
          Expanded(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserError) {
                  return Center(child: Text("Ошибка: ${state.message}"));
                } else if (state is UserLoaded) {
                  // Обновляем список чатов и синхронизируем фильтрацию, если поле поиска пустое
                  _chats = state.chats;
                  if (_searchController.text.isEmpty) {
                    _filteredChats = List.from(_chats);
                  }
                  return ListView.builder(
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = _filteredChats[index];
                      return ListTile(
                        title: Text(chat.chatName),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onChatSelected(chat.id);
                        },
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
