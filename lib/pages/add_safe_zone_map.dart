import 'dart:convert';
import 'dart:typed_data';

import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class AddSafeZoneMap extends StatefulWidget {
  @override
  _AddSafeZoneMapState createState() => _AddSafeZoneMapState();
}

class _AddSafeZoneMapState extends State<AddSafeZoneMap> {
  MapLibreMapController? mapController;
  LocationData? currentLocation;
  List<LatLng> polygonPoints = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<Uint8List> getImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  // Retrieve user's current location
  Future<void> _getCurrentLocation() async {
    Location location = Location();

    // Check if permissions are granted
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Retrieve current location
    currentLocation = await location.getLocation();

    if (currentLocation != null) {
      setState(() {
        mapController?.moveCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
      });
    } else {
      print('Error: currentLocation is null');
    }
  }

  // Sort points in a counter-clockwise order around centroid
  List<LatLng> _sortPoints(List<LatLng> points) {
    if (points.isEmpty) return [];
    // Calculate centroid
    double centerX =
        points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
    double centerY =
        points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length;

    // Sort points based on angle from centroid
    points.sort((a, b) {
      double angleA = atan2(a.latitude - centerX, a.longitude - centerY);
      double angleB = atan2(b.latitude - centerX, b.longitude - centerY);
      return angleA.compareTo(angleB);
    });

    return points;
  }

  // Add point to polygon and sort
  void _addPoint(LatLng point) {
    polygonPoints.add(point);
    polygonPoints = _sortPoints(polygonPoints);
    mapController?.addCircle(CircleOptions(
      geometry: point,
      circleColor: "#FF0000",
      circleRadius: 4,
    ));
  }

  // Update polygon on the map
  void _updatePolygon() {
    mapController?.clearSymbols(); // Optional: Clear existing symbols if any
    mapController?.addFill(FillOptions(
      geometry: [polygonPoints],
      fillColor: '#ff0000',
      fillOpacity: 0.4,
    ));
  }

  void _drawSafeZonePolygon() {
    mapController?.clearSymbols();
    mapController?.addFill(FillOptions(
      geometry: [polygonPoints],
      fillColor: "#008000", // Green to indicate the safe zone
      fillOpacity: 0.3,
    ));
  }

  void _clearAllPoints() {
    polygonPoints.clear();
    mapController?.clearFills(); // Clears the polygon from the map
    mapController?.clearCircles();
  }

  void _saveSafeZone(BuildContext context) async {
    if (polygonPoints.isEmpty || polygonPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please select at least three points to define a safe zone.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      var url = Uri.http(serverUrl, '/safezones');
      final safeZoneData = polygonPoints
          .map((point) => {
                'latitude': point.latitude,
                'longitude': point.longitude,
              })
          .toList();
      var body = {
        'username': 'hoangs369',
        'safeZone': safeZoneData,
      };
      var res = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 201) {
        context.read<SaveZoneBloc>().add(GetAllSaveZoneEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Safe zone saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save the safe zone. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _clearAllPoints();
  }

  void _onMapCreated(MapLibreMapController controller) async {
    await Future.delayed(Duration(milliseconds: 100));
    mapController = controller;
    final Uint8List markerIcon =
        await getImageFromAsset('assets/location_icon1.jpg');
    await mapController?.addImage("location-icon1", markerIcon);
    await mapController?.addSymbol(SymbolOptions(
      geometry: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      iconImage: "location-icon1",
      iconSize: 0.3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Define Safe Zone',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {
              _saveSafeZone(context);
            }, // Save button to store the zone
            color: Colors.white,
          ),
        ],
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                MapLibreMap(
                  styleString:
                      "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 17.5,
                  ),
                  onMapCreated: _onMapCreated,
                  onMapClick: (point, latLng) => _addPoint(latLng),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    child: Icon(Icons.done),
                    onPressed: _drawSafeZonePolygon, // Complete polygon
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    child: Icon(Icons.clear),
                    backgroundColor: Colors.red.shade300,
                    onPressed: _clearAllPoints, // Complete polygon
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomDashboard()),
          );
        },
        backgroundColor: Colors.green.shade300,
        child: Icon(Icons.home, size: 28, color: Colors.white),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade300,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
