import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/features/neuro/data/datasources/neuro_datasource.dart';
import 'package:promts_application_1/features/neuro/data/implimintations/neuro_repository_impl.dart';
import 'package:promts_application_1/features/neuro/domain/use_cases/get_neuro_data_usecase.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_cubit.dart';
import 'widget_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';
import 'package:promts_application_1/features/neuro/view/widget_neuro_button.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_page.dart';
import 'package:http/http.dart' as http;

class WidgetMainScreen extends StatefulWidget {
  const WidgetMainScreen({super.key});

  @override
  State<WidgetMainScreen> createState() => _WidgetMainScreenState();
}

class _WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showChatPage = false;
  final AppConfig appConfig = AppConfig();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _openChatWithMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    setState(() {
      _showChatPage = true;
    });
  }

  void _openChat(int chatId) {
    _messageController.clear();
    setState(() {
      _showChatPage = true;
    });
  }

  void _closeChat() {
    setState(() {
      _showChatPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: 350,
        child: Drawer(
          child: WidgetChats(
            onChatSelected: _openChat,
          ),
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
            child: BlocProvider<NeuroCubit>(
              create: (context) => NeuroCubit(
                getNeuroDataUseCase: GetNeuroDataUseCase(
                  repository: NeuroRepositoryImpl(
                    remoteDataSource: NeuroRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
              )..fetchNeuroData(appConfig.getJwtToken(), appConfig.getUserId()),
              child: const WidgetNeuroButton(),
            ),
          ),
          Expanded(
            child: _showChatPage ? const WidgetChatPage() : _buildMainContent(),
          ),
        ],
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
