// To parse this JSON data, do
//
//final worker = userFromJson(jsonString);

import 'dart:convert';

enum JobType {
  albanil,
  carpintero,
  electricista,
  jardinero,
  mecanico,
  plomero,
}

Worker workerFromJson(String str) => Worker.fromJson(json.decode(str));

String workerToJson(Worker data) => json.encode(data.toJson());

class Worker {
  String? kind;
  String? idToken;
  String? email;
  String? refreshToken;
  String? expiresIn;
  String? localId;
  String? name;
  String? lastname;
  String? image;
  String? dept;
  String? ciudad;
  String? barrio;
  String? jobType;

  setUserData(Map<String, dynamic> json) {
    name = json['name'];
    lastname = json['lastname'];
    image = json['image'];
    email = json['email'];
  }

  Worker({
    required this.kind,
    required this.name,
    required this.lastname,
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
    required this.dept,
    required this.ciudad,
    required this.barrio,
    required this.jobType,
    required this.image,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        kind: json["kind"],
        idToken: json["idToken"],
        email: json["email"],
        refreshToken: json["refreshToken"],
        expiresIn: json["expiresIn"],
        localId: json["localId"],
        dept: json["dept"],
        ciudad: json["ciudad"],
        barrio: json["barrio"],
        jobType: json["jobType"],
        name: json["name"],
        lastname: json["lastname"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "idToken": idToken,
        "email": email,
        "refreshToken": refreshToken,
        "expiresIn": expiresIn,
        "localId": localId,
        "dept": dept,
        "ciudad": ciudad,
        "barrio": barrio,
        "jobType": jobType,
        "name": name,
        "lastname": lastname,
        "image": image,
      };
}
