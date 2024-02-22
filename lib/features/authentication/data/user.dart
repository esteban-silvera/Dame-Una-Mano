// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? kind;
  String? idToken;
  String? email;
  String? refreshToken;
  String? expiresIn;
  String? localId;
  String? name;
  String? lastname;
  String? image;
  String? description;
  String? department;
  String? barrio;
  String? job;

  void setUserData(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    lastname = json['lastname'] ?? '';
    image = json['image'] ?? '';
    email = json['email'] ?? '';
    description = json['description'] ?? '';
    department = json['department'] ?? '';

    // Asegurémonos de que "barrio" sea un mapa antes de asignarlo
    if (json['barrio'] is Map<String, dynamic>) {
      barrio = json['barrio']
          .toString(); // Convertir el mapa a una representación de cadena
    } else {
      // Si "barrio" no es un mapa, asignamos directamente
      barrio = json['barrio'] ?? '';
    }

    job = json['job'] ?? '';
  }

  User({
    this.kind,
    this.idToken,
    this.email,
    this.refreshToken,
    this.expiresIn,
    this.localId,
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
