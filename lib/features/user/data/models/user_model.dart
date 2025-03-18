
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.role,
    required super.money,
    required super.memory,
    required super.memoryEnable,
    required super.aiCanUpdateMemory,
    required super.standartModelUrild,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      money: (json['money'] as num).toDouble(),
      memory: json['memory'] as String,
      memoryEnable: json['memoryEnable'] as bool,
      aiCanUpdateMemory: json['aiCanUpdateMemory'] as bool,
      standartModelUrild: json['standartModelUrild'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'money': money,
      'memory': memory,
      'memoryEnable': memoryEnable,
      'aiCanUpdateMemory': aiCanUpdateMemory,
      'standartModelUrild': standartModelUrild,
    };
  }
}
