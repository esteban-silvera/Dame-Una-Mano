import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerProfileScreen extends StatelessWidget {
  final String workerId;
  final String userId; // ID del usuario que califica al trabajador

  WorkerProfileScreen({required this.workerId, required this.userId});

  Future<double> averageRating(List<double> ratings) async {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  final Map<String, String> profileImages = {
    'sebastian judini': 'sebastian_judini.png',
    'emilio herrera': 'emilio_herrera.png',
    'nico torrez': 'nico_torrez.png',
    'lucia lopez': 'lucia_lopez.png',
    'daniela rojas': 'danielamecanica.jpg'
    // Agrega más nombres de usuario y nombres de archivo de imágenes de perfil según sea necesario
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Trabajador'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aquí se coloca la imagen de portada
              Stack(
                children: [
                  Container(
                    height: 200, // Altura de la imagen de portada
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/portada.jpg'), // Ruta de la imagen de portada
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Widget de foto de perfil superpuesto con borde celeste
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
                      var name = workerData['name'] ?? 'Nombre no encontrado';
                      var lastname =
                          workerData['lastname'] ?? 'Apellido no encontrado';

                      // Obtener el nombre de archivo de la imagen de perfil desde el mapa
                      String profileImageName = '$name $lastname'.toLowerCase();
                      String profileImagePath =
                          profileImages.containsKey(profileImageName)
                              ? 'assets/${profileImages[profileImageName]}'
                              : 'assets/default_profile.png';

                      return Positioned(
                        top: 100, // Ajusta según la posición deseada
                        left: MediaQuery.of(context).size.width / 2 -
                            60, // Ajusta según la posición deseada
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF15C7EF), // Color celeste
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            // Usar AssetImage para cargar la imagen desde los activos
                            backgroundImage: AssetImage(profileImagePath),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
                  var name = workerData['name'] ?? 'Nombre no encontrado';
                  var lastname =
                      workerData['lastname'] ?? 'Apellido no encontrado';
                  var description =
                      workerData['description'] ?? 'Descripción no disponible';

                  // Obtener el nombre de archivo de la imagen de perfil desde el mapa
                  String profileImageName = '$name $lastname'.toLowerCase();
                  String profileImagePath =
                      profileImages.containsKey(profileImageName)
                          ? 'assets/${profileImages[profileImageName]}'
                          : 'assets/default_profile.png';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height:
                              20), // Espacio para separar la foto de perfil de los demás elementos
                      Text(
                        '$name $lastname',
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
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('professionals')
                    .doc(workerId)
                    .collection('ratings')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error al cargar los datos del trabajador');
                  }

                  var ratings = snapshot.data!.docs
                      .map((doc) => doc["rating"] as double)
                      .toList();

                  double averageRating = ratings.isEmpty
                      ? 0.0
                      : ratings.reduce((a, b) => a + b) / ratings.length;

                  return Column(
                    children: [
                      RatingBarIndicator(
                        rating: averageRating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: const Color(0xFFFA7701),
                        ),
                        itemCount: 5,
                        itemSize: 50.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Promedio de calificación: ${averageRating.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      RatingBar.builder(
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // Guardar la calificación en Firestore
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId)
                              .collection('ratings')
                              .add({
                            'workerId': workerId,
                            'rating': rating,
                          }).then((value) {
                            print('Calificación guardada exitosamente');
                          }).catchError((error) {
                            print('Error al guardar la calificación: $error');
                          });
                          FirebaseFirestore.instance
                              .collection('professionals')
                              .doc(workerId)
                              .collection('ratings')
                              .add({
                            'userId': userId,
                            'rating': rating,
                          }).then((value) {
                            print('Calificación guardada exitosamente');
                          }).catchError((error) {
                            print('Error al guardar la calificación: $error');
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
