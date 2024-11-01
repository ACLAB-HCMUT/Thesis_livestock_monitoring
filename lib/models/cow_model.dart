class CowModel {
  String? id;
  String name;
  int? cowAddr;
  String username;
  double? latestLatitude;
  double? latestLongitude;
  String? timestamp;

  CowModel(
    {
      required this.id,
      required this.name,
      required this.cowAddr,
      required this.username,
      required this.latestLatitude,
      required this.latestLongitude,
      required this.timestamp
    });
  
  Map<String, dynamic> toJson() {

    return {
      '_id': id,
      'name': name,
      'cow_addr': cowAddr,
      'username': username,
      'latest_latitude': latestLatitude,
      'latest_longitude': latestLongitude,
      'timestamp': timestamp,
    }..removeWhere((key, value) => value == null);
  }


  factory CowModel.fromJson(Map<String, dynamic> json) {
    return CowModel(
      id: json['_id'],
      name: json['name'],
      cowAddr: json.containsKey('cow_addr') ? json['cow_addr'] : null,
      username: json['username'],
      latestLatitude: json.containsKey('latest_latitude') ? json['latest_latitude'].toDouble() : null,
      latestLongitude: json.containsKey('latest_longitude') ? json['latest_longitude'].toDouble() : null,
      timestamp: json.containsKey('timestamp') ? json['timestamp'] : null,
    );
  }

  void showCowModel(){
    print('ID: $id');
    print('Name: $name');
    print('Cow Address: ${cowAddr ?? "Not available"}');
    print('Username: $username');
    print('Latest Latitude: ${latestLatitude ?? "Not available"}');
    print('Latest Longitude: ${latestLongitude ?? "Not available"}');
    print('Timestamp: ${timestamp ?? "Not available"}');
  }
}