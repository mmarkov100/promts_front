class TokenCheckEntity {
  final bool success;
  final String message;
  final String? error;

  TokenCheckEntity({
    required this.success,
    required this.message,
    this.error,
  });
}
