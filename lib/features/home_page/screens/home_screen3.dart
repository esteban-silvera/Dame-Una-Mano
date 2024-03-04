import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dame_una_mano/features/perfil/sceens/wokers_profile.dart';

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
      final List<String> barrios = currentAddress.split('Barrios: ')[1].split(', ');

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
      appBar: AppBar(
        title: Text(widget.selectedOption),
      ),
      body: SingleChildScrollView(
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
                ? SizedBox(
                    height: 300,
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
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text('Profesionales cercanos'),
                    children: trabajadores.map((trabajador) {
                      return SimpleDialogOption(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkerProfileScreen(
                                workerId: trabajador.id,
                                userId: 'ID_DEL_USUARIO_ACTUAL', // Reemplaza con el ID del usuario actual
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text('${trabajador.nombre} ${trabajador.apellido}'),
                          subtitle: Text('Barrio: ${trabajador.barrio}'),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
              child: const Text('Mostrar Profesionales'),
            )
          ],
        ),
      ),
    );
  }

  String _removeBarriosFromAddress(String addressWithBarrios) {
    return addressWithBarrios.split('Barrios:')[0].trim();
  }
}
