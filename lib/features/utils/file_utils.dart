// lib\utils\file_utils.dart
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> getApplicationDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
