import 'package:dame_una_mano/features/home_page/screens/barrios_screen.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dame_una_mano/features/perfil/screens/wokers_profile.dart';

class MapScreen extends StatefulWidget {
  final String selectedOption;
  final String currentAddress;
  final LatLng initialCameraPosition;
  final bool isLocationLoaded;

  MapScreen({
    required this.selectedOption,
    required this.currentAddress,
    required this.initialCameraPosition,
    required this.isLocationLoaded,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

Color buttonColor = const Color(0xf1f1f1f1);

class _MapScreenState extends State<MapScreen> {
  final LocationController _locationController = LocationController();
  List<Trabajador> trabajadores = [];

  @override
  void initState() {
    super.initState();
    if (widget.isLocationLoaded) {
      _fetchTrabajadores(widget.currentAddress);
    }
  }

  Future<void> _fetchTrabajadores(String currentAddress) async {
    try {
      final List<String> barrios =
          currentAddress.split('Barrios: ')[1].split(', ');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', isEqualTo: widget.selectedOption)
          .where('barrio', whereIn: barrios)
          .get();

      setState(() {
        trabajadores.clear();
        trabajadores.addAll(querySnapshot.docs.map((doc) {
          return Trabajador(
            id: doc.id,
            nombre: doc['name'],
            apellido: doc['lastname'],
            barrio: doc['barrio'],
            oficio: doc['job'],
          );
        }).toList());
      });
    } catch (e) {
      print('Error al obtener trabajadores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: Color(0xff43c7ff).withOpacity(0.9),
        title: Text(widget.selectedOption),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      drawer: Sidebar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Ubicación actual: ${_removeBarriosFromAddress(widget.currentAddress)}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              widget.isLocationLoaded
                  ? Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.5, // Ajusta la altura del contenedor del mapa
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: widget.initialCameraPosition,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('userLocation'),
                              position: widget.initialCameraPosition,
                            ),
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff43c7ff).withOpacity(0.8),
                      ),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Color(0xf5f5f5f5),
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('Profesionales cercanos'),
                      children: trabajadores.map((trabajador) {
                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('professionals')
                              .doc(trabajador.id) // Usar la ID del trabajador
                              .collection('ratings')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color:
                                      const Color(0xff43c7ff).withOpacity(0.8),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                  'Error al cargar los datos del trabajador');
                            }

                            var ratings = snapshot.data!.docs
                                .map((doc) => (doc["rating"] as num).toDouble())
                                .toList();

                            double averageRating = ratings.isEmpty
                                ? 0.0
                                : ratings.reduce((a, b) => a + b) /
                                    ratings.length;

                            return SimpleDialogOption(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkerProfileScreen(
                                      workerId: trabajador.id,
                                      userId:
                                          'ID_DEL_USUARIO_ACTUAL', // Reemplaza con el ID del usuario actual
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  '${trabajador.nombre} ${trabajador.apellido}',
                                ),
                                subtitle: Row(
                                  children: [
                                    Text('Barrio: ${trabajador.barrio}'),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Calificación: ${averageRating.toStringAsFixed(1)}',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor, // Usar el color de fondo dinámico
                  foregroundColor: Colors.black,
                  side: const BorderSide(
                    color: Color.fromRGBO(255, 130, 67, 1), // Borde naranja
                  ),
                ),
                child: const Text(
                  'Encuentra!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 16, 16, 16), // Color del texto
                    // Subrayado
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  // Navegar a otra pantalla con la opción de barrio seleccionada como la profesión actual
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarrioScreen(
                        selectedProfession: widget.selectedOption,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Cambiar a otro barrio',
                  style: TextStyle(
                      color: Color.fromARGB(255, 12, 12, 12),
                      fontSize: 16, // Tamaño de fuente ajustable
                      fontFamily: "monserrat",
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _removeBarriosFromAddress(String addressWithBarrios) {
    return addressWithBarrios.split('Barrios:')[0].trim();
  }
}
