import 'package:flutter/material.dart';
import 'widget_app_bar.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chats.dart';
import 'package:promts_application_1/features/chatbot/view/widgets/widget_chat_bots.dart';
import 'package:promts_application_1/neuro/view/widget_neuro_button.dart';
import 'package:promts_application_1/features/chat/view/widgets/widget_chat_page.dart';

class WidgetMainScreen extends StatefulWidget {
  const WidgetMainScreen({Key? key}) : super(key: key);

  @override
  State<WidgetMainScreen> createState() => _WidgetMainScreenState();
}

class _WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Флаг, указывающий, нужно ли показывать страницу чата
  bool _showChatPage = false;

  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Открываем страницу чата
  void _openChat() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    print("Отправлено сообщение на главном экране: $text");
    _messageController.clear();

    setState(() {
      _showChatPage = true;
    });
  }

  // Возвращаемся обратно к обычному экрану (если нужно)
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
      drawer: const SizedBox(
        width: 350,
        child: Drawer(
          child: WidgetChats(),
        ),
      ),

      // AppBar
      appBar: WidgetAppBar(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),

      // Если _showChatPage == true, показываем экран чата, иначе обычный экран
      body: _showChatPage
          ? Column(
              children: [
                // Кнопка выбора нейросети + кнопка настроек
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: WidgetNeuroButton(),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _closeChat,
                      ),
                      const Text("Чат с нейросетью"),
                    ],
                  ),
                ),
                // Сам экран чата
                const Expanded(
                  child: WidgetChatPage(),
                ),
              ],
            )
          : _buildMainContent(),
    );
  }

  /// Содержимое обычного экрана
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
                    const Text(
                      "OABABB",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
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
                            onPressed: _openChat,
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
