import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
part 'sing_in_event.dart';
part 'sing_in_state.dart';

class SingInBloc extends Bloc<SingInEvent, SingInState> {
  final UserRepository _userRepository;
  SingInBloc(this._userRepository) : super(SingInInitial()) {
    on<SingInRequired>((event, emit) async {
      emit(SingInLoading());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SingInSuccess());
      } catch (e) {
        emit(SingInFailure());
      }
    });

    on<SingOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
