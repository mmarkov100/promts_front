import 'package:promts_application_1/features/chat/view/widgets/abstract_chat_settings.dart';

class ChatCreateSettings extends AbstractChatSettingsDialog {
  const ChatCreateSettings({
    super.key,
    super.initialTemperature = 1.0,
    super.initialContext = '',
    super.initialUseMemory = false,
    super.initialUpdateMemory = false,
    required super.onSave,
  }) : super(
         title: 'Создание чата',
         showStar: false,
         showDate: false,
       );
}
