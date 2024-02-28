import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> getRatings() async {
  QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance.collection('ratings').get();
  ratingsSnapshot.docs.forEach((doc) {
    print('Calificación: ${doc['rating']}, Opinión: ${doc['opinion']}');
  });
}