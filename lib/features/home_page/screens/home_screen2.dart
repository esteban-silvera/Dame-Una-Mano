import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/utils/file_utils.dart';
import 'package:dame_una_mano/features/services/location_file_manager.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class BarrioScreen extends StatefulWidget {
  final String selectedProfession;

  BarrioScreen({
    required this.selectedProfession,
  });

  @override
  _BarrioScreenState createState() => _BarrioScreenState();
}

class _BarrioScreenState extends State<BarrioScreen> {
  final LocationController _locationController = LocationController();
  String _currentAddress = 'Ubicación desconocida';
  LatLng _initialCameraPosition = const LatLng(0, 0);
  bool _isLocationLoaded = false;

  String? selectedBarrio;
  List<Trabajador> trabajadores = [];

  List<String> barriosMontevideo = [
    'Aires Puros',
    'Atahualpa',
    'Bañados de Carrasco',
    'Bella Italia',
    'Brazo Oriental',
    'Carrasco',
    'Cordon',
    'Centro',
    'Cerro Norte',
    'Punta Carretas',
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _fetchTrabajadores();
  }

  Future<void> _getLocation() async {
    // Implementa la lógica para obtener la ubicación del usuario
  }

  Future<void> _fetchTrabajadores() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', isEqualTo: widget.selectedProfession)
          .get();

      trabajadores = querySnapshot.docs.map((doc) {
        return Trabajador(
          id: doc.id, // ID del documento, que es la ID del trabajador
          nombre: doc['name'],
          apellido: doc['lastname'],
          barrio: doc['barrio'],
          oficio: doc['job'],
        );
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error al obtener trabajadores: $e');
    }
  }

  Future<void> _updateProfessionalBarrio(String barrio) async {
    try {
      String userId = '';
      
      // Obtén el ID del usuario actualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
      } else {
        // Si no hay usuario autenticado, genera un ID único para el usuario no autenticado
        userId = Uuid().v4();
      }

      // Actualiza el campo 'barrio' en Firestore para el profesional
      await FirebaseFirestore.instance
          .collection('professionals')
          .doc(userId)
          .update({'barrio': barrio});

      print('Barrio actualizado en Firestore.');
    } catch (e) {
      print('Error al actualizar el barrio en Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5f5f5),
      appBar: AppBar(
        title: Text('Seleccionar Barrio'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: DropdownButton<String>(
                hint: const Text('Seleccionar Barrio'),
                onChanged: (String? barrio) {
                  setState(() {
                    selectedBarrio = barrio;
                  });
                },
                items: barriosMontevideo.map((String barrio) {
                  return DropdownMenuItem<String>(
                    value: barrio,
                    child: Text(barrio),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var status = await Permission.location.request();
                if (status.isGranted) {
                  var position = await _locationController.getCurrentLocation();
                  setState(() {
                    _currentAddress = position.address;
                    _initialCameraPosition = position.position;
                    _isLocationLoaded = true;
                  });

                  await _locationController.uploadCurrentLocationToFirestore();
                  await LocationFileManager.saveLocationToJson({
                    'address': _currentAddress,
                    'latitude': _initialCameraPosition.latitude,
                    'longitude': _initialCameraPosition.longitude,
                  });

                  final directoryPath =
                      await FileUtils.getApplicationDocumentsDirectoryPath();
                  print(
                      'Directorio de documentos de la aplicación: $directoryPath');

                  // Actualiza el barrio del profesional en Firestore
                  if (selectedBarrio != null) {
                    await _updateProfessionalBarrio(selectedBarrio!);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Se requiere permiso de ubicación.'),
                    ),
                  );
                }
              },
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
                // Resto del código
              },
              child: const Text('Mostrar Trabajadores'),
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
