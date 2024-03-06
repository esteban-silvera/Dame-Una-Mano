import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
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
      backgroundColor: const Color(0xf1f1f1f1),
      appBar: AppBar(
        backgroundColor: const Color(0xff43c7ff).withOpacity(0.9),
        title: const Text(
          "Perfil",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      drawer: Sidebar(),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(userProvider.user.localId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF43c7ff).withOpacity(0.8),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Error al cargar el perfil del usuario'),
            );
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String username = userData['name'] ?? '';
          String profileImageAsset = profileImages[username] ?? 'default.jpg';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF43c7ff),
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/$profileImageAsset'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${userData['name']} ${userData['lastname']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${userData['email']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userProvider.user.localId)
                      .collection('ratings')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Color(0xFF43c7ff).withOpacity(0.7),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('No hay calificaciones');
                    }
                    var ratings = snapshot.data!.docs.length;
                    return Text(
                      'Calificaciones hechas por el usuario: $ratings',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
