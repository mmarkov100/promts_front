class UserEntity {
  final int id;
  final String email;
  final String role;
  final double money;
  final String memory;
  final bool memoryEnabled;
  final bool aiCanUpdateMemory;
  final int standardModelUriId;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.money,
    required this.memory,
    required this.memoryEnabled,
    required this.aiCanUpdateMemory,
    required this.standardModelUriId,
  });
}
