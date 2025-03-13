import 'package:equatable/equatable.dart'; 

import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_short_entity.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  final List<ChatShortEntity> chats;
  final List<NeuralNetworkEntity> networks;

  UserLoaded({
    required this.user,
    required this.chats,
    required this.networks,
  });

  @override
  List<Object?> get props => [user, chats, networks];
}

class UserError extends UserState {
  final String message;
  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
