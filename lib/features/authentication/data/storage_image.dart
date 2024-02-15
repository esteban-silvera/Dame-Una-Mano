import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Clase para manejar las operaciones de almacenamiento en Firebase Storage
class StorageService {
  // Método para subir una imagen a Firebase Storage
  static Future<void> uploadImage(File file) async {
    // Genera una referencia en Firebase Storage con un nombre único basado en la fecha y hora actual
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    // Sube el archivo al almacenamiento
    await ref.putFile(file);
  }

  // Método para obtener la URL de descarga de una imagen en Firebase Storage
  static Future<String> getImageUrl(String imagePath) async {
    // Obtiene una referencia a la imagen en Firebase Storage
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
    
    // Obtiene la URL de descarga de la imagen
    String downloadURL = await ref.getDownloadURL();
    
    // Devuelve la URL de descarga
    return downloadURL;
  }
}
