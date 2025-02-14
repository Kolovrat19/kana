import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/models/user_model.dart';
import 'package:gaijingo/core/singletones/db_connection_singleton.dart';
import 'package:gaijingo/services/db_error_handler_service.dart';
import 'package:gaijingo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  DBConectionSingleton dbConection = DBConectionSingleton();

  late final Account account;
  UserService() {
    account = dbConection.account;
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      User newUser = await account.create(
          userId: ID.unique(), email: email, password: password, name: name);
      await account.createEmailPasswordSession(
          email: email.toString(), password: password.toString());
      UserModel userModel =
          UserModel(id: newUser.$id, name: name, email: email);
      await setUserToDb(userModel);
      await setUserToLocalStorage(userModel);
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.message.toString());
      log('MESSAGE ${e.message.toString()}');
      log('CODE ${e.code.toString()}');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      final Session session = await account.createEmailPasswordSession(
          email: email, password: password);
      final String currentUserId = session.userId;
      print('CURRENTUSERID: ${currentUserId}');

      final UserModel? userModel = await getUserFromDb(currentUserId);
      // if (userModel != null) {
      //   _userService.addUserToStorage(userModel);
      //   userEvent.add(userModel);
      //   // _routerBloc.routerEvent.add(AuthStatus.authenticated);
      // }
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
    }
  }

  Future<User?> get getCurrentUser async {
    try {
      User user = await account.get();
      return user;
    } on AppwriteException catch (e) {
      log('CURRENT NOT FOUND ${e.code.toString()}');
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      // await updateUserInDb(userModel);
      // await _userService.removeUserFromStorage();

      await dbConection.account.deleteSession(sessionId: 'current');
      // _routerBloc.routerEvent.add(AuthStatus.unauthenticated);
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log('LOGOUT ${e.code.toString()}');
    }
  }

  Future<Document?> setUserToDb(UserModel userModel) async {
    try {
      final document = dbConection.database.createDocument(
          databaseId: dotenv.get('APPWRITE_DATABASE_ID'),
          collectionId: dotenv.get('APPWRITE_USERS_COLLECTION_ID'),
          documentId: ID.unique(),
          data: userModel.toMap(),
          permissions: [Permission.read(Role.user(userModel.id))]);
      return document;
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
    }
    return null;
  }

  Future<Document?> updateUserInDb(UserModel userModel) async {
    try {
      final result = await dbConection.database.updateDocument(
        databaseId: dotenv.get('APPWRITE_DATABASE_ID'),
        collectionId: dotenv.get('APPWRITE_USERS_COLLECTION_ID'),
        documentId: userModel.id,
        data: userModel.toMap(),
        permissions: [
          Permission.update(Role.user(userModel.id)),
        ],
      );
      return result;
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
    }
    return null;
  }

  Future<UserModel?> getUserFromDb(String id) async {
    try {
      final data = await dbConection.database.getDocument(
        databaseId: dotenv.get('APPWRITE_DATABASE_ID'),
        collectionId: dotenv.get('APPWRITE_USERS_COLLECTION_ID'),
        documentId: id,
      );
      return UserModel.fromJson(data.data);
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
      log(e.message.toString());
    }
    return null;
  }

  Future<UserModel?> getUserFromLocalStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final user = preferences.getString(Constants.USER_STORAGE);
    if (user != null) {
      UserModel userFromStorage =
          UserModel.fromJson(UserModel.stringToMap(user.toString()));
      return userFromStorage;
    }
    return null;
  }

  Future setUserToLocalStorage(UserModel userModel) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        Constants.USER_STORAGE,
        json.encode(userModel.toMap()),
      );
      final user = await getUserFromLocalStorage();
      print('USER: ${user!.email.toString()}');
    } catch (ex) {
      throw ('Error in LocalStorage $ex');
    }
  }

  Future<void> removeUserFromLocalStorage() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(Constants.USER_STORAGE);
    } catch (ex) {
      throw ('Error in SetCardStorage $ex');
    }
  }
}
