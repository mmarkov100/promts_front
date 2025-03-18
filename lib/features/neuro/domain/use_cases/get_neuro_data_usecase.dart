import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/domain/repositories/neuro_repository.dart';

class GetNeuroDataUseCase {
  final NeuroRepository repository;

  GetNeuroDataUseCase({required this.repository});

  Future<List<NeuroEntity>> call(String token, int userId) async {
    return await repository.fetchNeuroData(token, userId);
  }
}
