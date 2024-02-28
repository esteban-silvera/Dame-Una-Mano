import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/authentication/data/icon_storage.dart';

class ServiceItem extends StatelessWidget {
  final String service;

  const ServiceItem({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: IconStorageService.getIconUrl('icons/${IconStorageService.obtenerIconoNombre(service)}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Icon(Icons.error);
        } else {
          return InkWell(
            onTap: () {
              print("Servicio seleccionado: $service");
            },
            splashColor: Colors.lightBlueAccent.withOpacity(0.5),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.lightBlue.shade300),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.network(snapshot.data!),
            ),
          );
        }
      },
    );
  }
}
