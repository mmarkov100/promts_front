import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

class NeuralNetworkModel extends NeuralNetworkEntity{
  NeuralNetworkModel({
    required super.id,
    required super.name,
    required super.systemName,
    required super.desc,
  });

  factory NeuralNetworkModel.fromJson(Map<String, dynamic> json) {
    return NeuralNetworkModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed model',
      systemName: json['systemName'] as String? ?? 'Unnamed model',
      desc: json['desc'] as String? ?? '',
    );
  }
}
