import 'dart:typed_data';

import 'package:do_an_app/models/cow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapHelpers {
  static Future<void> addImageFromAsset(MapLibreMapController controller,
      String assetPath, String imageName) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    await controller.addImage(imageName, bytes);
  }

  static Future<void> animateCameraToPosition(
      MapLibreMapController controller, LatLng target, double zoom) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom,
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  static void showCowInfoBottomSheet(BuildContext context,CowModel cow) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.all(16),
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

  static void drawSafeZone(MapLibreMapController controller, List<LatLng> polygons) {}
}
