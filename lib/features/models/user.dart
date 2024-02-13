// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? kind; //Diferenciar tipo de usuario, administrador, trabajadora
  String? idToken;
  String? email;
  String?
      refreshToken; //se utiliza para obtener un nuevo token de acceso una vez que el actual caduca
  String?
      expiresIn; //This information is important for handling token expiration and refreshing mechanisms.
  String? localId;
  String? name;
  String? lastname;
  String? image;

  setUserData(Map<String, dynamic> json) {
    name = json['name'];
    lastname = json['lastname'];
    image = json['image'];
    email = json['email'];
  }

  User({
    required this.kind,
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        kind: json["kind"],
        idToken: json["idToken"],
        email: json["email"],
        refreshToken: json["refreshToken"],
        expiresIn: json["expiresIn"],
        localId: json["localId"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "idToken": idToken,
        "email": email,
        "refreshToken": refreshToken,
        "expiresIn": expiresIn,
        "localId": localId,
      };
}
