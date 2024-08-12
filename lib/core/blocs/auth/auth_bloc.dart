import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana/core/blocs/auth/auth_event.dart';
import 'package:kana/core/blocs/auth/auth_state.dart';
import 'package:kana/services/db_connection_singleton.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DBConectionSingleton dbConection = DBConectionSingleton();
  late final Account account;
  AuthBloc() : super(const AuthState.unknown()) {
    account = dbConection.account;

    on<AuthSuccessEvent>((event, emit) async {
      emit(const AuthState.authenticated());
    });

    on<AuthLoggedOutEvent>((event, emit) async {
      emit(const AuthState.logout());
    });

    on<AuthUnauthenticatedEvent>((event, emit) async {
      emit(const AuthState.unauthenticated());
    });

    on<NetworkErrorEvent>((event, emit) async {
      emit(AuthState.networkError(event.error));
    });

    on<AuthInitialEvent>((event, emit) async {
      emit(const AuthState.authLoading());
      // getUser();
    });

    on<AuthLoginSuccessEvent>((event, emit) async {
      emit(const AuthState.authenticated());
    });

    // on<NoProtocolEvent>((event, emit) async {
    //   emit(AuthState.noProtocol());
    // });
  }

  // void getUser() async {
  //   var protocol = await SecureStorageManager.isStudyProtocolAvailable();
  //   if (!protocol) {
  //     add(NoProtocolEvent());
  //     return;
  //   }
  //   try {
  //     final isSignedInUser = await ExternalStore.concrete.isSignedIn();
  //     if (isSignedInUser) {
  //       add(AuthSuccessEvent());
  //       return;
  //     }
  //     add(AuthUnauthenticatedEvent());
  //   } catch (e) {
  //     add(NetworkErrorEvent(e.toString()));
  //   }
  // }
}
