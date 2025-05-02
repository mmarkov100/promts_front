import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_body_home_page.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'widget_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';
import 'package:promts_application_1/features/neuro/view/widget_neuro_button.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_body_chat_page.dart';

class WidgetMainScreen extends StatefulWidget {
  final int? openChatId;
  const WidgetMainScreen({super.key, this.openChatId});

  @override
  State<WidgetMainScreen> createState() => _WidgetMainScreenState();
}

class _WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ChatEntity? _currentChat;

  @override
  void initState() {
    super.initState();
    final chats = context.read<ChatCubit>().state;
    _syncWithRoute(chats is DataLoaded<List<ChatEntity>> ? chats.data : null);
  }

  @override
  void didUpdateWidget(covariant WidgetMainScreen old) {
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

  void _openChatWithMessageWithText(String message) {
    context.go('/chat/3');
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
      listener: (context, state) {
        if (widget.openChatId == null) return;
        if (widget.openChatId != null &&
            _currentChat == null &&
            state is DataLoaded<List<ChatEntity>>) {
          _currentChat =
              state.data.firstWhereOrNull((c) => c.id == widget.openChatId);
          if (_currentChat != null) setState(() {});
        }
        if (state is DataLoaded<List<ChatEntity>>) {
          _syncWithRoute(state.data);

          if (_currentChat != null) {
            final updated =
                state.data.firstWhereOrNull((c) => c.id == _currentChat!.id);
            if (updated != null && updated != _currentChat) {
              setState(() => _currentChat = updated);
            }
          }
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
              child: showChat
                  ? const WidgetChatPage()
                  : WidgetHomePage(
                      openChatWithMessage: _openChatWithMessageWithText,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
