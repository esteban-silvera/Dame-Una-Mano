import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:flutter/material.dart';

class WorkersProfileScreen extends StatelessWidget {
  final String workerName;

  WorkersProfileScreen({required this.workerName});

  // Método para lanzar el enlace de WhatsApp
  _launchWhatsApp() async {
    // Reemplaza 'NUMERO_DE_TELEFONO' con el número de teléfono al que deseas enviar el mensaje
    String phoneNumber = '091783669';
    String message = 'Hola, quiero contactarte.';
    String url = 'https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}';
    {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5f5f5),
      appBar: CustomAppBar(
        onProfilePressed: () {
          // Acción al presionar el icono de perfil
        },
        onNotificationPressed: () {
          // Acción al presionar el icono de notificaciones
        },
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('professionals')
            .where('name', isEqualTo: workerName)
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el perfil del trabajador'),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Trabajador no encontrado'),
            );
          }

          var workerData = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://www.example.com/default_profile_image.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${workerData['name']} ${workerData['lastname']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildUserInfo(
                    title: '',
                    value: workerData['Descripcion'] ??
                        'Descripcion no disponible',
                  ),
                  SizedBox(height: 20),
                  _buildUserInfo(
                    title: 'Oficio:',
                    value: workerData['job'] ?? 'Oficio no disponible',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _launchWhatsApp,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.message), // Icono de WhatsApp
                        SizedBox(
                            width: 10), // Espacio entre el icono y el texto
                        Text('Contáctame'),
                      ],
                    ),
                  ),
                ],
              ),
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
}
