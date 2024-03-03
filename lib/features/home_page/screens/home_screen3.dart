import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BarrioScreen extends StatefulWidget {
  final String selectedOption;
  final String currentAddress;
  final LatLng initialCameraPosition;
  final bool isLocationLoaded;

  BarrioScreen({
    required this.selectedOption,
    required this.currentAddress,
    required this.initialCameraPosition,
    required this.isLocationLoaded,
  });

  @override
  _BarrioScreenState createState() => _BarrioScreenState();
}

class _BarrioScreenState extends State<BarrioScreen> {
  final LocationController _locationController = LocationController();
  List<Trabajador> trabajadores = [];

  @override
  void initState() {
    super.initState();
    // Solo llama a _fetchTrabajadores si la ubicación está cargada
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
      backgroundColor: const Color(0xFFF5f5f5),
      appBar: AppBar(
        title: Text(widget.selectedOption),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Ubicación actual: ${widget.currentAddress}',
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
                  builder: (context) => AlertDialog(
                    title: Text('Profesionales cercanos'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: trabajadores.map((trabajador) {
                          return ListTile(
                            title: Text('${trabajador.nombre} ${trabajador.apellido}'),
                            subtitle: Text('Barrio: ${trabajador.barrio}'),
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
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
}
