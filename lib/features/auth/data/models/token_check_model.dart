import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';

class TokenCheckModel extends TokenCheckEntity {
  TokenCheckModel({
    required super.success,
    required super.message,
    super.error,
  });

  factory TokenCheckModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('success')) {
      return TokenCheckModel(
        success: json['success'] as bool,
        message: json['message'] as String,
      );
    } else {
      return TokenCheckModel(
        success: false,
        message: json['message'] as String,
        error: json['error'] as String,
      );
    }
  }
}
