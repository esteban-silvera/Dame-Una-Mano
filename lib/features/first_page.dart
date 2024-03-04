import 'dart:async';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
import 'package:dame_una_mano/features/authentication/screens/login_screen.dart';
import 'package:dame_una_mano/features/authentication/widgets/costum_text.dart';
import 'package:dame_una_mano/features/authentication/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late String imageUrl;
  bool isLoading =
      true; // Variable para controlar si la imagen se está cargando

  @override
  void initState() {
    super.initState();
    // Obtener la URL de la imagen desde Firebase Storage
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
    try {
      // Obtener la URL de la imagen desde Firebase Storage
      String imagePath = 'images/fondo2.jpg';
      imageUrl = await StorageService.getImageUrl(imagePath);
      setState(() {
        isLoading =
            false; // La imagen se ha cargado, establecer isLoading a false
      });
    } catch (error) {
      // Manejar cualquier error que pueda ocurrir al obtener la URL de la imagen
      print('Error al obtener la URL de la imagen: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Mostrar la imagen si isLoading es false
            if (!isLoading)
              Container(
                decoration: BoxDecoration(
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                              imageUrl), // Cargar la imagen desde la URL
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            // Mostrar el círculo si isLoading es true
            if (isLoading)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: const CircularProgressIndicator(), // Indicador de carga
              ),
            // Resto de tu contenido aquí
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 200, 10, 10),
                      child: Text(
                        'Dame una mano',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 10, 10, 10),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.handshake_rounded,
                      size: 80,
                      color: Color(0xFFFA7701),
                    ),
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 223, 223, 223)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 215, 215, 215)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              onLogin: (String email, String password) {},
                            ),
                          ),
                        );
                      },
                      child: const CustomText(
                        text: "Iniciar sesión o registrarte",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF43c7ff),
                        // Agregar estilo personalizado si es necesario
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
