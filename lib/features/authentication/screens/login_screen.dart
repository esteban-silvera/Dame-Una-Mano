import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
import 'package:dame_una_mano/features/authentication/widgets/formulario.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password) onLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    imageUrl = await StorageService.getImageUrl('images/fondo2.jpg');
    if (mounted) {
      setState(() {}); // Actualiza el estado para reconstruir el widget con la nueva imagen cargada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Cambia el color de fondo según tus preferencias
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!), // Utiliza la URL para cargar la imagen desde la red
                fit: BoxFit.cover,
              )
            : null,
      ),
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
                      fontFamily: 'Monserrat',
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
                  onLogin: widget.onLogin,
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
