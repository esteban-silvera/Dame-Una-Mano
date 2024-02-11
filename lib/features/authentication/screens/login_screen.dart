import 'package:dame_una_mano/features/authentication/widgets/formulario.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final void Function(String email, String password) onLogin;

  const LoginScreen({
    Key? key,
    required this.onLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo2.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: Text(
                    'Dame una mano',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 10, 10, 10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.handshake_rounded,
                  size: 64,
                  color: Color(0xFFFA7701),
                ),
                const SizedBox(height: 20),
                AuthenticationTabs(
                  onLogin: onLogin,
                  isLoginForm: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
