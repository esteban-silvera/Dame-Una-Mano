import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:provider/provider.dart';

class WorkerProfileScreen extends StatelessWidget {
  final String workerId;
  final String userId; // ID del usuario que califica al trabajador

  WorkerProfileScreen({required this.workerId, required this.userId});

  final TextEditingController _commentController = TextEditingController();
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
    final userProvider = Provider.of<UserProvider>(context);
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
                      .map((doc) => (doc["rating"] as num).toDouble())
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
                      ElevatedButton.icon(
                        onPressed: _launchWhatsApp,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF43c7ff), // Color del botón
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ), // Ajusta el padding para hacer el botón más grande
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Ajusta el radio según tu preferencia
                          ),
                          elevation:
                              7, // Ajusta el valor según tu preferencia de sombreado
                        ),
                        icon: Icon(
                          Icons.message,
                          size: 30,
                          color: Colors.white,
                        ), // Icono de mensaje
                        label: Text(
                          'Contactame',
                          style: TextStyle(
                            fontSize: 20, // Ajusta el tamaño del texto
                            color: Colors.white, // Color del texto
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Mostrar el modal bottom sheet
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              double screenWidth =
                                  MediaQuery.of(context).size.width;
                              double starSize = screenWidth *
                                  0.1; // Ajusta el tamaño de las estrellas según el ancho de la pantalla

                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize
                                        .min, // Usar el tamaño mínimo verticalmente
                                    children: [
                                      Icon(
                                        Icons.handshake, // Icono handshake
                                        size: 50, // Tamaño del icono
                                      ),
                                      SizedBox(height: 10), // Espaciador
                                      Text(
                                        'Dame Una Mano', // Texto mediano
                                        style: TextStyle(
                                          fontSize: 30, // Tamaño del texto
                                          color: Color(
                                              0xFFFA7701), // Color del texto
                                          fontWeight:
                                              FontWeight.bold, // Negrita
                                        ),
                                      ),
                                      SizedBox(height: 20), // Espaciador
                                      Text(
                                        '¿Te gustó el servicio?', // Texto explicativo
                                        textAlign: TextAlign
                                            .center, // Alineación centrada
                                        style: TextStyle(
                                          color: Color(0xFF43c7ff),
                                          fontSize: 20,
                                        ), // Tamaño del texto
                                      ),
                                      SizedBox(height: 10), // Espaciador
                                      Text(
                                        'Por favor, déjanos tu review de este usuario.', // Texto explicativo
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ), // Tamaño del texto
                                      SizedBox(height: 30), // Espaciador
                                      RatingBar.builder(
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0.1,
                                                blurRadius: 10,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: starSize,
                                          ),
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Guardar la calificación y el comentario en Firestore
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userProvider.user.localId)
                                              .collection('ratings')
                                              .add({
                                            'workerId': workerId,
                                            'rating': rating,
                                            'comment': _commentController.text,
                                          }).then((value) {
                                            print(
                                                'Calificación guardada exitosamente');
                                          }).catchError((error) {
                                            print(
                                                'Error al guardar la calificación: $error');
                                          });

                                          FirebaseFirestore.instance
                                              .collection('professionals')
                                              .doc(workerId)
                                              .collection('ratings')
                                              .add({
                                            'userId': userId,
                                            'rating': rating,
                                            'comment': _commentController.text,
                                          }).then((value) {
                                            print(
                                                'Calificación guardada exitosamente');
                                          }).catchError((error) {
                                            print(
                                                'Error al guardar la calificación: $error');
                                          });
                                        },
                                        itemSize: starSize,
                                        unratedColor: Colors.grey,
                                        updateOnDrag: true,
                                        glow: true,
                                        glowColor:
                                            Colors.amber.withOpacity(0.5),
                                        glowRadius: 10,
                                        allowHalfRating: true,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors
                                              .transparent, // Establece el color transparente para el fondo del botón
                                          padding: EdgeInsets.all(8), // padding
                                          elevation: 0, //  sombra del botón
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: Color(0xFF43c7ff),
                                              width:
                                                  1, // Ajusta el ancho del borde
                                            ),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.close,
                                          size:
                                              20, // Ajusta el tamaño del icono
                                          color: Colors.black,
                                        ),
                                        label: Text(
                                          'Cerrar',
                                          style: TextStyle(
                                            fontSize:
                                                16, // Ajusta el tamaño del texto
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent, // Color de fondo
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 60,
                          ), // Ajusta el padding para hacer el botón más grande
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Radio del borde
                            side: BorderSide(
                              color: Color(0xFF43c7ff),
                              width: 1, // Grosor del borde
                            ),
                          ),
                          elevation: 0, // sombreado
                        ),
                        child: Text(
                          'Calificar',
                          style: TextStyle(
                            fontSize: 20, // texto
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
