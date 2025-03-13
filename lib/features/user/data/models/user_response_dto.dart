import '../../../chat/data/models/chat_short_model.dart';
import 'user_model.dart';
import '../../../neuro/data/models/neuro_model.dart';

class UserResponseDTO {
  final UserModel user;
  final List<ChatShortModel> chats;
  final List<NeuralNetworkModel> neuralNetworks;

  UserResponseDTO({
    required this.user,
    required this.chats,
    required this.neuralNetworks,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) {
    final user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    final chatsJson = json['chats'] as List<dynamic>? ?? [];
    final networksJson = json['neuralNetworks'] as List<dynamic>? ?? [];

    final chats = chatsJson
        .map((chat) => ChatShortModel.fromJson(chat as Map<String, dynamic>))
        .toList();

    final neuralNetworks = networksJson
        .map((net) => NeuralNetworkModel.fromJson(net as Map<String, dynamic>))
        .toList();

    return UserResponseDTO(
      user: user,
      chats: chats,
      neuralNetworks: neuralNetworks,
    );
  }
}
