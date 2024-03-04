import 'package:dame_una_mano/features/home_page/screens/barrios_screen.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
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
      backgroundColor: Color(0xf1f1f1f1),
      appBar: AppBar(
        backgroundColor: const Color(0xebebebeb),
        title: Text(widget.selectedOption),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Altura de la línea
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5), // Color celeste
            height: 1.0, // Grosor de la línea
          ),
        ),
      ),
      drawer: Sidebar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xF1f1f1f1).withOpacity(1),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dame una mano',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: "Monserrat",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.handshake,
                          color: Colors.black,
                          size: 24,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '¿Para dónde deseas el servicio?',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
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
                          fontFamily: "Monserrat",
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonColor = Color(0xFFFA7701);
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
                        foregroundColor: const Color.fromARGB(255, 10, 10, 10),
                        side: BorderSide(color: Color(0xFFFA7701)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Otro Barrio',
                        style: TextStyle(
                          fontFamily: "Monserrat",
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
