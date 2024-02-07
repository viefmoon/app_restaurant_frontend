import 'package:ecommerce_flutter/src/domain/models/Role.dart';

class User {
  int? id;
  String name;
  String username;
  String? password;
  String? notificationToken;
  List<Role>? roles;

  User({
    this.id,
    required this.name,
    required this.username,
    this.password,
    this.notificationToken,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"],
        username: json["username"],
        password: json["password"] ?? '',
        notificationToken: json["notification_token"] ?? '',
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "password": password,
        "notification_token": notificationToken,
        "roles": roles != null
            ? List<dynamic>.from(roles!.map((x) => x.toJson()))
            : [],
      };
}
