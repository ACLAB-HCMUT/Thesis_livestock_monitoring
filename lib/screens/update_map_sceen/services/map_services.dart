import 'package:do_an_app/models/save_zone_model.dart';
import 'package:do_an_app/screens/safe_zone_screen/utils/map_helpers.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
class MapService {
  static Future<void> initializeMap(
    BuildContext context, 
    MapLibreMapController controller,
    List<CoordinatePoint> safeZones,
    List<LatLng> polygonPoints
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    await controller.setSymbolIconAllowOverlap(true);
    await controller.setSymbolTextAllowOverlap(true);
    polygonPoints = MapHelpers.convertPointsToLatLng(safeZones);
    MapHelpers.drawSafeZone(controller, polygonPoints);
  }
}