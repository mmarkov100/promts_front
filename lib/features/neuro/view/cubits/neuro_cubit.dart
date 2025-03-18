// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/neuro/domain/use_cases/get_neuro_data_usecase.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_state.dart';

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
