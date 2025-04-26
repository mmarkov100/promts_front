import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

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