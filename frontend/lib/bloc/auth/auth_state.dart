part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends AuthState{
  @override
  List<Object> get props => [];
}
class RegisterFail extends AuthState{
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {

  @override
  List<Object> get props => [];
}

class AuthUnauthenticated extends AuthState {

  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {

  @override
  List<Object> get props => [];
}

