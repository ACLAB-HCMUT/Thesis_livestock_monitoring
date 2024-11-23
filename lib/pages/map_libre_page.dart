// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:maplibre_gl/maplibre_gl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class MapLibrePage extends StatefulWidget {
//   const MapLibrePage({super.key});

//   @override
//   State<MapLibrePage> createState() => _MapLibrePageState();
// }

// class _MapLibrePageState extends State<MapLibrePage> {
//   late MapLibreMapController mapController;
//   final LatLng our_location = const LatLng(10.884371329012621, 106.77642979153909);
//   final LatLng cow_location = const LatLng(10.884557597732634, 106.78307362090611);

//   Future<Uint8List> getImageFromAsset(String path) async {
//     final ByteData data = await rootBundle.load(path);
//     return data.buffer.asUint8List();
//   }
//   void _onMapCreated(MapLibreMapController controller) async {
//     mapController = controller;
//     final Uint8List markerIcon = await getImageFromAsset('assets/location_icon.jpg');
//     await mapController.addImage("location-icon", markerIcon);

//     // Add Safe Zone Polygon
//     mapController.addFill(
//       const FillOptions(
//         geometry: [
//           [
//             LatLng(10.884287381838824, 106.78254358782938),
//             LatLng(10.884557597732634, 106.78307362090611),
//             LatLng(10.883997231712836, 106.78370514967838),
//             LatLng(10.883563113439486, 106.78290671687343),
//           ]
//         ],
//         fillColor: "#00FF00",
//         fillOpacity: 0.4,
//       ),
//     );

//     mapController.addSymbol(
//       SymbolOptions(
//         geometry: cow_location,
//         iconImage: "location-icon",
//         iconSize: 0.3,
//       ),
//     );

//     checkIfOutOfSafeZone(cow_location, [
//       LatLng(10.884287381838824, 106.78254358782938),
//       LatLng(10.884557597732634, 106.78307362090611),
//       LatLng(10.883997231712836, 106.78370514967838),
//       LatLng(10.883563113439486, 106.78290671687343),
//     ]);
//   }

//   bool pointInPolygon(LatLng point, List<LatLng> polygon) {
//     int intersectCount = 0;
//     for (int j = 0; j < polygon.length - 1; j++) {
//       if (rayCastIntersect(point, polygon[j], polygon[j + 1])) {
//         intersectCount++;
//       }
//     }
//     return ((intersectCount % 2) == 1);
//   }

//   bool rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
//     double aY = vertA.latitude;
//     double bY = vertB.latitude;
//     double aX = vertA.longitude;
//     double bX = vertB.longitude;
//     double pY = point.latitude;
//     double pX = point.longitude;

//     if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
//       return false;
//     }

//     double m = (aY - bY) / (aX - bX);
//     double bee = (-aX) * m + aY;
//     double x = (pY - bee) / m;

//     return x > pX;
//   }

//   void checkIfOutOfSafeZone(LatLng point, List<LatLng> polygon) async {
//     if (!pointInPolygon(point, polygon)) {
//       showWarning();
//       final route = await getRoute(our_location, cow_location);
//       drawRoute(route);
//     }
//   }

//   Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
//     final url = Uri.parse(
//         'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson');

//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

//       return coordinates
//           .map((coord) => LatLng(coord[1], coord[0]))
//           .toList();
//     } else {
//       throw Exception('Không thể lấy tuyến đường');
//     }
//   }

//   void drawRoute(List<LatLng> routeCoordinates) {
//     mapController.addLine(
//       LineOptions(
//         geometry: routeCoordinates,
//         lineColor: "#FF0000",
//         lineWidth: 4.0,
//         lineOpacity: 0.8,
//       ),
//     );
//   }

//   void showWarning() {
//     showDialog(
//       context: context,ơ
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Warning"),
//           content: const Text("The icon has moved out of the safe zone!"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MapLibreMap(
//         key: UniqueKey(),
//         styleString: "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: cow_location,
//           zoom: 17.0,
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';

class MapLibrePage extends StatefulWidget {
  const MapLibrePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapLibrePage> createState() => _MapLibrePageState();
}

class _MapLibrePageState extends State<MapLibrePage> {
  late MapLibreMapController mapController;
  late LatLng cow_location;
  late LatLng? our_location;
  StreamSubscription<Position>? positionStream;
  Symbol? ourSymbol;
  Line? routeLine;
  bool _showPath = false;
  String textButton = "Find Path";
  Symbol? cowSymbol;
  bool firstTime = true;

