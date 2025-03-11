import 'package:flutter/material.dart';
import 'widget_app_bar.dart';
import '../../../chat/view/widgets/widget_chats.dart';
import '../../../../neuro/view/widget_neuro_button.dart';

class WidgetMainScreen extends StatefulWidget {
  const WidgetMainScreen({super.key});

  @override
  WidgetMainScreenState createState() => WidgetMainScreenState();
}

class WidgetMainScreenState extends State<WidgetMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    print("Отправлено сообщение: $text");
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  

      // AppBar c одним колбэком
      appBar: WidgetAppBar(
        onMenuPressed: () {
          // Открываем левый Drawer
          _scaffoldKey.currentState?.openDrawer();
        },
      ),

      // Левый Drawer (список чатов)
      drawer: const SizedBox(
        width: 350,
        child: Drawer(
          child: WidgetChats(),
        ),
      ),


      body: SafeArea(
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                              onPressed: _sendMessage,
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
      ),
    );
  }
}
