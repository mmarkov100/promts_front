import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

class NeuroModel extends NeuroEntity {
  NeuroModel({
    required int id,
    required String name,
    required String systemName,
    required String desc,
  }) : super(id: id, name: name, systemName: systemName, desc: desc);

  factory NeuroModel.fromJson(Map<String, dynamic> json) {
    return NeuroModel(
      id: json['id'],
      name: json['name'],
      systemName: json['systemName'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'systemName': systemName,
      'desc': desc,
    };
  }
}
