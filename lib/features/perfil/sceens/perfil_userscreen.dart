import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  // Mapa que asocia nombres de usuario con nombres de archivo de imágenes de perfil
  final Map<String, String> profileImages = {
    'sebastian judini': 'sebastian_judini.png',
    'emilio herrera': 'emilio_herrera.png',
    'nico torrez': 'nico_torrez.png',
    'lucia lopez': 'lucia_lopez.png',
  };

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
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(userProvider.user.localId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 21, 199, 239),
              ),
            );
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Error al cargar el perfil del usuario'),
            );
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // Obtener el nombre de usuario y buscar su imagen de perfil correspondiente en el mapa
          String username = userData['username'] ?? '';
          String profileImageAsset = profileImages[username] ?? 'default.jpg';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF43c7ff),
                      width: 4,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    // Usar la imagen de perfil del activo correspondiente al nombre de usuario
                    backgroundImage: AssetImage('assets/$profileImageAsset'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '${userData['name']} ${userData['lastname']} - Clasificaciones: ${userData['ratings'] ?? 0}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  userData['description'] ?? 'Descripción no disponible',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
