import 'package:http/http.dart';

class CowModel {
  String? id;
  String name;
  int? cowAddr;
  String username;
  double? latestLatitude;
  double? latestLongitude;
  bool? medicated;
  bool? sick;
  bool? pregnant;
  bool? missing;
  int? age;
  bool? sex;
  int? weight;
  String? safeZoneId;
  String? status;
  String? timestamp;
  CowModel(
      {required this.id,
      required this.name,
      required this.cowAddr,
      required this.username,
      required this.latestLatitude,
      required this.latestLongitude,
      required this.medicated,
      required this.sick,
      required this.pregnant,
      required this.missing,
      required this.age,
      required this.sex,
      required this.weight,
      required this.safeZoneId,
      required this.status,
      required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'cow_addr': cowAddr,
      'username': username,
      'latest_latitude': latestLatitude,
      'latest_longitude': latestLongitude,
      'medicated': medicated,
      'sick': sick,
      'pregnant': pregnant,
      'missing': missing,
      'age': age,
      'sex': sex,
      'weight': weight,
      'safeZoneId': safeZoneId,
      'status': status,
      'timestamp': timestamp,
    }..removeWhere((key, value) => value == null);
  }

  factory CowModel.fromJson(Map<String, dynamic> json) {
    return CowModel(
      id: json['_id'],
      name: json['name'],
      cowAddr: json.containsKey('cow_addr') ? json['cow_addr'] : null,
      username: json['username'],
      latestLatitude: json.containsKey('latest_latitude')
          ? json['latest_latitude'].toDouble()
          : null,
      latestLongitude: json.containsKey('latest_longitude')
          ? json['latest_longitude'].toDouble()
          : null,
      medicated: json['medicated'],
      sick: json['sick'],
      pregnant: json['pregnant'],
      missing: json['missing'],
      age: json['age'],
      sex: json['sex'],
      weight: json['weight'],
      status: json['status'],
      safeZoneId: json['safeZoneId'],
      timestamp: json.containsKey('timestamp') ? json['timestamp'] : null,
    );
  }
  CowModel copyWith({
    String? id,
    String? name,
    int? cowAddr,
    String? username,
    double? latestLatitude,
    double? latestLongitude,
    bool? medicated,
    bool? sick,
    bool? pregnant,
    bool? missing,
    int? age,
    bool? sex,
    int? weight,
    String? safeZoneId,
    String? status,
    String? timestamp,
  }) {
    return CowModel(id: id??this.id, name: name ?? this.name, cowAddr: cowAddr?? this.cowAddr, username: username ?? this.username, latestLatitude: latestLatitude ?? this.latestLatitude, latestLongitude: latestLongitude ?? this.latestLongitude, medicated: medicated ?? this.medicated, sick: sick ?? this.sick, pregnant: pregnant ?? this.pregnant, missing: missing ?? this.missing, age: age ?? this.age, sex: sex ?? this.sex, weight: weight ?? this.weight, safeZoneId: safeZoneId ?? this.safeZoneId, status: status ?? this.status, timestamp: timestamp ?? this.timestamp);
  }

  void showCowModel() {
    print('ID: $id');
    print('Name: $name');
    print('Cow Address: ${cowAddr ?? "Not available"}');
    print('Username: $username');
    print('Latest Latitude: ${latestLatitude ?? "Not available"}');
    print('Latest Longitude: ${latestLongitude ?? "Not available"}');
    print('medicated: $medicated');
    print('sick: $sick');
    print('pregnant: $pregnant');
    print('missing: $missing');
    print('age: $age');
    print('sex: $sex');
    print('weight: $weight');
    print('safeZoneId: ${safeZoneId}');
    print('Timestamp: ${timestamp ?? "Not available"}');
    print('status: ${status}');
  }
}
