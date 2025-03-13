import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
    required super.money,
    required super.memory,
    required super.memoryEnabled,
    required super.aiCanUpdateMemory,
    required super.standardModelUriId
  });

  // Парсим JSON из поля "user" ответа
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      money: (json['money'] as num).toDouble(),
      memory: json['memory'] as String? ?? '',
      memoryEnabled: json['memoryEnabled'] as bool? ?? true,
      aiCanUpdateMemory: json['aiCanUpdateMemory'] as bool? ?? true,
      standardModelUriId: json['standardModelUriId'] as int
    );
  }
}
