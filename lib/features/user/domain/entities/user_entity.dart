class UserEntity {
  final int id;
  final String email;
  final String role;
  final double money;
  final String memory;
  final bool memoryEnable;
  final bool aiCanUpdateMemory;
  final int standartModelUrild;

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.money,
    required this.memory,
    required this.memoryEnable,
    required this.aiCanUpdateMemory,
    required this.standartModelUrild,
  });
}
