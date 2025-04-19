import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:do_an_app/screens/add_safe_zone_screen/utils/polygon_utils.dart';
import 'package:do_an_app/screens/safe_zone_screen/utils/map_helpers.dart';
import 'package:do_an_app/screens/safe_zone_screen/widgets/map_controls.dart';
import 'package:do_an_app/screens/update_map_sceen/services/map_services.dart';
import 'package:do_an_app/services/cow_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class UpdateMapScreen extends StatefulWidget {
  final List<CoordinatePoint> safeZones;
  final String name;
  const UpdateMapScreen(
      {super.key, required this.safeZones, required this.name});
  @override
  _UpdateMapScreenState createState() => _UpdateMapScreenState();
}

class _UpdateMapScreenState extends State<UpdateMapScreen> {
  MapLibreMapController? mapController;
  List<LatLng> polygonPoints = [];
  @override
  void initState() {
    super.initState();
    polygonPoints = MapHelpers.convertPointsToLatLng(widget.safeZones);
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

  void _clearAllPoints() {
    setState(() {
      polygonPoints.clear();
    });
    mapController?.clearFills();
    mapController?.clearCircles();
    mapController?.clearLines();
  }

  void _takeBackPoints() {
    _clearAllPoints();
    setState(() {
      polygonPoints = MapHelpers.convertPointsToLatLng(widget.safeZones);
    });
    MapHelpers.drawSafeZone(mapController!, polygonPoints);
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
              onPressed: () =>
                  Navigator.of(context).pop(groupName?.trim()), // Confirm
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updateSafeZone(BuildContext context) async {
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
    try {
      final username =
          (context.read<UserBloc>().state as UserLoaded).user.username ?? "";
      final successCreated =
          await updateSafeZone(username, polygonPoints, widget.name);
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

  @override
  Widget build(BuildContext context) {
    LatLng centerPoint = MapHelpers.calculateCenter(widget.safeZones);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update map (${widget.name})",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () => _updateSafeZone(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString:
                "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
            initialCameraPosition: CameraPosition(
              target: centerPoint,
              zoom: 17.5,
            ),
            onMapCreated: (controller) {
              MapService.initializeMap(
                  context, controller, widget.safeZones, polygonPoints);
              mapController = controller;
            },
            onMapClick: (point, latLng) => _addPoint(latLng),
          ),
          Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: FloatingActionButton(
                  heroTag: "btn0",
                  backgroundColor: Colors.green.shade200,
                  onPressed: _takeBackPoints, // Complete polygon
                  child: Icon(Icons.arrow_back),
                ),
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
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MapControls.buildFloatingActionButton(context),
      bottomNavigationBar: MapControls.buildBottomAppBar(),
    );
  }
}
