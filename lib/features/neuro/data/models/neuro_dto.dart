class NeuralNetworkDTO {
  final int id;
  final String name;
  final String desc;

  NeuralNetworkDTO({
    required this.id,
    required this.name,
    required this.desc,
  });

  factory NeuralNetworkDTO.fromJson(Map<String, dynamic> json) {
    return NeuralNetworkDTO(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed model',
      desc: json['desc'] as String? ?? '',
    );
  }
}
