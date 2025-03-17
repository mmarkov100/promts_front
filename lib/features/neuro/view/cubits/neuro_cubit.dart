// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/neuro/domain/use_cases/get_neuro_data_usecase.dart';

abstract class NeuroState {}

class NeuroInitial extends NeuroState {}

class NeuroLoading extends NeuroState {}

class NeuroLoaded extends NeuroState {
  final List<NeuroEntity> neuroList;
  NeuroLoaded(this.neuroList);
}

class NeuroError extends NeuroState {
  final String message;
  NeuroError(this.message);
}

class NeuroCubit extends Cubit<NeuroState> {
  final GetNeuroDataUseCase getNeuroDataUseCase;

  NeuroCubit({required this.getNeuroDataUseCase}) : super(NeuroInitial());

  Future<void> fetchNeuroData(String token, int userId) async {
    emit(NeuroLoading());
    try {
      final neuroList = await getNeuroDataUseCase(token, userId);
      emit(NeuroLoaded(neuroList));
    } catch (e) {
      emit(NeuroError(e.toString()));
    }
  }
}
