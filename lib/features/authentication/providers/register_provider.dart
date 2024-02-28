import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dame_una_mano/features/authentication/data/user.dart';
//import '../models/user.dart';

class RegisterProvider extends ChangeNotifier {
  RegisterProvider() {
    print("Iniciando RegisterProvider");
  }

  Future<bool> registrarUsuario(Map<String, String> formData) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9qvrnsVxG7t_3unWiOG3OOZN0qwGbOFE');

    var response = await http.post(url, body: jsonEncode(formData));
    if (response.statusCode == 200) {
      var usuario = User.fromJson(jsonDecode(response.body));
      print(usuario.localId);

      // Guardar datos del usuario en Firestore
      var firestoreUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/dame-una-mano-411922/databases/(default)/documents/Users/${usuario.localId}');

      var firestoreResponse = await http.patch(
        firestoreUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'fields': {
            'name': {'stringValue': formData['name']},
            'lastname': {'stringValue': formData['lastname']},
            'email': {'stringValue': formData['email']},
          }
        }),
      );

      if (firestoreResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
