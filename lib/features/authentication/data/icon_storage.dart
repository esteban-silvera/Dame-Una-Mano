import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class IconStorageService {
  static Future<String> getIconUrl(String iconName) async {
    String iconPath =
        'icons png/$iconName'; // Ruta a la carpeta "icons png" que contiene los iconos en formato PNG
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(iconPath);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  // Método para obtener el nombre del archivo del icono según la profesión
  static String obtenerIconoNombre(String profession) {
    String professionLowercase = profession.toLowerCase();
    String iconName;
    switch (professionLowercase) {
      case 'electricista':
        iconName = 'electricista.jpg';
        break;
      case 'jardinero':
        iconName = 'jardinero.png';
        break;
      case 'plomero':
        iconName = 'plomero.png';
        break;
      case 'carpintero':
        iconName = 'carpintero.jpg';
        break;
      case 'mecanico':
        iconName = 'mecanico.png';
        break;
      case 'albañil':
        iconName = 'albanil.png';
        break;
      case 'pintor':
        iconName = 'pintora.png';
        break;
      case 'cerrajero':
        iconName = 'cerrajero.png';
        break;
      default:
        return 'default_icon_url';
    }

    return iconName;
  }
}
