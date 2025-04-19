import 'dart:convert';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

Future<bool> updateSafeZone(
    String username, List<LatLng> polygonPoints, String groupId) async {
  final safeZoneData = polygonPoints
      .map(
          (point) => {'latitude': point.latitude, 'longitude': point.longitude})
      .toList();
  final body = jsonEncode(
      {'username': username, 'safeZone': safeZoneData, "groupId": groupId});
  var res = await http.put(
    Uri.http(serverUrl, '/safezones/$username'),
    body: body,
    headers: {'Content-Type': 'application/json'},
  );
  if (res.statusCode == 200) {
    print("Successfully update safe zone");
    return true;
  } else {
    print("saveSafeZone failed, status code: ${res.statusCode}");
    return false;
  }
}

Future<bool> saveSafeZone(
    String username, List<LatLng> polygonPoints, String groupId) async {
  final safeZoneData = polygonPoints
      .map(
          (point) => {'latitude': point.latitude, 'longitude': point.longitude})
      .toList();
  final body = jsonEncode(
      {'username': username, 'safeZone': safeZoneData, "groupId": groupId});
  var res = await http.post(
    Uri.http(serverUrl, '/safezones/$username'),
    body: body,
    headers: {'Content-Type': 'application/json'},
  );
  if (res.statusCode == 201) {
    print("Successfully create safe zone");
    return true;
  } else {
    print("saveSafeZone failed, status code: ${res.statusCode}");
    return false;
  }
}

Future<CowModel?> postCow(int? cow_addr, String? name, String? username,
    int? age, int? weight, bool? isMale, String? safeZoneId) async {
  try {
    var url = Uri.http(serverUrl, '/cow/$username');
    var body = {
      if (cow_addr != null) 'cow_addr': cow_addr,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (age != null) 'age': age,
      if (weight != null) 'weight': weight,
      if (isMale != null) 'sex': isMale,
      if (safeZoneId != null) 'safeZoneId': safeZoneId,
    };
    var res = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      print("Successfully create cow");
      var bodyJson = jsonDecode(res.body);
      return CowModel.fromJson(bodyJson);
    } else if (res.statusCode == 424) {
      print("Gateway not response");
      var bodyJson = jsonDecode(res.body);
      return CowModel.fromJson(bodyJson);
    } else {
      print("postCow failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("postCow failed, error: $err");
    return null;
  }
}

Future<CowModel?> updateCowById(
    String username,
    String cowId,
    String? name,
    int? age,
    double? weight,
    bool? isMale,
    bool? isSick,
    bool? isPregnant,
    bool? isMedicated,
    String? groupId,
    int? cowAddress) async {
  try {
    var url = Uri.http(serverUrl, '/cow/$username/$cowId');
    // Build a map with only the non-null fields
    var body = {
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (weight != null) 'weight': weight,
      if (isMale != null) 'sex': isMale,
      if (isSick != null) 'sick': isSick,
      if (isPregnant != null) 'pregnant': isPregnant,
      if (isMedicated != null) 'medicated': isMedicated,
      if (groupId != null) 'groupId': groupId,
      if (cowAddress != null) 'cow_addr': cowAddress,
      'username': username,
    };
    var res = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      var bodyJson = jsonDecode(res.body);

      return CowModel.fromJson(bodyJson);
    } else {
      print("updateCow failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("updateCow failed, error: $err");
    return null;
  }
}

Future<CowModel?> getCowById(String cowId) async {
  try {
    var url = Uri.http(serverUrl, '/cow/$cowId');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var bodyJson = jsonDecode(res.body);
      return CowModel.fromJson(bodyJson);
    } else {
      print("getCowById failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("getCowById failed, error: $err");
    return null;
  }
}

Future<List<CowModel>?> getAllCow() async {
  try {
    var url = Uri.http(serverUrl, '/cow/api/all');
    var res = await http.get(url);

    if (res.statusCode == 200) {
      List<dynamic> cowModelJsons = json.decode(res.body);
      List<CowModel> cowModels = [];
      for (final cowModelJson in cowModelJsons) {
        cowModels.add(CowModel.fromJson(cowModelJson));
      }
      return cowModels;
    } else {
      print("getAllCow failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("getAllCow failed, error: $err");
    return null;
  }
}

Future<List<CowModel>?> getAllCowByUsername(String username) async {
  try {
    var url = Uri.http(serverUrl, '/cow/username/$username');

    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<dynamic> cowModelJsons = json.decode(res.body);

      List<CowModel> cowModels = [];
      for (final cowModelJson in cowModelJsons) {
        cowModels.add(CowModel.fromJson(cowModelJson));
      }

      return cowModels;
    } else {
      print("getAllCowByUsername failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("getAllCowByUsername failed, error: $err");
    return null;
  }
}

Future<int?> deleteCowById(String cowId, String username) async {
  try {
    var url = Uri.http(serverUrl, '/cow/$username/$cowId');

    var res = await http.delete(url);
    if (res.statusCode == 200) {
      print("Delete success");
      return 200;
    } else if (res.statusCode == 424) {
      print("Gateway not response");
      return 200;
    } else {
      print("deleteCowById failed, status code: ${res.statusCode}");
      return res.statusCode;
    }
  } catch (err) {
    print("deleteCowById failed, error: $err");
    return null;
  }
}

Future<int?> deleteCowByUsername(String username) async {
  try {
    var url = Uri.http(serverUrl, '/cow/id');
    var headers = {'username': username};

    var res = await http.delete(url, headers: headers);

    if (res.statusCode == 200) {
      return 200;
    } else {
      print("deleteCowByUsername failed, status code: ${res.statusCode}");
      return res.statusCode;
    }
  } catch (err) {
    print("deleteCowByUsername failed, error: $err");
    return null;
  }
}

// Get cow status history
Future<List<dynamic>> getCowStatusHistory(String cowId) async {
  try {
    final response = await http.get(
      Uri.http(serverUrl, '/cow/statusHistory/$cowId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load status history: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting cow status history: $e');
  }
}

// Get cow status analytics
Future<Map<String, dynamic>> getCowStatusAnalytics(String cowId, int days) async {
  try {
    final response = await http.get(
      Uri.http(serverUrl, '/cow/statusAnalytics/$cowId', {'days': '$days'}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load analytics: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting cow status analytics: $e');
  }
}
