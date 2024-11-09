// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class SafeZoneMap extends StatefulWidget {
  final List<CoordinatePoint> safeZones;
  final String name;

  const SafeZoneMap({super.key, required this.safeZones, required this.name});
  @override
  _SafeZoneMapState createState() => _SafeZoneMapState();
}

class _SafeZoneMapState extends State<SafeZoneMap> {
  MapLibreMapController? mapController;
  List<Symbol>? cowsSymbol;

  @override
  void initState() {
    super.initState();
    cowsSymbol = [];
  }

  Future<Uint8List> getImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  List<LatLng> convertPointsToLatLng(List<CoordinatePoint> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
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

  void _onMapCreated(MapLibreMapController controller) async {
    await Future.delayed(Duration(milliseconds: 100));
    mapController = controller;
    final Uint8List markerIcon =
        await getImageFromAsset('assets/location_icon.jpg');
    await mapController?.addImage("location-icon", markerIcon);

    List<LatLng> polygons = convertPointsToLatLng(widget.safeZones);
    for (LatLng point in polygons) {
      mapController?.addCircle(CircleOptions(
        geometry: point,
        circleColor: "#FF0000",
        circleRadius: 4,
      ));
    }

    mapController?.addFill(FillOptions(
      geometry: [polygons],
      fillColor:  "#00FF00", // Green to indicate the safe zone
      fillOpacity: 0.3,
    ));
    mapController?.addLine(
      LineOptions(
        geometry: [...polygons, polygons.first],
        lineColor: "#000000",
        lineWidth: 2.0,
      ),
    );
    final cowState = context.read<CowBloc>().state;
    if (cowState is CowsLoaded) {
      for (CowModel cow in cowState.cows) {
        Symbol? tmp = await mapController?.addSymbol(SymbolOptions(
          geometry: LatLng(cow.latestLatitude ?? 0, cow.latestLongitude ?? 0),
          iconImage: "location-icon",
          iconSize: 0.25,
        ));
        cowsSymbol?.add(tmp!);
      }
    }
  }

  void _updateCowPosition() async {
    final cowState = context.read<CowBloc>().state;
    if (mapController != null && cowsSymbol != null) {
      for (int i = 0; i < cowsSymbol!.length; i++) {
        CowModel cow = (cowState as CowsLoaded).cows[i];
        mapController!.updateSymbol(
          cowsSymbol![i],
          SymbolOptions(
              geometry: LatLng(cow.latestLatitude!, cow.latestLongitude!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng centerPoint = _calculateCenter(widget.safeZones);

    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowsLoaded) {
          _updateCowPosition();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.green[300],
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
                onMapCreated: _onMapCreated,
              ),
            ],
          )),
    );
  }
}
