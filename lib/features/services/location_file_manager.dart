// lib\services\location_file_manager.dart
import 'dart:convert';
import 'dart:io';

class LocationFileManager {
  static Future<void> saveLocationToJson(Map<String, dynamic> locationData) async {
    final file = File('location_data.json');
    await file.writeAsString(jsonEncode(locationData));
  }
}
