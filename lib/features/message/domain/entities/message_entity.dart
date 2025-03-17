class MessageEntity {
  final int id;
  final int chatId;
  final int modelUriId;
  final bool oldMessage;
  final String role;
  final String text;
  final String type;
  final DateTime dateCreate;

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.modelUriId,
    required this.oldMessage,
    required this.role,
    required this.text,
    required this.type,
    required this.dateCreate,
  });
}
