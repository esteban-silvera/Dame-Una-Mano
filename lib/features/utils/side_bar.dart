import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:dame_una_mano/features/first_page.dart';
import 'package:dame_una_mano/features/home_page/screens/home_screen1.dart';
import 'package:dame_una_mano/features/perfil/screens/perfil_userscreen.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xf1f1f1f1),
        child: Column(
          children: [
            Container(
              height: 100,
              color: const Color(0xFF43c7ff), // Fondo celeste
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dame una mano',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "Monserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.handshake,
                    color: Color.fromARGB(255, 249, 249, 249),
                    size: 24,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About Us'),
                    onTap: () {
                      // Acción al seleccionar sobre nosotros
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar Sesión'),
                    onTap: () async {
                      // Acción al seleccionar cerrar sesión
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstScreen(),
                          ),
                        );
                      } catch (e) {
                        print('Error al cerrar sesión: $e');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
