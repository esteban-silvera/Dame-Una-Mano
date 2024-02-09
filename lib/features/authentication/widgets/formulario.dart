import 'package:flutter/material.dart';

class AuthenticationForm extends StatelessWidget {
  final String title;
  final String buttonText;
  final Function(String, String) onSubmit;
  final bool showAdditionalFields;

  const AuthenticationForm({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    this.showAdditionalFields = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            if (showAdditionalFields)
              ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Apellido'),
                ),
              ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSubmit('correo', 'contrasena');
              },
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

