import 'package:dame_una_mano/features/authentication/screens/perfil_screen.dart';
import 'package:dame_una_mano/features/first_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa la primera pantalla

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.lightBlue, // Fondo celeste
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Dame una mano', // Texto modificado
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Perfil'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configuración'),
                    onTap: () {
                      // Acción al seleccionar configuración
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                    onTap: () {
                      // Acción al seleccionar sobre nosotros
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Cerrar Sesión'),
                    onTap: () async {
                      // Acción al seleccionar cerrar sesión
                      try {
                        await FirebaseAuth.instance
                            .signOut(); // Cierra sesión con Firebase
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FirstScreen()), // Lleva a la pantalla de inicio
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
