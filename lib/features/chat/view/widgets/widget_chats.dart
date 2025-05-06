import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_tiles.dart';

class WidgetChats extends StatefulWidget {
  final VoidCallback closeChat;
  const WidgetChats({super.key, required this.closeChat});

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
        child: SafeArea(
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
                  onChanged: (value) =>
                      setState(() => _query = value.trim().toLowerCase()),
                  decoration: const InputDecoration(
                    labelText: 'Поиск чатов',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              WidgetChatTiles(
                query: _query,
                closeChat: widget.closeChat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
