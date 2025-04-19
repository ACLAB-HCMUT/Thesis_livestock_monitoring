import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:math';

class PolygonUtils {
  static List<LatLng> sortPoints(List<LatLng> points) {
    if (points.isEmpty) return [];
    double centerX = points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
    double centerY = points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length;

    points.sort((a, b) {
      double angleA = atan2(a.latitude - centerX, a.longitude - centerY);
      double angleB = atan2(b.latitude - centerX, b.longitude - centerY);
      return angleA.compareTo(angleB);
    });

    return points;
  }
}