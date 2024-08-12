import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

// class NoProtocolEvent extends AuthEvent {}

class AuthSuccessEvent extends AuthEvent {}

class AuthUnauthenticatedEvent extends AuthEvent {}

class AuthLoggedOutEvent extends AuthEvent {}

class NetworkErrorEvent extends AuthEvent {
  final String error;

  const NetworkErrorEvent(this.error);
  @override
  List<Object> get props => [error];
}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginSuccessEvent extends AuthEvent {}