import 'package:promts_application_1/features/neuro/data/datasources/implimintations/neuro_repository.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

class GetNeuroDataUseCase {
  final NeuroRepository repository;

  GetNeuroDataUseCase({required this.repository});

  Future<List<NeuroEntity>> call(String token, int userId) async {
    return await repository.fetchNeuroData(token, userId);
  }
}
