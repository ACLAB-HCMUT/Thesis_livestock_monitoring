import 'dart:convert';

import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/device_model.dart';
import 'package:http/http.dart' as http;

Future<List<DeviceModel>?> getAllDevice() async {
  try{
    var url = Uri.http(serverUrl, '/device/all');

    var res = await http.get(
      url
    );

    if(res.statusCode == 200){
      List<dynamic> DeviceModelJsons = json.decode(res.body);

      List<DeviceModel> DeviceModels = [];
      for(final DeviceModelJson in DeviceModelJsons){
        DeviceModels.add(DeviceModel.fromJson(DeviceModelJson));
      }
      return DeviceModels;
    }else {
      print("getAllDevice failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getAllDevice failed, error: $err");
    return null;
  }
}
Future<int?> deleteDeviceById(String DeviceId, String username) async {
  try{
    var url = Uri.http(serverUrl, '/device/$username/$DeviceId');

    var res = await http.delete(
      url);
    
    if(res.statusCode == 200){
      print("Delete success");
      return 200;
    }else{
      print("deleteDeviceById failed, status code: ${res.statusCode}");  
      return res.statusCode;
    }

  }catch(err){
    print("deleteDeviceById failed, error: $err");
    return null;
  }
}

