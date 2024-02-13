import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
import 'package:dame_una_mano/features/authentication/screens/login_screen.dart';
import 'package:dame_una_mano/features/authentication/widgets/costum_text.dart';
import 'package:dame_una_mano/features/utils/custom_button.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: StorageService.getImageUrl('images/fondo2.jpg'),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data; // Obtén la URL de la imagen, puede ser null si aún no se ha cargado

        return Container(
          decoration: BoxDecoration(
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl), // Utiliza la URL para cargar la imagen desde la red
                    fit: BoxFit.cover,
                  )
                : null, // No aplicar imagen si la URL es null
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
                      size: 64,
                      color: Color(0xFFFA7701),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 100, 10, 1),
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
                        child: CustomButton(
                          text: "¿Qué estás buscando?",
                          icon: const Icon(Icons.search),
                          color: const Color(0xFF43c7ff),
                          fontSize: 24,
                          onPressed: () {
                            // Agregar lógica para el botón de búsqueda aquí
                          },
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
                      child: CustomButton(
                        text: "Ofrezco servicio",
                        color: const Color.fromARGB(128, 67, 199, 255),
                        fontSize: 18,
                        onPressed: () {
                          // Agregar lógica para el botón de oferta de servicio aquí
                        },
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
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF43c7ff),
                        // Agregar estilo personalizado si es necesario
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
