import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerInfoScreen extends StatelessWidget {
  final String workerId;

  WorkerInfoScreen({required this.workerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Trabajador'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('professionals')
                .doc(workerId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error al cargar los datos del trabajador');
              }

              var workerData = snapshot.data!.data() as Map<String, dynamic>;
              var name = workerData['name'] ?? 'Nombre no disponible';
              var job = workerData['job'] ?? 'Profesión no disponible';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: $name'),
                  Text('Profesión: $job'),
                  SizedBox(height: 10),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('professionals')
                        .doc(workerId)
                        .collection('ratings')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error al cargar los datos del trabajador');
                      }

                      var ratings = snapshot.data!.docs
                          .map((doc) => doc["rating"] as double)
                          .toList();
                      double averageRating = ratings.isEmpty
                          ? 0.0
                          : ratings.reduce((a, b) => a + b) / ratings.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Averagerating: ${averageRating.toStringAsFixed(2)}'),
                          // Aquí puedes mostrar otros detalles del trabajador
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
