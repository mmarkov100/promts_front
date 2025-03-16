import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.userId,
    required super.chatBotId,
    required super.chatName,
    required super.modelUriId,
    required super.temperature,
    required super.context,
    required super.starredChat,
    required super.useMemory,
    required super.updateMemory,
    required super.canUseMemory,
    required super.canUpdateMemory,
    required super.canEditModelUri,
    required super.canEditContext,
    required super.dateEdit,
    required super.dateCreate,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      chatBotId: json['chatBotId'] as int,
      chatName: json['chatName'] as String? ?? 'Без названия',
      modelUriId: json['modelUriId'] as int,
      temperature: (json['temperature'] as num).toDouble(),
      context: json['context'] as String,
      starredChat: json['starredChat'] as bool? ?? false,
      useMemory: json['useMemory'] as bool,
      updateMemory: json['updateMemory'] as bool,
      canUseMemory: json['canUseMemory'] as bool,
      canUpdateMemory: json['canUpdateMemory'] as bool,
      canEditModelUri: json['canEditModelUri'] as bool,
      canEditContext: json['canEditContext'] as bool,
      dateEdit: DateTime.parse(json['dateEdit'] as String),
      dateCreate: DateTime.parse(json['dateCreate'] as String),
    );
  }
}
