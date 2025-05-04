import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/main/view/widgets/main_body.dart';
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

  ChatEntity? _currentChat;
  bool _isCreatingChat = false;

  @override
  void initState() {
    super.initState();
    final chats = context.read<ChatCubit>().state;
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

  void _syncWithRoute(List<ChatEntity>? chats) {
    final id = widget.openChatId;
    if (id == null) {
      _currentChat = null;
      return;
    }

    if (chats != null) {
      _currentChat = chats.firstWhereOrNull((c) => c.id == id);

      if (_currentChat == null) {
        // ignore: use_build_context_synchronously
        Future.microtask(() => context.go('/chat'));
        return;
      }
    } else {
      _currentChat = null;
    }
  }

  void _openChatWithMessageWithText(String text) async {
    // 1) блокируем ввод (можно завести bool _creatingChat и передать его в HomeView)
    setState(() => _isCreatingChat = true);

    try {
      final user = (context.read<UserCubit>().state as DataLoaded).data;
      final chatCubit = context.read<ChatCubit>();

      // 2) собираем «дефолтные» поля
      final newChat = await chatCubit.createChat({
        'modelUriId': user.standartModelUriId, // дефолт от пользователя
        'temperature': 1.0,
        'context': '',
        'useMemory': user.memoryEnabled,
        'updateMemory': user.aiCanUpdateMemory,
      });

      // 3) переходим в созданный чат
      if (mounted) context.go('/chat/${newChat.id}');
      // (здесь можно сохранить text в переменную и слать уже /messages,
      //  но это следующий шаг)
    } catch (e) {
      WidgetSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isCreatingChat = false);
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
          drawer: const WidgetChats(),
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
            openChatWithMessageWithText: _openChatWithMessageWithText,
            showChat: showChat,
          ),
        ));
  }
}
