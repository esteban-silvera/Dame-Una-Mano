import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase que proporciona métodos para interactuar con Firebase Firestore.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sube datos a Firestore en un documento específico en una colección.
  ///
  /// [data]: Mapa de datos a subir.
  /// [collectionName]: Nombre de la colección en Firestore.
  /// [documentId]: ID del documento en Firestore.
  Future<void> uploadData(Map<String, dynamic> data, String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data);
    } catch (e) {
      print('Error al subir los datos: $e');
    }
  }

  /// Actualiza datos en Firestore en un documento específico en una colección.
  ///
  /// [data]: Mapa de datos a actualizar.
  /// [collectionName]: Nombre de la colección en Firestore.
  /// [documentId]: ID del documento en Firestore.
  Future<void> updateData(Map<String, dynamic> data, String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
    } catch (e) {
      print('Error al actualizar los datos: $e');
    }
  }

  /// Obtiene datos de Firestore de un documento específico en una colección.
  ///
  /// [collectionName]: Nombre de la colección en Firestore.
  /// [documentId]: ID del documento en Firestore.
  Future<Map<String, dynamic>?> fetchData(String collectionName, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection(collectionName).doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        print('El documento no existe');
        return null;
      }
    } catch (e) {
      print('Error al obtener los datos: $e');
      return null;
    }
  }
}
