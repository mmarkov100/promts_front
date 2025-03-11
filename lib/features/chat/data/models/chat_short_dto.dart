// Минимальная модель, соответствующая элементам из "chats": [...]

class ChatShortDTO {
  final int id;
  final String chatName;
  final bool starredChat;
  final DateTime dateEdit;

  ChatShortDTO({
    required this.id,
    required this.chatName,
    required this.starredChat,
    required this.dateEdit,
  });

  factory ChatShortDTO.fromJson(Map<String, dynamic> json) {
    return ChatShortDTO(
      id: json['id'] as int,
      chatName: json['chatName'] as String? ?? 'Без названия',
      starredChat: json['starredChat'] as bool? ?? false,
      dateEdit: DateTime.parse(json['dateEdit'] as String),
    );
  }
}
