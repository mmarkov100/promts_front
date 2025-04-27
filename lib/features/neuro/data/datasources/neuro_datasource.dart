import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';

abstract class NeuroRemoteDataSource {
  Future<List<NeuroModel>> getNeuroModelList();
}

class NeuroRemoteDataSourceImpl implements NeuroRemoteDataSource {
  final ApiService api = getIt<ApiService>();

  NeuroRemoteDataSourceImpl();

  @override
  Future<List<NeuroModel>> getNeuroModelList() async {
    //TODO Обратно поменять на гет запрос, а то нгрок хуета какая-то
    return api.postList<NeuroModel>(
      '/neuro',
      fromJsonItem: (json) => NeuroModel.fromJson(json),
    );
  }
}
