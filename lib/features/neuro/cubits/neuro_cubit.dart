// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/neuro/domain/repositories/neuro_repository.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_state.dart';

class NeuroCubit extends Cubit<NeuroState> {
  final NeuroRepository repository;

  NeuroCubit({required this.repository}) : super(NeuroInitial());

  Future<void> fetchNeuroData() async {
    emit(NeuroLoading());
    try {
      final neuroList = await repository.fetchNeuroData();
      emit(NeuroLoaded(neuroList));
    } catch (e) {
      emit(NeuroError(e.toString()));
    }
  }
}
