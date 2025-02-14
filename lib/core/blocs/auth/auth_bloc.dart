import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/core/blocs/auth/auth_state.dart';
import 'package:gaijingo/core/singletones/db_connection_singleton.dart';
import 'package:gaijingo/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DBConectionSingleton dbConection = DBConectionSingleton();
  late final Account account;
  AuthBloc() : super(const AuthState.unknown()) {
    account = dbConection.account;

    on<AuthSuccessEvent>((event, emit) async {
      print('AUTHSUCCESSEVENT:');
      emit(const AuthState.authenticated());
    });

    on<AuthLoggedOutEvent>((event, emit) async {
      print('AUTHLOGGEDOUTEVENT: ');
      emit(const AuthState.logout());
    });

    on<AuthUnauthenticatedEvent>((event, emit) async {
      print('AUTHUNAUTHENTICATEDEVENT:');
      emit(const AuthState.unauthenticated());
    });

    on<NetworkErrorEvent>((event, emit) async {
      print('NETWORKERROREVENT:');
      emit(AuthState.networkError(event.error));
    });

    on<AuthInitialEvent>((event, emit) async {
      print('AUTHINITIALEVENT:');
      emit(const AuthState.unknown());
      getUser();
    });

    on<AuthLoginSuccessEvent>((event, emit) async {
      print('AUTHLOGINSUCCESSEVENT:');
      emit(const AuthState.authenticated());
    });

    // on<NoProtocolEvent>((event, emit) async {
    //   emit(AuthState.noProtocol());
    // });
  }

  void getUser() async {
    UserService userService = UserService();
    try {
     User? currentUser =  await userService.getCurrentUser;

      if (currentUser == null) {
        print('CURRENTUSER: ${currentUser}');
        add(AuthUnauthenticatedEvent());
        return;
      }
        add(AuthSuccessEvent());
      
    } catch (e) {
      log('GET USER ${e.toString()}');
    }
  }
}
