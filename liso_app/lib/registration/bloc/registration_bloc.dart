import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sharish/login/login.dart';
import 'package:formz/formz.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegistrationState()) {
    on<RegistrationUsernameChanged>(_mapUsernameChangedToState);
    on<RegistrationPasswordChanged>(_mapPasswordChangedToState);
    on<RegistrationSubmitted>(_mapLoginSubmittedToState);
  }

  final AuthenticationRepository _authenticationRepository;

  void _mapUsernameChangedToState(
    RegistrationUsernameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final username = Username.dirty(event.username);
    return emit(state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    ));
  }

  void _mapPasswordChangedToState(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final password = Password.dirty(event.password);
    return emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    ));
  }

  FutureOr<void> _mapLoginSubmittedToState(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on Exception catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
