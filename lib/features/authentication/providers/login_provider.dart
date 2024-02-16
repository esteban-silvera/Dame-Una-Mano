import 'dart:convert';

import 'package:dame_una_mano/features/authentication/data/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    print("iniciando loginProvider");
  }
  Future<User?> loginUsuario(Map<String, String> formData) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9qvrnsVxG7t_3unWiOG3OOZN0qwGbOFE');

    var response = await http.post(url, body: jsonEncode(formData));

    if (response.statusCode == 200) {
      var usuario = User.fromJson(jsonDecode(response.body));
      var urlDB = Uri.parse(
          'https://dame-una-mano-411922-default-rtdb.firebaseio.com/' +
              usuario.localId! +
              '.json');
      var responseDB = await http.get(urlDB);
      if (responseDB.statusCode == 200) {
        usuario.setUserData(jsonDecode(responseDB.body));
        return usuario; // Devuelve el usuario si la autenticación y recuperación de datos son exitosas
      }
    }
    return null;
  }
}
