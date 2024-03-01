import 'dart:async';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
import 'package:dame_una_mano/features/authentication/screens/login_screen.dart';
import 'package:dame_una_mano/features/authentication/widgets/costum_text.dart';
import 'package:dame_una_mano/features/authentication/widgets/custom_button.dart';
import 'package:dame_una_mano/features/pruebatitulo.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late String imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
    try {
      String imagePath = 'images/fondo2.jpg';
      imageUrl = await StorageService.getImageUrl(imagePath);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error al obtener la URL de la imagen: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!isLoading)
              Container(
                decoration: BoxDecoration(
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            if (isLoading)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: const CircularProgressIndicator(
                  color: Color(0xFF43c7ff),
                ),
              ),
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 200, 10, 10),
                      child: AnimatedTextWidget(),
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
                          onPressed: () {},
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
                        color: Color.fromARGB(255, 243, 149, 33),
                        fontSize: 18,
                        onPressed: () {},
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
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: 1.0,
              child: Icon(
                Icons.handshake_rounded,
                size: 64,
                color: Color(0xFFFA7701),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
