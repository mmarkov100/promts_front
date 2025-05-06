// lib/features/message/cubits/message_state.dart

import 'package:flutter/foundation.dart';
import 'package:promts_application_1/features/message/domain/entities/message_entity.dart';

@immutable
abstract class MessageState {
  const MessageState();
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoadingHistory extends MessageState {
  const MessageLoadingHistory();
}

class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  final bool isGenerating;

  const MessageLoaded(this.messages, {this.isGenerating = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageLoaded &&
          runtimeType == other.runtimeType &&
          listEquals(messages, other.messages) &&
          isGenerating == other.isGenerating;

  @override
  int get hashCode => messages.hashCode ^ isGenerating.hashCode;
}

class MessageError extends MessageState {
  final String message;
  const MessageError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
