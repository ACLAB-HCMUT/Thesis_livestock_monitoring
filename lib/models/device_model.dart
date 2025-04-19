class DeviceModel {
  String? id;
  String? username;
  int? address;
  String? cow_id;
  String? device_name;
  DeviceModel({
    required this.id,
    required this.username,
    required this.address,
    required this.cow_id,
    required this.device_name
  });
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'username': username,
      'address': address,
      'cow_id': cow_id,
      'device_name': device_name
    }..removeWhere((key, value) => value == null);
  }
  factory DeviceModel.fromJson(Map<String, dynamic> json){
    return DeviceModel(
      id: json['_id'],
      username: json['username'],
      address: json['address'],
      cow_id: json['cow_id'],
      device_name: json['device_name'],
    );
  }
  void showUserModel(){
    print('ID: $id');
    print('Username: $username');
    print('address: $address');
    print('Global cow_id: $cow_id');
    print('device_name: $device_name');
  }
}