import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/widgets/trabajadores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
  }

  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      var position = await _locationController.getCurrentLocation();
      setState(() {
        _currentAddress = position.address;
        _initialCameraPosition = position.position;
        _isLocationLoaded = true;
      });
      // Llama a la función para cargar los trabajadores cuando se obtiene la ubicación
      _fetchTrabajadores();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se requiere permiso de ubicación.'),
        ),
      );
    }
  }

  Future<void> _fetchTrabajadores() async {
    try {
      QuerySnapshot querySnapshot;
      if (selectedBarrio != null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('professionals')
            .where('job', isEqualTo: widget.selectedProfession)
            .where('barrio', isEqualTo: selectedBarrio)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('professionals')
            .where('job', isEqualTo: widget.selectedProfession)
            .get();
      }

      setState(() {
        // Limpia la lista de trabajadores antes de cargar los nuevos
        trabajadores.clear();
        // Mapea los documentos a objetos Trabajador y los agrega a la lista
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
                value: selectedBarrio,
                onChanged: (String? barrio) {
                  setState(() {
                    selectedBarrio = barrio;
                    _fetchTrabajadores(); // Llama a la función al cambiar el barrio seleccionado
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
                    title: Text('Trabajadores en tu área'),
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
