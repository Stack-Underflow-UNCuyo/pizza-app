part of 'sing_in_bloc.dart';

sealed class SingInEvent extends Equatable {
  const SingInEvent();

  @override
  List<Object> get props => [];
}

class SingInRequired extends SingInEvent {
  final String email;
  final String password;

  const SingInRequired(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SingOutRequired extends SingInEvent {}
