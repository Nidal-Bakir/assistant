import 'dart:async';

import 'package:assistant/repositories/firebase_auth_repository.dart';
import 'package:assistant/util/error/auth_error.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FireBaseAuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    // if the user already logged-in
    var _user = _repository.getUser();
    if (_user != null) {
      emit(AuthSuccess(_user));
    }
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthCreateAccount) {
      yield* _authCreateAccountHandler(event.email, event.password);
    } else if (event is AuthLogin) {
      yield* _authLoginHandler(event.email, event.password);
    }
  }

  Stream<AuthState> _authLoginHandler(String email, String password) async* {
    yield AuthInProgress();
    try {
      var _user = await _repository.login(email, password);
      yield AuthSuccess(_user.user);
    } on UserNotFound catch (e) {
      yield AuthFailure(e.msg);
    } on WrongPassword catch (e) {
      yield AuthFailure(e.msg);
    } on Exception {
      yield AuthFailure('unknown error try again later! ');
    }
  }

  Stream<AuthState> _authCreateAccountHandler(
      String email, String password) async* {
    yield AuthInProgress();
    try {
      var _user = await _repository.createAccount(email, password);
      yield AuthSuccess(_user.user);
    } on WeakPassword catch (e) {
      yield AuthFailure(e.msg);
    } on EmailAlreadyInUse catch (e) {
      yield AuthFailure(e.msg);
    } on Exception {
      yield AuthFailure('unknown error try again later! ');
    }
  }
}