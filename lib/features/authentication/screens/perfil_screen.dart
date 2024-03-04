//import 'package:dame_una_mano/features/authentication/providers/user_provider.dart';
//import 'package:dame_una_mano/features/authentication/widgets/app_dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:dame_una_mano/features/authentication/screens/perfil_edit_screen.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5f5f5),
      drawer: Sidebar(),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(userProvider.user
                .localId) // Suponiendo que userProvider.user.id contiene el ID del usuario
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Error al cargar el perfil del usuario'),
            );
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['image'] ??
                      'https://www.example.com/default_profile_image.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  '${userData['name']} ${userData['lastname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildUserInfo(
                  title: '',
                  value: userData['description'] ?? 'Descripción no disponible',
                ),
                SizedBox(height: 10),
                _buildUserInfo(
                  title: 'Email:',
                  value: userData['email'] ?? 'Email no disponible',
                ),
                SizedBox(height: 10),
                _buildUserInfo(
                  title: 'Trabajo:',
                  value: userData['job'] ?? 'Trabajo no disponible',
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
          );
        },
      ),
    );
  }

  Widget _buildUserInfo({required String title, required String value}) {
    return Container(
      width: double.infinity,
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
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(),
        ),
      );
    });
  }

  Widget _buildCenteredUserInfo(
      {required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF43c7ff)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          // RichText para combinar el nombre y el apellido y centrarlo
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
