import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.lightBlue, // Fondo celeste
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Text(
                'Sidebar Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                // Acción al seleccionar perfil
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
              leading: Icon(Icons.logout), // Icono para cerrar sesión
              title: Text('Cerrar Sesión'),
              onTap: () async {
                // Acción al seleccionar cerrar sesión
                try {
                  await FirebaseAuth.instance.signOut(); // Cierra sesión con Firebase
                  // Redirige a la pantalla de inicio de sesión o a donde desees
                } catch (e) {
                  print('Error al cerrar sesión: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// El resto del código permanece igual
