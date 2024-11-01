import 'dart:convert';

import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:http/http.dart' as http;


Future<CowModel?> postCow(CowModel cowModel) async {
  try{
    var url = Uri.http(serverUrl, '/cow');
    var body = cowModel.toJson();
    var res = await http.post(
      url,
      body: body);
    if(res.statusCode == 200){
      var bodyJson = jsonDecode(res.body);
      return CowModel.fromJson(bodyJson);
    }else{
      print("postCow failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("postCow failed, error: $err");
    return null;
  }
}

Future<CowModel?> getCowById(String cowId) async {
  try{
    var url = Uri.http(serverUrl, '/cow/$cowId');

    var res = await http.get(
      url
    );
    
    if(res.statusCode == 200){
      var bodyJson = jsonDecode(res.body);
      return CowModel.fromJson(bodyJson);
    }else {
      print("getCowById failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getCowById failed, error: $err");
    return null;
  }
}

Future<List<CowModel>?> getAllCowByUsername(String username) async {
  try{
    var url = Uri.http(serverUrl, '/cow/username/$username');

    var res = await http.get(
      url
    );


    if(res.statusCode == 200) {
      List<dynamic> cowModelJsons = json.decode(res.body);
      
      List<CowModel> cowModels = [];
      for(final cowModelJson in cowModelJsons){
        cowModels.add(CowModel.fromJson(cowModelJson));
      }
      
      return cowModels;
    }else{
      print("getAllCowByUsername failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getAllCowByUsername failed, error: $err");
    return null;
  }
}

Future<int?> deleteCowById(String cowId) async {
  try{
    var url = Uri.http(serverUrl, '/cow/$cowId');

    var res = await http.delete(
      url);
    
    if(res.statusCode == 200){
      print("Delete success");
      return 200;
    }else{
      print("deleteCowById failed, status code: ${res.statusCode}");  
      return res.statusCode;
    }

  }catch(err){
    print("deleteCowById failed, error: $err");
    return null;
  }
}


Future<int?> deleteCowByUsername(String username) async {
  try{
    var url = Uri.http(serverUrl, '/cow/id');
    var headers = {'username': username};

    var res = await http.delete(
      url,
      headers: headers);
    
    if(res.statusCode == 200){
      return 200;
    }else{
      print("deleteCowByUsername failed, status code: ${res.statusCode}");  
      return res.statusCode;
    }

  }catch(err){
    print("deleteCowByUsername failed, error: $err");
    return null;
  }
}