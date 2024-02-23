import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileProvider extends ChangeNotifier {
  Future<bool> updateUserProfile(
      Map<String, String> formData, String localId) async {
    var url = Uri.parse(
        'https://dame-una-mano-411922-default-rtdb.firebaseio.com/users/$localId.json');

    var response = await http.patch(url, body: jsonEncode(formData));

    if (response.statusCode == 200) {
      // Si la actualización se realizó con éxito, notificamos a los listeners
      notifyListeners();
      return true;
    } else {
      // Si hubo un error, devolvemos false
      return false;
    }
  }
}
