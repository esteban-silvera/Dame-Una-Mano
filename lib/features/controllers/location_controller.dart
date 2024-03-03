import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location.dart' as MyLocation;
import '../services/location_service.dart';
import '../services/firebase_service.dart'; // Importa el servicio de Firestore
import '../utils/barrios_codigos_postales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

      // Separar la dirección en sus componentes: calle, ciudad, código postal, país, barrio
      List<String> addressComponents = currentAddress.split(', ');

      // Extraer los datos de la dirección
      String street = addressComponents[0];
      String city = addressComponents[1];
      String postalCode = addressComponents[2].split(' ')[1]; // Obtener solo el código postal
      String country = addressComponents[3];
      List<String> barrios = addressComponents[4].split(', '); // Obtener lista de barrios

      // Subir los datos a Firestore
      await _firestoreService.uploadData(
        {
          'street': street,
          'city': city,
          'postalCode': postalCode,
          'country': country,
          'barrios': barrios,
          'latitude': position.position.latitude, // Agregar latitud
          'longitude': position.position.longitude, // Agregar longitud
        },
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
      
      String barrioFromAddress = zones.join(', '); // Obtiene el nombre del barrio de la dirección
      String barrio = normalizeBarrioName(barrioFromAddress); // Normaliza el nombre del barrio

      return "$address\nBarrios: $barrio";
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

  String normalizeBarrioName(String barrioName) {
    // Divide el nombre del barrio en sus palabras
    List<String> words = barrioName.split(' ');
    
    // Itera sobre cada palabra y capitaliza la primera letra
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word;
      }
    }).toList();
    
    // Une las palabras nuevamente en un solo string
    String normalizedBarrioName = capitalizedWords.join(' ');
    
    return normalizedBarrioName;
  }

  Future<List<Map<String, dynamic>>> getProfessionalsInBarrio(String profession, String barrio) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', isEqualTo: profession)
          .where('barrio', isEqualTo: barrio)
          .get();
      
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error al obtener profesionales en el barrio: $e');
      return [];
    }
  }
}