  Future<Uint8List> getImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  LatLng _calculateCenter(List<CoordinatePoint> points) {
    double latSum = 0;
    double lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  List<LatLng> convertPointsToLatLng(List<CoordinatePoint> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    cow_location = LatLng(10.88051796988531, 106.80433402260472);

    _determinePosition();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
  }

  void _startLocationUpdates() async {
    positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      if (_showPath) {
        our_location = LatLng(position.latitude, position.longitude);

        // Move marker and update route in real-time
        await _updateMarkerPosition();
        await _updateRoute();
      }
    });
  }

  Future<void> _updateMarkerPosition() async {
    final Uint8List markerIcon =
        await getImageFromAsset('assets/location_icon1.jpg');
    await mapController.addImage("location-icon1", markerIcon);
    if (ourSymbol != null) {
      mapController.removeSymbol(ourSymbol!);
    }
    ourSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: our_location!,
        iconImage: "location-icon1",
        iconSize: 0.3,
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) async {
    await Future.delayed(Duration(milliseconds: 500));
    mapController = controller;
    final Uint8List markerIcon =
        await getImageFromAsset('assets/location_icon.jpg');
    await mapController.addImage("location-icon", markerIcon);
    final saveZoneState = context.read<SaveZoneBloc>().state;
    if (saveZoneState is SaveZoneLoaded) {
      for (var saveZone in saveZoneState.safeZones) {
        LatLng centerPoint = _calculateCenter(saveZone.safeZone!);
        List<LatLng> polygons = convertPointsToLatLng(saveZone.safeZone ?? []);
        mapController.addFill(
          FillOptions(
            geometry: [polygons],
            fillColor: "#00FF00",
            fillOpacity: 0.4,
          ),
        );
        mapController.addSymbol(SymbolOptions(
          geometry: centerPoint,
          textField: "Safe Zone",
          textSize: 15.0,
          textColor: "#000000",
        ));

        mapController.addLine(
          LineOptions(
            geometry: [...polygons, polygons.first],
            lineColor: "#000000",
            lineWidth: 2.0,
          ),
        );
      }
    }
    final cowState = context.read<CowBloc>().state;
    if (cowState is CowLoaded) {
      cow_location = LatLng(
        cowState.cow.latestLatitude!,
        cowState.cow.latestLongitude!,
      );
    }

    // Add cow icon only once
    cowSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: cow_location,
        iconImage: "location-icon",
        iconSize: 0.3,
        iconOpacity: 0.7,
      ),
    );
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: cow_location,
          zoom: 17.0,
        ),
      ),
      duration: const Duration(seconds: 3), // Set animation duration
    );
  }

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];

      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Cannot fetch route');
    }
  }

  void drawRoute(List<LatLng> routeCoordinates) async {
    if (routeLine != null) {
      mapController.updateLine(
        routeLine!,
        LineOptions(
          geometry: routeCoordinates,
        ),
      );
    } else {
      routeLine = await mapController.addLine(
        LineOptions(
          geometry: routeCoordinates,
          lineColor: "#FF0000",
          lineWidth: 4.0,
          lineOpacity: 0.8,
        ),
      );
    }
  }

  Future<void> _updateRoute() async {
    if (our_location != null) {
      final route = await getRoute(our_location!, cow_location);
      drawRoute(route);
    } else {
      print("Current location not available");
    }
  }

  void _updateCowPosition(LatLng newLocation) async {
    if (mapController != null && cowSymbol != null) {
      cow_location = newLocation;

      mapController!.updateSymbol(
        cowSymbol!,
        SymbolOptions(geometry: cow_location),
      );
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: cow_location,
            zoom: 17.0,
          ),
        ),
        duration: const Duration(seconds: 3), // Set animation duration
      );
      await _updateRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) async {
        if (state is CowLoaded) {
          if (!firstTime) {
            _updateCowPosition(
                LatLng(state.cow.latestLatitude!, state.cow.latestLongitude!));
          } else {
            firstTime = false;
            Future.delayed(Duration(milliseconds: 500), () {
              _updateCowPosition(LatLng(
                  state.cow.latestLatitude!, state.cow.latestLongitude!));
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text(
            "Cow Location",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            MapLibreMap(
              key: UniqueKey(),
              styleString:
                  "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: cow_location,
                zoom: 17.0,
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
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
                  onPressed: () {
                    _showPath = !_showPath;

                    if (_showPath) {
                      _updateMarkerPosition();
                      _updateRoute();
                    } else {
                      if (ourSymbol != null) {
                        mapController.removeSymbol(ourSymbol!);
                        ourSymbol = null;
                      }
                      if (routeLine != null) {
                        mapController.removeLine(routeLine!);
                        routeLine = null;
                      }
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
