import 'dart:typed_data';

import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/services/cow_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'services/location_service.dart';
import 'utils/polygon_utils.dart';
import 'widgets/map_controls.dart';

class AddSafeZoneScreen extends StatefulWidget {
  @override
  _AddSafeZoneScreenState createState() => _AddSafeZoneScreenState();
}

class _AddSafeZoneScreenState extends State<AddSafeZoneScreen> {
  MapLibreMapController? mapController;
  LocationData? currentLocation;
  List<LatLng> polygonPoints = [];
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    currentLocation = await _locationService.getCurrentLocation();
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

  void _addPoint(LatLng point) {
    mapController?.addCircle(CircleOptions(
      geometry: point,
      circleColor: "#FF0000",
      circleRadius: 4,
    ));
    setState(() {
      mapController?.clearFills();
      mapController?.clearLines();
      polygonPoints.add(point);
      polygonPoints = PolygonUtils.sortPoints(polygonPoints);
      _drawSafeZonePolygon();
    });
  }

  void _drawSafeZonePolygon() {
    mapController?.clearFills();
    mapController?.clearSymbols();
    mapController?.addFill(FillOptions(
      geometry: [
        [...polygonPoints, polygonPoints.first]
      ],
      fillColor: "#00FF00",
      fillOpacity: 0.3,
      fillOutlineColor: "#000000",
    ));
    mapController?.addLine(
      LineOptions(
        geometry: [...polygonPoints, polygonPoints.first],
        lineColor: "#000000",
        lineWidth: 2.0,
        lineJoin: "round", // Improve line join quality
      ),
    );
  }

  void _clearAllPoints() {
    setState(() {
      polygonPoints.clear();
    });
    mapController?.clearLines();
    mapController?.clearFills();
    mapController?.clearCircles();
  }
Future<String?> _showGroupNameInputDialog(BuildContext context) async {
  String? groupName;

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter Group Name'),
        content: TextField(
          onChanged: (value) => groupName = value,
          decoration: const InputDecoration(hintText: 'Group Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(groupName?.trim()), // Confirm
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

  void _saveSafeZone(BuildContext context) async {
    if (polygonPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please select at least three points to define a safe zone.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // Prevent FAB from moving
          margin: EdgeInsets.only(
              bottom: 500, left: 40, right: 40), // Adjust spacing if needed
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }
  final groupName = await _showGroupNameInputDialog(context);
  if (groupName == null || groupName.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Group name cannot be empty.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 500, left: 40, right: 40),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }
    try {
      final username =
          (context.read<UserBloc>().state as UserLoaded).user.username ?? "";
      final successCreated = await saveSafeZone(username, polygonPoints, groupName);

      if (successCreated) {
        context.read<SaveZoneBloc>().add(GetAllSaveZoneEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Safe zone saved successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating, // Prevent FAB from moving
            margin: EdgeInsets.only(
                bottom: 500, left: 40, right: 40), // Adjust spacing if needed
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save the safe zone. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Prevent FAB from moving
            margin: EdgeInsets.only(
                bottom: 500, left: 40, right: 40), // Adjust spacing if needed
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Prevent FAB from moving
            margin: const EdgeInsets.only(
                bottom: 500, left: 40, right: 40), // Adjust spacing if needed
            duration: const Duration(seconds: 3),
          ),
        );
    }
    _clearAllPoints();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    mapController = controller;
    await mapController?.setSymbolIconAllowOverlap(true);
    await mapController?.setSymbolTextAllowOverlap(true);
    final Uint8List markerIcon =
        await _getImageFromAsset('assets/location_icon1.jpg');
    await mapController?.addImage("location-icon1", markerIcon);
    await mapController?.addSymbol(SymbolOptions(
      geometry: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      iconImage: "location-icon1",
      iconSize: 0.3,
    ));
  }

  Future<Uint8List> _getImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Define New Group',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () => _saveSafeZone(context),
          ),
        ],
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
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
                MapControls(
                  onDrawPolygon: _drawSafeZonePolygon,
                  onClearPoints: _clearAllPoints,
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomDashboardScreen())),
        backgroundColor: Colors.green.shade300,
        child: Icon(Icons.home, size: 28, color: Colors.white),
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade300,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.map, color: Colors.white),
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
