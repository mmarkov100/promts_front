import 'package:promts_application_1/features/chat/domain/entities/chat_short_entity.dart';

class ChatShortModel extends ChatShortEntity{
  ChatShortModel({
    required super.id,
    required super.chatName,
    required super.starredChat,
    required super.dateEdit,
  });

  factory ChatShortModel.fromJson(Map<String, dynamic> json) {
    return ChatShortModel(
      id: json['id'] as int,
      chatName: json['chatName'] as String? ?? 'Без названия',
      starredChat: json['starredChat'] as bool? ?? false,
      dateEdit: DateTime.parse(json['dateEdit'] as String),
    );
  }
}
