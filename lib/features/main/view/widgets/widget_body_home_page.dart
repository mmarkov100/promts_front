import 'package:flutter/material.dart';
import 'package:promts_application_1/features/main/view/widgets/home_input_field.dart';

class WidgetHomePage extends StatefulWidget {
  final ValueChanged<String> openChatWithMessage;
  const WidgetHomePage({super.key, required this.openChatWithMessage});

  @override
  State<WidgetHomePage> createState() => _WidgetHomePageState();
}

class _WidgetHomePageState extends State<WidgetHomePage> {
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
                    const Text(
                      "Приветствую",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    HomeInputField(
                      messageController: _messageController,
                      handleSend: _handleSend,
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
