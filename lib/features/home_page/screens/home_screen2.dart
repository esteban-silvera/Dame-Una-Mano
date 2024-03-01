import 'package:flutter/material.dart';

class HomeScreen2 extends StatefulWidget {
  final String selectedOption;

  const HomeScreen2({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
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
              onPressed: () {
                // Navegar a la página de ubicación actual
                Navigator.pushNamed(context, '/ubicacion_actual');
              },
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
