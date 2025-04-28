class ChatEntity {
  final int id;
  final int userId;
  final int? chatBotId;
  final String chatName;
  final int modelUriId;
  final double temperature;
  final String context;
  final bool starredChat;
  final bool useMemory;
  final bool updateMemory;
  final bool canUseMemory;
  final bool canUpdateMemory;
  final bool canEditModelUri;
  final bool canEditContext;
  final DateTime dateEdit;
  final DateTime dateCreate;

  ChatEntity({
    required this.id,
    required this.userId,
    required this.chatBotId,
    required this.chatName,
    required this.modelUriId,
    required this.temperature,
    required this.context,
    required this.starredChat,
    required this.useMemory,
    required this.updateMemory,
    required this.canUseMemory,
    required this.canUpdateMemory,
    required this.canEditModelUri,
    required this.canEditContext,
    required this.dateEdit,
    required this.dateCreate,
  });
}
