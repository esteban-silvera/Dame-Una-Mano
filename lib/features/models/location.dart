// lib/models/location.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String address;
  final LatLng position;

  Location({required this.address, required this.position});
}
