import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class IconStorageService {
  static Future<String> getIconUrl(String iconPath) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(iconPath);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  // Método para obtener la URL de descarga de un icono según la profesión
  static Future<String> obtenerIconoUrl(String profession) async {
    String professionLowercase = profession.toLowerCase();
    String iconName;
    switch (professionLowercase) {
      case 'electricista':
        iconName = 'electricista.jpg';
        break;
      case 'jardinero':
        iconName = 'jardinero.jpg';
        break;
      case 'plomero':
        iconName = 'plomero.jpg';
        break;
      case 'carpintero':
        iconName = 'carpintero.jpg';
        break;
      case 'mecánico':
        iconName = 'mecanico.jpg';
        break;
      case 'albañil':
        iconName = 'albanil.jpg';
        break;
      case 'pintor':
        iconName = 'pintor.jpg';
        break;
      case 'cerrajero':
        iconName = 'cerrajero.jpg';
        break;
      default:
        return 'default_icon_url';
    }

    // Se llama al método getIconUrl en lugar de uploadIcon
    String iconUrl = await getIconUrl('icons/$iconName');
    return iconUrl;
  }
}
