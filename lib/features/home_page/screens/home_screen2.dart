import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen3.dart';

class HomeScreen2 extends StatefulWidget {
  final String selectedOption;

  const HomeScreen2({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final LocationController _locationController = LocationController();
  bool _isLocationLoaded = false; // Define _isLocationLoaded aquí

  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      var position = await _locationController.getCurrentLocation();
      // Actualizar la ubicación en Firestore antes de navegar a la siguiente pantalla
      await _locationController.updateCurrentLocationInFirestore();

      setState(() {
        // Puedes agregar más datos aquí si es necesario
        _isLocationLoaded = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarrioScreen(
            selectedOption: widget.selectedOption,
            currentAddress: position.address,
            initialCameraPosition: position.position,
            isLocationLoaded: _isLocationLoaded, // Usar _isLocationLoaded aquí
          ),
        ),
      );
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
      appBar: AppBar(
        title: Text(widget.selectedOption),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Para dónde deseas el servicio?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Ubicación Actual'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de otro barrio
                Navigator.pushNamed(context, '/otro_barrio');
              },
              child: Text('Otro Barrio'),
            ),
          ],
        ),
      ),
    );
  }
}
