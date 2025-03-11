
class UserDTO {
  final int id;
  final String email;
  final String role;
  final double money;
  final String memory;
  final bool memoryEnabled;
  final bool aiCanUpdateMemory;
  final int standardModelUriId;

  UserDTO({
    required this.id,
    required this.email,
    required this.role,
    required this.money,
    required this.memory,
    required this.memoryEnabled,
    required this.aiCanUpdateMemory,
    required this.standardModelUriId,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      money: (json['money'] as num).toDouble(),
      memory: json['memory'] as String? ?? "",
      memoryEnabled: json['memoryEnabled'] as bool? ?? false,
      aiCanUpdateMemory: json['aiCanUpdateMemory'] as bool? ?? false,
      standardModelUriId: json['standardModelUriId'] as int? ?? 1,
    );
  }
}
