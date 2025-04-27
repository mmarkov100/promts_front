// ignore: depend_on_referenced_packages
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/domain/repositories/neuro_repository.dart';

class NeuroCubit extends DataCubit<List<NeuroEntity>> {
  final NeuroRepository repository;
  NeuroCubit({ required this.repository }) : super(){
    fetch();
  }

  void fetch() => load(() => repository.fetchNeuroData());
}

