part of 'sing_in_bloc.dart';

sealed class SingInState extends Equatable {
  const SingInState();

  @override
  List<Object> get props => [];
}

final class SingInInitial extends SingInState {}

final class SingInFailure extends SingInState {}

final class SingInLoading extends SingInState {}

final class SingInSuccess extends SingInState {}
