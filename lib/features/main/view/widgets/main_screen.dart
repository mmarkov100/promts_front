import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/main/view/widgets/main_body.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'main_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';

class MainScreen extends StatefulWidget {
  final int? openChatId;
  const MainScreen({super.key, this.openChatId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, dynamic> _draft = {};
  ChatEntity? _currentChat;
  bool _isCreatingChat = false;

  @override
  void initState() {
    super.initState();
    final chats = context.read<ChatCubit>().state;
    if (widget.openChatId != null && chats is! DataLoaded<List<ChatEntity>>) {
      context.read<MessageCubit>().fetch(widget.openChatId!);
    }
    _syncWithRoute(chats is DataLoaded<List<ChatEntity>> ? chats.data : null);
  }

  @override
  void didUpdateWidget(covariant MainScreen old) {
    super.didUpdateWidget(old);
    if (old.openChatId != widget.openChatId) {
      final chats = context.read<ChatCubit>().state;
      _syncWithRoute(chats is DataLoaded<List<ChatEntity>> ? chats.data : null);
    }
  }

  void _updateDraft(Map<String, dynamic> data) =>
      setState(() => _draft.addAll(data));

  void _syncWithRoute(List<ChatEntity>? chats) {
    final id = widget.openChatId;
    if (id == null) {
      _currentChat = null;
      return;
    }

    if (chats != null) {
      _currentChat = chats.firstWhereOrNull((c) => c.id == id);
    } else {
      _currentChat = null;
    }
  }

  void _createAndOpenChatWithMessageWithText(String text) async {
    setState(() {
      _isCreatingChat = true;
    });
    try {
      // Обнуляем сообщения из прошлого чата
      context.read<MessageCubit>().removeMessages();

      final user = (context.read<UserCubit>().state as DataLoaded).data;

      final body = {
        'modelUriId': _draft['modelUriId'] ?? user.standartModelUriId,
        'temperature': _draft['temperature'] ?? 1.0,
        'context': _draft['context'] ?? '',
        'useMemory': _draft['useMemory'] ?? user.memoryEnabled,
        'updateMemory': _draft['updateMemory'] ?? user.aiCanUpdateMemory,
      };

      final newChat = await context.read<ChatCubit>().createChat(body);

      context.read<ChatCubit>().addLocalChat(newChat);

      if (mounted) context.go('/chat/${newChat.id}');

      setState(() {
          _isCreatingChat = false;
        });

      await context.read<MessageCubit>().send(
            chatId: newChat.id,
            modelUriId: newChat.modelUriId,
            text: text,
            context: context,
          );
      _draft.clear();
    } catch (e) {
      WidgetSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingChat = false;
        });
      }
    }
  }

  void _closeChat() {
    setState(() {
      _currentChat = null;
    });
    context.go('/chat');
  }

  @override
  Widget build(BuildContext context) {
    final showChat = widget.openChatId != null;
    return BlocListener<ChatCubit, DataState<List<ChatEntity>>>(
        listenWhen: (previous, current) {
          if (previous is! DataLoaded<List<ChatEntity>> &&
              current is DataLoaded<List<ChatEntity>>) {
            return true;
          }
          if (previous is DataLoaded<List<ChatEntity>> &&
              current is DataLoaded<List<ChatEntity>>) {
            final prevList = previous.data;
            final currList = current.data;
            return prevList.length != currList.length ||
                !const ListEquality<ChatEntity>().equals(prevList, currList);
          }
          return false;
        },
        listener: (context, state) {
          if (state is! DataLoaded<List<ChatEntity>>) return;

          final chats = state.data;
          final id = widget.openChatId;

          if (id == null) {
            if (_currentChat != null) {
              setState(() => _currentChat = null);
            }
            return;
          }

          final found = chats.firstWhereOrNull((c) => c.id == id);
          if (found == null) {
            // ignore: use_build_context_synchronously
            Future.microtask(() => context.go('/chat'));
            return;
          }

          if (found != _currentChat) {
            setState(() => _currentChat = found);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: WidgetChats(
            closeChat: _closeChat,
          ),
          appBar: MainAppBar(
            onMenuPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onPromtsPressed: () {
              _closeChat();
            },
          ),
          body: MainBody(
            isCreatingChat: _isCreatingChat,
            chatEntity: _currentChat,
            openChatWithMessageWithText: _createAndOpenChatWithMessageWithText,
            showChat: showChat,
            chatId: widget.openChatId,
            onChatCreateSettings: _updateDraft,
          ),
        ));
  }
}
