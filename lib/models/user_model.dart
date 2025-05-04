class UserModel {
  String? id;
  String? username;
  String? fullname;
  String? role;
  int? global_address;
  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.role,
    required this.global_address
  });
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'username': username,
      'fullname': fullname,
      'role': role,
      'global_address': global_address
    }..removeWhere((key, value) => value == null);
  }
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['_id'],
      username: json['username'],
      fullname: json['fullname'],
      role: json['role'],
      global_address: json['global_address'],
    );
  }
  void showUserModel(){
    print('ID: $id');
    print('Username: $username');
    print('Fullname: $fullname');
    print('Rolw: $role');
    print('Global address: $global_address');
  }
}