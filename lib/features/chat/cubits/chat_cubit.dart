import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/domain/repositories/chat_repository.dart';

class ChatCubit extends DataCubit<List<ChatEntity>> {
  final ChatRepository repository;
  ChatCubit({required this.repository}) : super(){
    fetchChats();
  }

  void fetchChats() => load(() => repository.fetchChats());
}
