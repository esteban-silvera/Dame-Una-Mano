import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:dame_una_mano/features/authentication/screens/perfil_edit_screen.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserworkerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5f5f5),
      appBar: CustomAppBar(
        onProfilePressed: () {
          // Acción al presionar el icono de perfil
        },
        onNotificationPressed: () {
          // Acción al presionar el icono de notificaciones
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centrar horizontalmente
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userProvider.user.image ??
                  'https://www.example.com/default_profile_image.jpg'),
            ),
            _buildUserInfo(
              title: 'Nombre:',
              value: userProvider.user.name ?? 'Nombre no disponible',
            ),
            SizedBox(height: 10),
            _buildUserInfo(
              title: 'Apellido:',
              value: userProvider.user.lastname ?? 'Apellido no disponible',
            ),
            SizedBox(height: 10),
            _buildUserInfo(
              title: 'Email:',
              value: userProvider.user.email ?? 'Email no disponible',
            ),
            SizedBox(height: 20),
            _buildUserInfo(
              title: 'Descripción:',
              value:
                  userProvider.user.description ?? 'Descripción no disponible',
            ),
            SizedBox(height: 10),
            _buildUserInfo(
              title: 'Departamento:',
              value:
                  userProvider.user.department ?? 'Departamento no disponible',
            ),
            SizedBox(height: 10),
            _buildUserInfo(
              title: 'Barrio:',
              value: userProvider.user.barrio ?? 'Barrio no disponible',
            ),
            SizedBox(height: 10),
            _buildUserInfo(
              title: 'Trabajo:',
              value: userProvider.user.job ?? 'Trabajo no disponible',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementa la lógica para editar el perfil aquí
                _navigateToEditProfileScreen(context);
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 250, 249, 249),
                ),
                backgroundColor: const Color(0xFFFA7701),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo({required String title, required String value}) {
    return Container(
      width: double.infinity, // Para que ocupe todo el ancho
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF43c7ff)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfileScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(),
      ),
    );
  }
}
