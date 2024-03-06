import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:provider/provider.dart';

class WorkerProfileScreen extends StatefulWidget {
  final String workerId;
  final String userId; // ID del usuario que califica al trabajador

  WorkerProfileScreen({required this.workerId, required this.userId});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _showFullDescription = false;
  final Map<String, String> profileImages = {
    'sebastian judini': 'sebastian_judini.png',
    'emilio herrera': 'emilio_herrera.png',
    'nico torrez': 'nico_torrez.png',
    'tom hanks': 'lucia_lopez.png',
    'daniela rojas': 'danielamecanica.jpg'
  };
  final Map<String, String> portadaImages = {
    'sebastian judini': 'electricista.png',
    'emilio herrera': 'portada.png',
    'nico torrez': 'nico_torrez.png',
    'sofía alvez': 'cerrajero.png',
    'daniela rojas': 'portada.jpg',
    'isabel acosta': 'electricistaportada.png'
  };

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xf1f1f1f1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff43c7ff),
        title: const Text("Perfil del trabajador",style: TextStyle(color: Color(0xf1f1f1f1)),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('professionals')
                .doc(widget.workerId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: Color(0xFF43c7ff).withOpacity(0.8),
                );
              }
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos del trabajador');
              }

              var workerData = snapshot.data!.data() as Map<String, dynamic>;
              var name = workerData['name'] ?? 'Nombre no encontrado';
              var lastname = workerData['lastname'] ?? 'Apellido no encontrado';
              // Obtener el nombre de archivo de la imagen de perfil desde el mapa
              String profileImageName = '$name $lastname'.toLowerCase();
              String profileImagePath =
                  profileImages.containsKey(profileImageName)
                      ? 'assets/${profileImages[profileImageName]}'
                      : 'assets/default.jpg';
              String portadaImageName = '$name $lastname'.toLowerCase();
              String portadaImagePath =
                  portadaImages.containsKey(portadaImageName)
                      ? 'assets/${portadaImages[portadaImageName]}'
                      : 'assets/default.jpg';

              return Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(portadaImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF15C7EF),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(profileImagePath),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('professionals')
                .doc(widget.workerId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: Color(0xFF43c7ff).withOpacity(0.8),
                );
              }
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos del trabajador');
              }

              var workerData = snapshot.data!.data() as Map<String, dynamic>;
              var name = workerData['name'] ?? 'Nombre no encontrado';
              var lastname = workerData['lastname'] ?? 'Apellido no encontrado';
              var description =
                  workerData['description'] ?? 'Descripción no disponible';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$name $lastname',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  description.isNotEmpty
                      ? _showFullDescription
                          ? Text(
                              description,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  description.length > 100
                                      ? description.substring(0, 100) + '...'
                                      : description,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                if (description.length > 100)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showFullDescription = true;
                                      });
                                    },
                                    child: const Text(
                                      'Ver más',
                                      style:
                                          TextStyle(color: Color(0xffFA7701)),
                                    ),
                                  ),
                              ],
                            )
                      : const Text(
                          'Sin descripción disponible',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('professionals')
                .doc(widget.workerId)
                .collection('ratings')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: const Color(0xFF43c7ff).withOpacity(0.8),
                );
              }
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos del trabajador');
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
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color(0xFFFA7701),
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
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _launchWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF43c7ff), // Color del botón
                      padding: const EdgeInsets.symmetric(
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
                    icon: const Icon(
                      Icons.message,
                      size: 30,
                      color: Colors.white,
                    ), // Icono de mensaje
                    label: const Text(
                      'Contactame',
                      style: TextStyle(
                        fontSize: 20, // Ajusta el tamaño del texto
                        color: Colors.white, // Color del texto
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              color: Color(0xf1f1f1f1),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize
                                    .min, // Usar el tamaño mínimo verticalmente
                                children: [
                                  const Icon(
                                    Icons.handshake, // Icono handshake
                                    size: 50, // Tamaño del icono
                                  ),
                                  const SizedBox(height: 10), // Espaciador
                                  const Text(
                                    'Dame una mano', // Texto mediano
                                    style: TextStyle(
                                      fontSize: 30, // Tamaño del texto
                                      color:
                                          Color(0xFFFA7701), // Color del texto
                                      fontWeight: FontWeight.bold, // Negrita
                                    ),
                                  ),
                                  const SizedBox(height: 20), // Espaciador
                                  const Text(
                                    '¿Te gustó el servicio?', // Texto explicativo
                                    textAlign:
                                        TextAlign.center, // Alineación centrada
                                    style: TextStyle(
                                      color: Color(0xFF43c7ff),
                                      fontSize: 20,
                                    ), // Tamaño del texto
                                  ),
                                  const SizedBox(height: 10), // Espaciador
                                  const Text(
                                    'Por favor, déjanos tu review de este usuario.', // Texto explicativo
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ), // Tamaño del texto
                                  const SizedBox(height: 30), // Espaciador
                                  RatingBar.builder(
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 0.1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.star,
                                        color: Color(0xFFFa7701),
                                        size: starSize,
                                      ),
                                    ),
                                    onRatingUpdate: (rating) async {
                                      // Guardar la calificación y el comentario en Firestore
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(userProvider.user.localId)
                                          .collection('ratings')
                                          .add({
                                        'workerId': widget.workerId,
                                        'rating': rating,
                                        'comment': _commentController.text,
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('professionals')
                                          .doc(widget.workerId)
                                          .collection('ratings')
                                          .add({
                                        'userId': widget.userId,
                                        'rating': rating,
                                        'comment': _commentController.text,
                                      });
                                    },
                                    itemSize: starSize,
                                    unratedColor: Colors.grey,
                                    updateOnDrag: true,
                                    allowHalfRating: true,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .transparent, // Establece el color transparente para el fondo del botón
                                      padding:
                                          const EdgeInsets.all(8), // padding
                                      elevation: 0, //  sombra del botón
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Color(0xFF43c7ff),
                                          width: 1, // Ajusta el ancho del borde
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.close,
                                      size: 20, // Ajusta el tamaño del icono
                                      color: Colors.black,
                                    ),
                                    label: const Text(
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
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfff6f6f6), // Color de fondo
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Radio del borde
                        side: const BorderSide(
                          color: Color(0xFF43c7ff),
                          width: 1, // Grosor del borde
                        ),
                      ),
                      elevation: 0, // sombreado
                    ),
                    child: const Text(
                      'Calificar',
                      style: TextStyle(
                        fontSize: 20, // texto
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ))),
    );
  }

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
