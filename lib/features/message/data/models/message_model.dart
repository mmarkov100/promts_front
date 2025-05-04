import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.chatId,
    required super.modelUriId,
    required super.oldMessage,
    required super.role,
    required super.text,
    required super.type,
    required super.dateCreate,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      modelUriId: json['modelUriId'] as int?,
      oldMessage: json['oldMessage'] as bool,
      role: json['role'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      dateCreate: DateTime.parse(json['dateCreate'] as String),
    );
  }

  /// Создаём модель из существующей сущности (например, нашего черновика)
  static MessageModel fromEntity(MessageEntity e) {
    return MessageModel(
      id: e.id,
      chatId: e.chatId,
      modelUriId: e.modelUriId,
      oldMessage: e.oldMessage,
      role: e.role,
      text: e.text,
      type: e.type,
      dateCreate: e.dateCreate,
    );
  }
}
