import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  logout,
  error,
  // loading,
  // noProtocol,
  networkError
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.initial,
    this.error = '',
    this.networkError = '',
  });
  const AuthState.unknown() : this._();
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.logout() : this._(status: AuthStatus.logout);

  // const AuthState.authLoading() : this._(status: AuthStatus.loading);
  // const AuthState.noProtocol() : this._(status: AuthStatus.noProtocol);
  const AuthState.networkError(String networkError)
      : this._(status: AuthStatus.networkError, networkError: networkError);

  const AuthState.error(String error)
      : this._(status: AuthStatus.error, error: error);

  final AuthStatus status;
  final String error;
  final String networkError;

  @override
  List<Object> get props => [status, error, networkError];
}
