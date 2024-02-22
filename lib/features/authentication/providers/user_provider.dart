import 'dart:convert';

import 'package:dame_una_mano/features/authentication/data/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  late User _user;

  UserProvider() {
    _user = User(); // O cualquier valor predeterminado que desees
  }

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> updateUsuario(Map<String, String> formData) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9qvrnsVxG7t_3unWiOG3OOZN0qwGbOFE');

    var response = await http.post(url, body: jsonEncode(formData));

    if (response.statusCode == 200) {
      var usuario = User.fromJson(jsonDecode(response.body));
      var urlDB = Uri.parse(
          'https://dame-una-mano-411922-default-rtdb.firebaseio.com/users/${usuario.localId}.json');
      var responseDb = await http.put(urlDB,
          body: jsonEncode({
            'name': formData['name'],
            'lastname': formData['lastname'],
            'email': formData['email'],
            'description': formData['description'],
            'department': formData['department'],
            'barrio': formData['barrio'],
            'job': formData['job'],
          }));
      if (responseDb.statusCode == 200) {
        user.setUserData(jsonDecode(responseDb.body));
        notifyListeners();
        return true;
      } else {
        // Manejar el error de la base de datos
        print('Error en la base de datos: ${responseDb.statusCode}');
        return false;
      }
    } else {
      // Manejar el error de autenticación
      print('Error de autenticación: ${response.statusCode}');
      return false;
    }
  }
}
