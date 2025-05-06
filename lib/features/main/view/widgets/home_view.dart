import 'package:flutter/material.dart';
import 'package:promts_application_1/features/shared/widgets/message_input_field.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<String> openChatWithMessage;
  final bool isCreatingChat;
  const HomeView(
      {super.key,
      required this.openChatWithMessage,
      required this.isCreatingChat});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    widget.openChatWithMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                    if (widget.isCreatingChat)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ) else const Text(
                        "Приветствую",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16),
                    MessageInputField(
                      controller: _messageController,
                      hintText: "Введите сообщение",
                      onSend: _handleSend,
                      enabled: !widget.isCreatingChat,
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
