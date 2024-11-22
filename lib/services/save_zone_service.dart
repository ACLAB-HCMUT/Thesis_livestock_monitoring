import 'dart:convert';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:http/http.dart' as http;

Future<List<SaveZoneModel>?> getAllSaveZone() async {
  try{
    var url = Uri.http(serverUrl, '/safezones/all');

    var res = await http.get(
      url
    );

    if(res.statusCode == 200){
      //print("Res body : ${res.body}");
      List<dynamic> saveZoneModelJsons = json.decode(res.body);
      //print("Res body json : ${saveZoneModelJsons}");
      //print("Res body saveZoneModelJsons type: ${saveZoneModelJsons.runtimeType}");

      List<SaveZoneModel> saveZoneModels = [];
      for(final saveZoneModelJson in saveZoneModelJsons){
        //print("Res body xxxx : ${saveZoneModelJson.runtimeType}");
        saveZoneModels.add(SaveZoneModel.fromJson(saveZoneModelJson));
      }
      return saveZoneModels;
    }else {
      print("getAllSaveZone failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getAllSaveZone failed, error: $err");
    return null;
  }
}

Future<List<SaveZoneModel>?> getSafeZoneByUsername(
  String username
) async {
  try{
    var url = Uri.http(serverUrl, '/safezones/username/$username');
    var res = await http.get(
      url
    );

    if(res.statusCode == 200){
      List<dynamic> saveZoneModelJsons = json.decode(res.body);
      
      List<SaveZoneModel> saveZoneModels = [];
      for(final saveZoneModelJson in saveZoneModelJsons){
        saveZoneModels.add(SaveZoneModel.fromJson(saveZoneModelJson));
      }
      return saveZoneModels;
    }else {
      print("getSafeZoneByUsername failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getSafeZoneByUsername failed, error: $err");
    return null;
  }
}

Future<int?> deleteSaveZoneById(String saveZoneId, String username) async {
  try{
    var url = Uri.http(serverUrl, '/safezones/$username/$saveZoneId');

    var res = await http.delete(
      url);
    
    if(res.statusCode == 200){
      print("Delete success");
      return 200;
    }else{
      print("deleteSaveZoneById failed, status code: ${res.statusCode}");  
      return res.statusCode;
    }

  }catch(err){
    print("deleteSaveZoneById failed, error: $err");
    return null;
  }
}

