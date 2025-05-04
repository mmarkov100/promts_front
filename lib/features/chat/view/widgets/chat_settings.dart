import 'package:promts_application_1/features/chat/view/widgets/abstract_chat_settings.dart';

class ChatSettings extends AbstractChatSettingsDialog {
  const ChatSettings({
    super.key,
    super.initialModelId,
    required super.chatId,
    required String super.dateCreate,
    required super.initialStarred,
    required super.initialTemperature,
    required super.initialContext,
    required super.initialUseMemory,
    required super.initialUpdateMemory,
    required super.onSave,
  }) : super(
          title: 'Настройки чата',
          showStar: true,
          showDate: true,
        );
}
