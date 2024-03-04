import 'package:dame_una_mano/features/home_page/screens/barrios_screen.dart';
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
  bool _isLocationLoaded = false;
  Color buttonColor = Colors.white;

  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      var position = await _locationController.getCurrentLocation();
      await _locationController.updateCurrentLocationInFirestore();

      setState(() {
        _isLocationLoaded = true;
      });
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
      backgroundColor: Color(0xedededed),
      appBar: AppBar(
        backgroundColor: Color(0xedededed),
        title: Text(widget.selectedOption),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xF5f5f5f5),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Para dónde deseas el servicio?',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonColor = Color(0xFF43c7ff);
                        });
                        _getLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Color(0xFF43c7ff)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Ubicación Actual',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonColor = Color(0xFF43c7ff);
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarrioScreen(
                                selectedProfession: widget.selectedOption),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Color(0xFF43c7ff)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Otro Barrio',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
