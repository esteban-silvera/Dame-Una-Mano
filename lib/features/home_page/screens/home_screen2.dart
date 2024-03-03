import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class BarrioScreen extends StatefulWidget {
  final String selectedOption;

  BarrioScreen({
    required this.selectedOption,
  });

  @override
  _BarrioScreenState createState() => _BarrioScreenState();
}

class _BarrioScreenState extends State<BarrioScreen> {
  final LocationController _locationController = LocationController();
  String _currentAddress = 'Ubicación desconocida';
  LatLng _initialCameraPosition = const LatLng(0, 0);
  bool _isLocationLoaded = false;

  List<Trabajador> trabajadores = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _isLocationLoaded = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se requiere permiso de ubicación.'),
        ),
      );
    }
  }

  Future<void> _getLocation() async {
    var position = await _locationController.getCurrentLocation();
    setState(() {
      _currentAddress = position.address;
      _initialCameraPosition = position.position;
      _isLocationLoaded = true;
    });
    _fetchTrabajadores(_currentAddress);
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
        title: Text(widget.selectedOption), // Mostrar la opción seleccionada en el título del app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Actualizar ubicación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromRGBO(255, 130, 67, 1),
                side: const BorderSide(color: Color(0xFF43c7ff)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ubicación actual: $_currentAddress',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _isLocationLoaded
                ? SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialCameraPosition,
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('userLocation'),
                    position: _initialCameraPosition,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromRGBO(255, 130, 67, 1),
                side: const BorderSide(
                  color: Color(0xFF43c7ff),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
