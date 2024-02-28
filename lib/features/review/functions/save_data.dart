import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateWorkerFunction extends StatelessWidget {
  final String userId; // ID del usuario que da la calificación
  final String workerId; // ID del trabajador que recibe la calificación

  RateWorkerFunction({required this.userId, required this.workerId});

  @override
  Widget build(BuildContext context) {
    double _rating = 0.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = rating;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveRatingToFirestore(userId, workerId, _rating);
            },
            child: Text('Guardar Calificación'),
          ),
        ],
      ),
    );
  }

  void _saveRatingToFirestore(String userId, String workerId, double rating) {
    // Guardar la calificación en la colección "ratings" del usuario
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('ratings')
        .add({
      'workerId': workerId,
      'rating': rating,
    }).then((value) {
      print('Calificación guardada exitosamente en Firestore del usuario');

      // Guardar la calificación en la colección "ratings" del trabajador
      FirebaseFirestore.instance
          .collection('professionals')
          .doc(workerId)
          .collection('ratings')
          .add({
        'userId': userId,
        'rating': rating,
      }).then((value) {
        print('Calificación guardada exitosamente en Firestore del trabajador');
      }).catchError((error) {
        print(
            'Error al guardar la calificación en Firestore del trabajador: $error');
      });
    }).catchError((error) {
      print(
          'Error al guardar la calificación en Firestore del usuario: $error');
    });
  }
}
