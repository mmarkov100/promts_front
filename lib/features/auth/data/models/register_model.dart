import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({
    required super.success,
    required super.message,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}