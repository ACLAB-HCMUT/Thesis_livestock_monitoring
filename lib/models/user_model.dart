class UserModel {
  String? id;
  String? username;
  String? fullname;
  int? global_address;
  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.global_address
  });
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'username': username,
      'fullname': fullname,
      'global_address': global_address
    }..removeWhere((key, value) => value == null);
  }
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['_id'],
      username: json['username'],
      fullname: json['fullname'],
      global_address: json['global_address'],
    );
  }
  void showUserModel(){
    print('ID: $id');
    print('Username: $username');
    print('Fullname: $fullname');
    print('Global address: $global_address');
  }
}