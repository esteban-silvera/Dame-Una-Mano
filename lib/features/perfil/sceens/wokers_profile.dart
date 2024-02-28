import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WorkerProfileScreen extends StatelessWidget {
  final String workerId;

  WorkerProfileScreen({required this.workerId});

  Future<double> averageRating(List<double> ratings) async {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onProfilePressed: () {
          // Acción al presionar el icono de perfil
        },
        onNotificationPressed: () {
          // Acción al presionar el icono de notificaciones
        },
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Aquí se coloca la imagen de portada
            Container(
              height: 200, // Altura de la imagen de portada
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/portada.jpg'), // Cambia por la ruta de tu imagen
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 150), // Espacio para la imagen de portada
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('professionals')
                        .doc(workerId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar los datos del trabajador');
                      }

                      var workerData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      var name = workerData['name'] ?? 'Nombre no disponible';
                      var lastname =
                          workerData['lastname'] ?? 'Apellido no disponible';
                      var job = workerData['job'] ?? 'Profesión no disponible';
                      var description = workerData['description'] ??
                          'Descripción no disponible';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 21, 199, 239),
                                width: 4,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '$name $lastname', // Mostrar apellido
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            description,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('professionals')
                                .doc(workerId)
                                .collection('ratings')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text(
                                    'Error al cargar los datos del trabajador');
                              }

                              var ratings = snapshot.data!.docs
                                  .map((doc) => doc["rating"] as double)
                                  .toList();

                              double averageRating = ratings.isEmpty
                                  ? 0.0
                                  : ratings.reduce((a, b) => a + b) /
                                      ratings.length;

                              return Column(
                                children: [
                                  // Utilizamos RatingBarIndicator
                                  RatingBarIndicator(
                                    rating: averageRating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Color(0xFFFA7701),
                                    ),
                                    itemCount: 5,
                                    itemSize: 50.0,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Promedio de calificación: ${averageRating.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
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

  // Método para lanzar el enlace de WhatsApp
  _launchWhatsApp() async {
    // Reemplaza 'NUMERO_DE_TELEFONO' con el número de teléfono al que deseas enviar el mensaje
    String phoneNumber = '09199999';
    String message = 'Hola, quiero contactarte.';
    String url = 'https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}';
    {
      throw 'No se pudo abrir $url';
    }
  }
}
