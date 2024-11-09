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
  String? timestamp;
  CowModel(
    {
      required this.id,
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
      'medicated' : medicated,
      'sick': sick,
      'pregnant' : pregnant,
      'missing' : missing,
      'age' : age,
      'sex' : sex,
      'weight' : weight,
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
      medicated: json['medicated'] ,
      sick: json['sick'] ,
      pregnant: json['pregnant'] ,
      missing: json['missing'] ,
      age: json['age'] ,
      sex: json['sex'] ,
      weight: json['weight'] ,
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
    print('medicated: $medicated');
    print('sick: $sick');
    print('pregnant: $pregnant');
    print('missing: $missing');
    print('age: $age');
    print('sex: $sex');
    print('weight: $weight');
    print('Timestamp: ${timestamp ?? "Not available"}');
  }
}