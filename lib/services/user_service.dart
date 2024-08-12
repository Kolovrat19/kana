import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:kana/models/user_model.dart';
import 'package:kana/services/db_connection_singleton.dart';
import 'package:kana/services/db_error_handler_service.dart';
import 'package:kana/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  DBConectionSingleton dbConection = DBConectionSingleton();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // AuthBloc authBloc = BlocProvider.getBloc<AuthBloc>();

  Future<Document?> addUserToDb(UserModel userModel) async {
    try {
      Document result = await dbConection.database.createDocument(
          databaseId: Constants.databaseId,
          collectionId: Constants.usersCollection,
          documentId: userModel.id,
          data: userModel.toMap(),
          permissions: [
            Permission.read(Role.any()),
            Permission.read(Role.user(userModel.id))
          ]);
      return result;
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
    }
    return null;
  }

  Future<Document?> updateUserInDb(UserModel userModel) async {
    try {
      Document result = await dbConection.database.updateDocument(
          databaseId: Constants.databaseId,
          collectionId: Constants.usersCollection,
          documentId: userModel.id,
          data: userModel.toMap(),
          permissions: [
            Permission.read(Role.any()),
            Permission.read(Role.user(userModel.id))
          ]);
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
          databaseId: Constants.databaseId,
          collectionId: Constants.usersCollection,
          documentId: id);
      return UserModel.fromJson(data.data);
    } on AppwriteException catch (e) {
      DatabaseErrorHandler.errorHandler(e.code.toString());
      log(e.code.toString());
      log(e.message.toString());
    }
    return null;
  }

  Future<UserModel?> getUserFromStorage() async {
    final SharedPreferences prefs = await _prefs;

    final user = prefs.getString('user');
    if (user != null) {
      UserModel userFromStorage =
          UserModel.fromJson(UserModel.stringToMap(user.toString()));
      return userFromStorage;
    }
    return null;
  }

  Future addUserToStorage(UserModel userModel) async {
    try {
      final SharedPreferences prefs = await _prefs;
      await prefs.setString('user', json.encode(userModel.toMap()));
    } catch (ex) {
      throw ('Error in SetCardStorage $ex');
    }
  }

  Future<void> removeUserFromStorage() async {
    try {
      final SharedPreferences prefs = await _prefs;
      await prefs.remove('user');
    } catch (ex) {
      throw ('Error in SetCardStorage $ex');
    }
  }
}
