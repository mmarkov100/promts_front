// file: lib/data/models/user_response_dto.dart
// Объединяет все поля из удачного ответа для /user/registration и /user/login
import '../../../chat/data/models/chat_short_dto.dart';
import '../../../user/data/models/user_dto.dart';
import '../../../neuro/data/models/neuro_dto.dart';

class UserResponseDTO {
  final UserDTO user;
  final List<ChatShortDTO> chats;
  final List<NeuralNetworkDTO> neuralNetworks;

  UserResponseDTO({
    required this.user,
    required this.chats,
    required this.neuralNetworks,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) {
    // Пример структуры успешного ответа:
    // {
    //   "user": {...},
    //   "chats": [...],
    //   "neuralNetworks": [...]
    // }
    final user = UserDTO.fromJson(json['user'] as Map<String, dynamic>);
    final chatsJson = json['chats'] as List<dynamic>? ?? [];
    final networksJson = json['neuralNetworks'] as List<dynamic>? ?? [];

    final chats = chatsJson
        .map((chat) => ChatShortDTO.fromJson(chat as Map<String, dynamic>))
        .toList();

    final neuralNetworks = networksJson
        .map((net) => NeuralNetworkDTO.fromJson(net as Map<String, dynamic>))
        .toList();

    return UserResponseDTO(
      user: user,
      chats: chats,
      neuralNetworks: neuralNetworks,
    );
  }
}
