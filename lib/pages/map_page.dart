// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
          zoom: 13,
        ),
        mapType: MapType.satellite,
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"), 
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex),
          Marker(
            markerId: MarkerId("_sourceLocation"), 
            icon: BitmapDescriptor.defaultMarker,
            position: _pApplePark)
        },
    ));
  }
}
