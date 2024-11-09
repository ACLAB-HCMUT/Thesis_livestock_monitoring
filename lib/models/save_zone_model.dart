import 'dart:convert';

import 'package:maplibre_gl/maplibre_gl.dart';

class SaveZoneModel {
  String? id;
  List<CoordinatePoint>? safeZone;

  SaveZoneModel({
    this.id,
    this.safeZone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'safeZone': safeZone?.map((x) => x.toMap()).toList(),
    };
  }

  factory SaveZoneModel.fromMap(Map<String, dynamic> map) {
    return SaveZoneModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      safeZone: map['safeZone'] != null
          ? List<CoordinatePoint>.from(
              (map['safeZone'] as List<dynamic>).map<CoordinatePoint>(
                (x) => CoordinatePoint.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveZoneModel.fromJson(Map<String, dynamic> source) =>
      SaveZoneModel.fromMap(source);
}

class CoordinatePoint {
  double latitude;
  double longitude;

  CoordinatePoint(
    this.latitude,
    this.longitude,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory CoordinatePoint.fromMap(Map<String, dynamic> map) {
    return CoordinatePoint(
      map['latitude'],
      map['longitude'],
    );
  }
  String toJson() => json.encode(toMap());

  factory CoordinatePoint.fromJson(String source) =>
      CoordinatePoint.fromMap(json.decode(source) as Map<String, dynamic>);
  
}
