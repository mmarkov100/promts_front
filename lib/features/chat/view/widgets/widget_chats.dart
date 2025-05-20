import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_tiles.dart';

class WidgetChats extends StatefulWidget {
  final VoidCallback closeChat;
  final int? activeChatId;
  const WidgetChats({super.key, required this.closeChat, this.activeChatId});

  @override
  State<WidgetChats> createState() => _WidgetChatsState();
}

class _WidgetChatsState extends State<WidgetChats> {
  String _query = '';

  void _refreshChats() {
    context.read<ChatCubit>().fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.8), // более плотный, стильный
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и иконка обновления
                Row(
                  children: [
                    const Text(
                      "Мои чаты",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white70),
                      tooltip: 'Обновить чаты',
                      onPressed: _refreshChats,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Поле поиска
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Поиск чатов',
                      hintStyle: TextStyle(color: Colors.white54),
                      icon: Icon(Icons.search, color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Список чатов
                Expanded(
                  child: WidgetChatTiles(
                    query: _query,
                    closeChat: widget.closeChat,
                    activeChatId: widget.activeChatId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
