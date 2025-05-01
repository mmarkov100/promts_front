import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'widget_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';
import 'package:promts_application_1/features/neuro/view/widget_neuro_button.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_page.dart';

class WidgetMainScreen extends StatefulWidget {
  final int? openChatId;
  const WidgetMainScreen({super.key, this.openChatId});

  @override
  State<WidgetMainScreen> createState() => _WidgetMainScreenState();
}

class _WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showChatPage = false;
  ChatEntity? _currentChat;
  final appConfig = getIt<AppConfig>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncWithRoute();
  }

  @override
  void didUpdateWidget(covariant WidgetMainScreen old) {
    super.didUpdateWidget(old);
    if (old.openChatId != widget.openChatId) _syncWithRoute();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _syncWithRoute() {
    _showChatPage = widget.openChatId != null;
    if (widget.openChatId == null) {
      _currentChat = null;
      return;
    }
    final state = context.read<ChatCubit>().state;
    if (state is DataLoaded<List<ChatEntity>>) {
      _currentChat = state.data.firstWhereOrNull(
        (c) => c.id == widget.openChatId,
      );
    }
  }

  void _openChatWithMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    setState(() {
      _showChatPage = true;
    });
  }

  void _openChat(ChatEntity chat) {
    _messageController.clear();
    setState(() {
      _currentChat = chat;
      _showChatPage = true;
    });
  }

  void _closeChat() {
    context.go('/chat');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, DataState<List<ChatEntity>>>(
      listener: (context, state) {
        if (widget.openChatId != null &&
            _currentChat == null &&
            state is DataLoaded<List<ChatEntity>>) {
          _currentChat =
              state.data.firstWhereOrNull((c) => c.id == widget.openChatId);
          if (_currentChat != null) setState(() {});
        }
        if (state is DataLoaded<List<ChatEntity>> && _currentChat != null) {
          final updated =
              state.data.firstWhereOrNull((c) => c.id == _currentChat!.id);
          if (updated != null) {
            setState(() => _currentChat = updated);
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const SizedBox(
          width: 350,
          child: Drawer(
            child: Drawer(child: WidgetChats()),
          ),
        ),
        appBar: WidgetAppBar(
          onMenuPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          onPromtsPressed: () {
            _closeChat();
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<UserCubit, DataState<UserEntity>>(
                builder: (context, userState) {
                  UserEntity? user;
                  if (userState is DataLoaded<UserEntity>) {
                    user = userState.data;
                  }
                  return Column(
                    children: [
                      WidgetNeuroButton(
                        currentChat: _currentChat,
                        currentUser: user,
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child:
                  _showChatPage ? const WidgetChatPage() : _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Приветствую",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                labelText: "Введите сообщение",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _openChatWithMessage,
                            tooltip: "Отправить",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
