import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dame_una_mano/features/authentication/data/user.dart';
//import '../models/user.dart';

class RegisterProvider extends ChangeNotifier {
  RegisterProvider() {
    print("iniciando registerProvider");
  }

  Future<bool> registrarUsuario(Map<String, String> formData) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9qvrnsVxG7t_3unWiOG3OOZN0qwGbOFE');

    var response = await http.post(url, body: jsonEncode(formData));
    if (response.statusCode == 200) {
      var usuario = User.fromJson(jsonDecode(response.body));
      print(usuario.localId);
      var urlDB = Uri.parse(
          'https://dame-una-mano-411922-default-rtdb.firebaseio.com/${usuario.localId!}.json');
      var responseDb = await http.put(
        urlDB,
        body: jsonEncode(
            {'name': formData['name'], 'lastname': formData['lastname']}),
      );
      if (responseDb.statusCode == 200) {
        // Aquí se verifica que código de estado de la respuesta de la base de datos
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
