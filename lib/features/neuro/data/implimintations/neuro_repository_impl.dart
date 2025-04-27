import 'package:promts_application_1/features/neuro/data/datasources/neuro_datasource.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/domain/repositories/neuro_repository.dart';

class NeuroRepositoryImpl implements NeuroRepository {
  final NeuroRemoteDataSource remoteDataSource;

  NeuroRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NeuroEntity>> fetchNeuroData() async {
    return await remoteDataSource.getNeuroModelList();
  }
}
