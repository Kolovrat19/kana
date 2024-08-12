import 'dart:convert';

class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String? avatarImage;
  UserModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      this.avatarImage});

  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map["id"],
      name: map["name"],
      phone: map["phone"],
      email: map["email"],
      avatarImage: map["avatarImage"],
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatarImage': avatarImage,
    };
  }

    static Map<String, dynamic> stringToMap(String s) {
    Map<String, dynamic> map = json.decode(s);
    return map;
  }
}
