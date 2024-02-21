// lib/controllers/location_controller.dart

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location.dart' as MyLocation;
import '../services/location_service.dart';
import '../services/firebase_service.dart'; // Importa el servicio de Firestore
import '../utils/barrios_codigos_postales.dart';

class LocationController {
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService(); // Instancia del servicio de Firestore

  // Métodos para obtener la ubicación y cargarla a Firestore
  Future<MyLocation.Location> getCurrentLocation() async {
    final Position position = await _locationService.getCurrentPosition();
    final String address = await _getCurrentAddress(position);
    // Utiliza LatLng para crear la posición
    return MyLocation.Location(address: address, position: LatLng(position.latitude, position.longitude));
  }

  Future<void> uploadCurrentLocationToFirestore() async {
    try {
      var position = await getCurrentLocation();
      String currentAddress = position.address;

      // Luego, carga esta dirección en Firestore
      await _firestoreService.uploadData(
        {'address': currentAddress},
        'ubicaciones',
        'ubicacion_actual',
      );
    } catch (e) {
      print('Error al subir la ubicación a Firestore: $e');
    }
  }

  Future<void> updateCurrentLocationInFirestore() async {
    try {
      var position = await getCurrentLocation();
      String newAddress = position.address;

      // Actualizar la dirección en Firestore
      await _firestoreService.updateData(
        {'address': newAddress},
        'ubicaciones',
        'ubicacion_actual',
      );
    } catch (e) {
      print('Error al actualizar la ubicación en Firestore: $e');
    }
  }

  Future<String> _getCurrentAddress(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      String subLocality = place.subLocality ?? '';
      String subLocalityText = subLocality.isNotEmpty ? '$subLocality, ' : '';

      String addressLine = place.street ?? '';
      String locality = place.locality ?? '';
      String postalCode = place.postalCode ?? '';
      String address = '${addressLine.isNotEmpty ? '$addressLine, ' : ''}${subLocalityText.isNotEmpty ? subLocalityText : ''}${locality.isNotEmpty ? '$locality, ' : ''}${postalCode.isNotEmpty ? '$postalCode, ' : ''}${place.country}';

      List<String> zones = postalCode.isNotEmpty ? _mapPostalCodeToZone(postalCode) : ["Desconocida"];

      return "$address\nBarrios: ${zones.join(", ")}";
    } catch (e) {
      return "No se pudo obtener la dirección: $e";
    }
  }

  List<String> _mapPostalCodeToZone(String postalCode) {
    List<String> foundZones = [];
    for (var departamento in barriosCodigosPostales.values) {
      for (var codigos in departamento.values) {
        if (codigos.contains(postalCode)) {
          var zona = departamento.keys.firstWhere((key) => departamento[key] == codigos);
          foundZones.add(zona);
        }
      }
    }
    return foundZones;
  }
}
