import 'package:dame_una_mano/features/perfil/sceens/wokers_profile.dart';
import 'package:dame_una_mano/features/review/screens/ratescreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:dame_una_mano/features/services/location_file_manager.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:dame_una_mano/features/utils/file_utils.dart';

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
                if (selectedBarrio != null) {
                  List<Trabajador> trabajadoresEnBarrio = trabajadores
                      .where((trabajador) =>
                          trabajador.barrio.toLowerCase() ==
                          selectedBarrio!.toLowerCase())
                      .toList();

                  if (trabajadoresEnBarrio.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Trabajadores en el Barrio'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: trabajadoresEnBarrio.map((trabajador) {
                              return ListTile(
                                title: Text(
                                    '${trabajador.nombre} ${trabajador.apellido}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.lightBlue)),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => WorkerProfileScreen(
                                        workerId: trabajador.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                              const Text('No hay trabajadores en este barrio'),
                          content:
                              const Text('Por favor, selecciona otro barrio.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
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
