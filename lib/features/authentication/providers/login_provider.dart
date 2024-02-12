import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    print("iniciando loginProvider");
  }
  Future<bool> loginUsuario(Map<String, String> formData) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9qvrnsVxG7t_3unWiOG3OOZN0qwGbOFE');

    var response = await http.post(url, body: jsonEncode(formData));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
