import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:promts_application_1/features/shared/widgets/message_input_field.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<String> openChatWithMessage;
  final bool isCreatingChat;

  const HomeView({
    super.key,
    required this.openChatWithMessage,
    required this.isCreatingChat,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _messageController = TextEditingController();
  String _fullText = '';
  String _displayedText = '';
  Timer? _typingTimer;

  final List<String> _greetings = [
    "Привет! Ты здесь? Значит, сегодня будет продуктивный день! (Или просто кофе закончился?)☕️",
    "Добро пожаловать! Мы уже начали без тебя, но сделали вид, что ждали.😏",
    "О, смотрите кто пришёл! Наш любимый пользователь! (Ну или хотя бы один из них.)❤️",
    "Приветствие загружено на 100%. Теперь можно начинать!⚡️",
    "Ты здесь — и это не случайность! (Хотя статистически всё возможно.)🎲",
    "Привет! Мы не шпионим за тобой… Пока что.👀",
    "Добро пожаловать! Надеемся, ты в хорошем настроении. Если нет — мы притворимся, что не заметили.😄",
    "Привет! Ты выглядишь сегодня потрясающе… (Да-да, даже через экран это видно!)✨",
    "Ого, новый посетитель! Прямо как в лучших веб-сайтах 90-х.🌐",
    "Здравствуй! Мы бы встали при твоём появлении, но мы же приложение… Так что просто рады тебя видеть!🚀",
  ];

  @override
  void initState() {
    super.initState();
    _fullText = _greetings[Random().nextInt(_greetings.length)];
    _startTypingEffect();
  }

  void _startTypingEffect() {
    int index = 0;
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index >= _fullText.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _displayedText += _fullText[index];
      });
      index++;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingTimer?.cancel();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final double blockWidth = screenWidth < 500
        ? screenWidth * 0.95
        : screenWidth < 1000
            ? 500
            : 650;

    return SafeArea(
      child: Center(
        child: SizedBox(
          width: blockWidth, // ✅ это обязательно
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isCreatingChat)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    _displayedText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 212, 212, 212),
                      height: 1.5,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 2,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                MessageInputField(
                  controller: _messageController,
                  hintText: "Введите сообщение",
                  onSend: _handleSend,
                  enabled: !widget.isCreatingChat,
                  constraints: BoxConstraints(maxWidth: blockWidth),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
