part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String? username;
  final String? password;

  const LoginRequested({this.username, this.password});

  @override
  List<Object> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String? username;
  final String? password;

  const RegisterRequested({this.username, this.password});

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {

  const LogoutRequested();

  @override
  List<Object> get props => [];
}
class CheckAuthStatus extends AuthEvent {

  const CheckAuthStatus();

  @override
  List<Object> get props => [];
}


