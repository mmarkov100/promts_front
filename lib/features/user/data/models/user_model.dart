import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.role,
    required super.money,
    required super.memory,
    required super.memoryEnabled,
    required super.aiCanUpdateMemory,
    required super.standartModelUriId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      money: (json['money'] as num).toDouble(),
      memory: json['memory'] as String? ?? '',
      // безопасное чтение булевых полей
      memoryEnabled: json['memoryEnabled'] as bool? ?? false,
      aiCanUpdateMemory: json['aiCanUpdateMemory'] as bool? ?? false,
      // ключ в JSON называется standardModelUriId
      standartModelUriId: json['standardModelUriId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'money': money,
      'memory': memory,
      'memoryEnabled': memoryEnabled,
      'aiCanUpdateMemory': aiCanUpdateMemory,
      'standardModelUriId': standartModelUriId,
    };
  }
}