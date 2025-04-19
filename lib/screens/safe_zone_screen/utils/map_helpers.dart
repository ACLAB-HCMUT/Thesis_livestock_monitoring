import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapHelpers {
  static Future<Uint8List> getImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  static List<LatLng> convertPointsToLatLng(List<CoordinatePoint> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  static LatLng calculateCenter(List<CoordinatePoint> points) {
    double latSum = 0;
    double lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  static void drawSafeZone(MapLibreMapController controller, List<LatLng> polygons) {
    for (LatLng point in polygons) {
      controller.addCircle(CircleOptions(
        geometry: point,
        circleColor: "#FF0000",
        circleRadius: 4,
      ));
    }

    controller.addFill(FillOptions(
      geometry: [[...polygons, polygons.first]],
      fillColor: "#00FF00",
      fillOpacity: 0.3,
      fillOutlineColor: "#000000",
    ));

    controller.addLine(
      LineOptions(
        geometry: [...polygons, polygons.first],
        lineColor: "#000000",
        lineWidth: 2.0,
        lineJoin: "round", // Improve line join quality
      ),
    );
  }

  static Future<void> addCowMarkers(MapLibreMapController controller, List<CowModel> cows, Map<Symbol, CowModel> cowsSymbol) async {
    for (int i = 0; i < cows.length; i++) {
      Symbol? tmp = await controller.addSymbol(SymbolOptions(
        geometry: LatLng(cows[i].latestLatitude ?? 0, cows[i].latestLongitude ?? 0),
        iconImage: "location-icon",
        iconSize: 0.25,
        
      ));
      
      cowsSymbol[tmp] = cows[i];
    }
  }
  static void showCowInfoBottomSheet(BuildContext context,CowModel cow) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cow.name ?? "Unnamed Cow",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    cow.sick! ? Icons.warning : Icons.check_circle,
                    color: cow.sick! ? Colors.red : Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cow.sick! ? "Sick" : "Healthy",
                    style: TextStyle(
                      fontSize: 16,
                      color: cow.sick! ? Colors.red : Colors.green,
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Location: (${cow.latestLatitude?.toStringAsFixed(4)}, ${cow.latestLongitude?.toStringAsFixed(4)})",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Current status: (${cow.status})",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}