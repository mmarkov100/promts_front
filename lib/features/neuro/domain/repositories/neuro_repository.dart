import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

abstract class NeuroRepository {
  Future<List<NeuroEntity>> fetchNeuroData();
}