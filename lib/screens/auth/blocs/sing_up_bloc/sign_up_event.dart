part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SingUpRequired extends SignUpEvent {
  final MyUser user;
  final String password;

  const SingUpRequired(this.user, this.password);

  @override
  List<Object> get props => [user, password];
}
