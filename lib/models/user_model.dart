import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String? avatarImage;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.avatarImage});

  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarImage: map['avatarImage'],
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarImage': avatarImage,
    };
  }

    static Map<String, dynamic> stringToMap(String s) {
    Map<String, dynamic> map = json.decode(s);
    return map;
  }
}
