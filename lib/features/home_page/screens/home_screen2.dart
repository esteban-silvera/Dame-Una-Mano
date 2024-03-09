import 'package:dame_una_mano/features/home_page/screens/home_screen3.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:dame_una_mano/features/home_page/screens/barrios_screen.dart';

class ServiceSelectionWidget extends StatefulWidget {
  final String selectedOption;

  const ServiceSelectionWidget({super.key, required this.selectedOption});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceSelectionWidgetState createState() => _ServiceSelectionWidgetState();
}

class _ServiceSelectionWidgetState extends State<ServiceSelectionWidget> {
  final LocationController _locationController = LocationController();
  bool _isLocationLoaded = false;

  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        var position = await _locationController.getCurrentLocation();
        await _locationController.updateCurrentLocationInFirestore();
        setState(() {
          _isLocationLoaded = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              selectedOption: widget.selectedOption,
              currentAddress: position.address,
              initialCameraPosition: position.position,
              isLocationLoaded: _isLocationLoaded,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error obteniendo la ubicación.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se requiere permiso de ubicación.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFf1f1f1),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  const Text(
                    '¿Para dónde deseas el servicio?',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Monserrat',
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _getLocation();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color(0xFF43c7ff);
                          } else {
                            return Colors.white;
                          }
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF43c7ff)),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return const Color(0xFF43c7ff).withOpacity(
                                0.1); // Color del borde cuando se pasa el mouse
                          }
                          return const Color(
                              0xf1f1f1f1); // Si no está en estado de hover, devuelve nulo
                        },
                      ),
                    ),
                    child: const Text(
                      'Ubicación Actual',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: "Monserrat",
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrioScreen(
                              selectedProfession: widget.selectedOption),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color(0xFFFA7701);
                          } else {
                            return Colors.white;
                          }
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFFFA7701)),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return const Color(0xFFFA7701).withOpacity(
                                0.1); // Color del borde cuando se pasa el mouse
                          }
                          return const Color(
                              0xf1f1f1f1); // Si no está en estado de hover, devuelve nulo
                        },
                      ),
                    ),
                    child: const Text(
                      'Otro Barrio',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Monserrat",
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
