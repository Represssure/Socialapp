import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/profile_dialog.dart';
import 'screens/login_screen.dart';
import 'screens/profile_widget.dart';
import 'screens/map_screen.dart';

class MapService {
  Future<Marker?> getMarker(LocationData? currentLocation) async {
    if (currentLocation == null) return null;

    return Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      builder: (ctx) => Container(
        child: Image.asset('assets/point_icon.png'),
      ),
    );
  }
}
