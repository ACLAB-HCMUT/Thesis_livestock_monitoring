import 'dart:async';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/screens/cow_location_screen/utils/map_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'widgets/map_controls.dart';
import 'services/location_service.dart';
import 'services/route_service.dart';

class CowLocationScreen extends StatefulWidget {
  const CowLocationScreen({Key? key}) : super(key: key);

  @override
  State<CowLocationScreen> createState() => _CowLocationScreenState();
}

class _CowLocationScreenState extends State<CowLocationScreen> {
  late MapLibreMapController mapController;
  late LatLng cowLocation;
  LatLng? ourLocation;
  StreamSubscription<Position>? positionStream;
  Symbol? ourSymbol;
  Symbol? cowSymbol;
  Line? routeLine;
  bool _showPath = false;
  bool firstTime = true;

  final LocationService _locationService = LocationService();
  final RouteService _routeService = RouteService();

  @override
  void initState() {
    super.initState();
    cowLocation = LatLng(10.88051796988531, 106.80433402260472);
    _locationService.determinePosition();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    mapController.onSymbolTapped.remove(_onCowSymbolTapped);
    super.dispose();
  }

  void _startLocationUpdates() {
    positionStream =
        _locationService.getPositionStream().listen((position) async {
      if (_showPath) {
        ourLocation = LatLng(position.latitude, position.longitude);
        await _updateMarkerPosition();
        await _updateRoute();
      }
    });
  }

  Future<void> _updateMarkerPosition() async {
    if (ourLocation == null) return;

    if (ourSymbol != null) {
      mapController.removeSymbol(ourSymbol!);
    }
    ourSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: ourLocation!,
        iconImage: "location-icon1",
        iconSize: 0.3,
      ),
    );
  }

  Future<void> _updateRoute() async {
    if (ourLocation != null) {
      final route = await _routeService.getRoute(ourLocation!, cowLocation);
      _drawRoute(route);
    }
  }

  void _drawRoute(List<LatLng> routeCoordinates) async {
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

  void _updateCowPosition(LatLng newLocation) async {
    if (mapController != null && cowSymbol != null) {
      cowLocation = newLocation;
      mapController.updateSymbol(
        cowSymbol!,
        SymbolOptions(geometry: cowLocation),
      );
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: cowLocation,
            zoom: 17.0,
          ),
        ),
        duration: const Duration(seconds: 3),
      );
      await _updateRoute();
    }
  }

  void _onCowSymbolTapped(Symbol symbol) async {
    if (symbol == cowSymbol) {
      final cowState = context.read<CowBloc>().state;
      if (cowState is CowLoaded) {
        final cow = cowState.cow;
        MapHelpers.showCowInfoBottomSheet(context, cow);
      }
    }
  }

  void _onMapCreated(MapLibreMapController controller) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userState = context.read<UserBloc>().state as UserLoaded;
    mapController = controller;
    await mapController.setSymbolIconAllowOverlap(true);
    await mapController.setSymbolTextAllowOverlap(true);

    mapController.onSymbolTapped.add(_onCowSymbolTapped);
    await MapHelpers.addImageFromAsset(
        mapController, 'assets/location_icon.jpg', "location-icon");
    final saveZoneState = context.read<SaveZoneBloc>().state;
    if (saveZoneState is SaveZoneLoaded) {
      for (var saveZone in saveZoneState.safeZones) {
        if (saveZone.username == userState.user.username) {
          // LatLng centerPoint =
          //     _routeService.calculateCenter(saveZone.safeZone!);
          // List<LatLng> polygons =
          //     _routeService.convertPointsToLatLng(saveZone.safeZone ?? []);
          // mapController.addFill(
          //   FillOptions(
          //     geometry: [
          //       [...polygons, polygons.first]
          //     ],
          //     fillColor: "#00FF00",
          //     fillOpacity: 0.4,
          //   ),
          // );
          // mapController.addLine(
          //   LineOptions(
          //     geometry: [...polygons, polygons.first],
          //     lineColor: "#000000",
          //     lineWidth: 2.0,
          //   ),
          // );
        }
      }
    }
    final cowState = context.read<CowBloc>().state;
    if (cowState is CowLoaded) {
      cowLocation =
          LatLng(cowState.cow.latestLatitude!, cowState.cow.latestLongitude!);
    }
    cowSymbol = await mapController.addSymbol(
      SymbolOptions(
        geometry: cowLocation,
        iconImage: "location-icon",
        iconSize: 0.3,
        iconOpacity: 0.7,
      ),
    );
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: cowLocation,
          zoom: 17.0,
        ),
      ),
      duration: const Duration(seconds: 3),
    );
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
          title: const Text(
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
                target: cowLocation,
                zoom: 17.0,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomDashboardScreen()),
            );
          },
          backgroundColor: Colors.green.shade300,
          child: Icon(Icons.home, size: 28, color: Colors.white),
          shape: const CircleBorder(),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green.shade300,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: MapControls(
            showPath: _showPath,
            onTogglePath: () {
              setState(() {
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
              });
            },
          ),
        ),
      ),
    );
  }
}
