part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthCreateAccount extends AuthEvent {
  final String email;
  final String password;

  const AuthCreateAccount(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
