import 'package:flutter/material.dart';
import 'widget_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';
import 'package:promts_application_1/features/neuro/view/widget_neuro_button.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_page.dart';

class WidgetMainScreen extends StatefulWidget {
  const WidgetMainScreen({super.key});

  @override
  State<WidgetMainScreen> createState() => _WidgetMainScreenState();
}

class _WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Флаг, указывающий, нужно ли показывать страницу чата
  bool _showChatPage = false;

  // Поле ввода на главном экране (если ещё нужно)
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Открываем страницу чата
  void _openChatWithMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    print("Отправлено сообщение на главном экране: $text");
    _messageController.clear();
    setState(() {
      _showChatPage = true;
    });
  }

  // Открываем страницу чата (при выборе чата)
  void _openChat(String chatName) {
    print("Открываем чат: $chatName");
    _messageController.clear();
    setState(() {
      _showChatPage = true;
    });
  }

  // Функция для перехода с чата на обычный экран
  void _closeChat() {
    setState(() {
      _showChatPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // Левый Drawer
      drawer: SizedBox(
        width: 350,
        child: Drawer(
          child: WidgetChats(
            onChatSelected: _openChat,
          ),
        ),
      ),

      // AppBar
      appBar: WidgetAppBar(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onPromtsPressed: () {
          _closeChat();
        },
      ),

      /// Экран чата
      body: _showChatPage
          ? const Column(
              children: [
                // Кнопка выбора нейросети + кнопка настроек
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: WidgetNeuroButton(),
                ),
                // Сам экран чата
                Expanded(child: WidgetChatPage()),
              ],
            )
          : _buildMainContent(),
    );
  }
  /// Обычный экран
  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Кнопка выбора нейросети + кнопка настроек
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: WidgetNeuroButton(),
          ),
          // Основная часть экрана
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Текст "абвгд"
                    const Text(
                      "абвгд",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Строка ввода (ограничение 900 px) + кнопка отправки
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