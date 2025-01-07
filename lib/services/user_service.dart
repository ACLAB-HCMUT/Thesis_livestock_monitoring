import 'dart:convert';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/user_model.dart';
import 'package:http/http.dart' as http;
Future<UserModel?> postUser(
  String? username,
  String? password,
  String? fullname,
  int? global_address
) async {
  try{
    var url = Uri.http(serverUrl, '/user');
    var body = {
      if (username != null) 'username' : username,
      if (password != null) 'password': password,
      if (fullname != null) 'fullname': fullname,
      if (global_address != null) 'global_address': global_address,
    };
    var res = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if(res.statusCode == 200){
      print("Successfully create user");
      var bodyJson = jsonDecode(res.body);
      return UserModel.fromJson(bodyJson);
    }else if(res.statusCode == 424){
      print("Gateway not response");
      var bodyJson = jsonDecode(res.body);
      return UserModel.fromJson(bodyJson);
    }
    else{
      print("postUser failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("postUser failed, error: $err");
    return null;
  }
}
Future<UserModel?> updateUserByUsername(
  String? userId,
  String? username,
  String? fullname,
  int? global_address
) async {
  try {
    var url = Uri.http(serverUrl, '/user');
    var body = {
      if (username != null) 'username': username,
      if (fullname != null) 'fullname': fullname,
      if (global_address != null) 'global_address':global_address
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
      return UserModel.fromJson(bodyJson);
    } else {
      print("updateUserByUsername failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("updateUserByUsername failed, error: $err");
    return null;
  }
}


Future<UserModel?> getUserByUsername(String username) async {
  try{
    var url = Uri.http(serverUrl, '/user/$username');
    var res = await http.get(
      url
    );
    if(res.statusCode == 200){
      var bodyJson = jsonDecode(res.body);
      return UserModel.fromJson(bodyJson);
    }else {
      print("getUserByUsername failed, status code: ${res.statusCode}");
      return null;
    }
  }catch(err){
    print("getUserByUsername failed, error: $err");
    return null;
  }
}   


Future<int?> getAndIncrementGlobalAddress(
  String? username,
  String? cowId
) async {
  try {
    var url = Uri.http(serverUrl, '/user/global-address/$username');
    var body = {
      if (cowId != null) 'cowId': cowId,
    };
    var res = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      var responseBody  = jsonDecode(res.body);
      return responseBody['global_address']; 
    } else {
      print("getAndIncrementGlobalAddress failed, status code: ${res.statusCode}");
      return null;
    }
  } catch (err) {
    print("getAndIncrementGlobalAddress failed, error: $err");
    return null;
  }
}