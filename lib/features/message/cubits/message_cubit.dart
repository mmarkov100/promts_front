import 'package:promts_application_1/core/cubits/data_cubit.dart';
import '../domain/entities/message_entity.dart';
import '../domain/repositories/message_repository.dart';

class MessageCubit extends DataCubit<List<MessageEntity>> {
  final MessageRepository repo;
  MessageCubit({required this.repo}) : super();

  void fetch(int chatId) => load(() => repo.fetchMessages(chatId));
}
