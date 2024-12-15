import 'package:equatable/equatable.dart';

abstract class CowEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateCowFieldsEvent extends CowEvent {
  final String username;
  final String cowId;
  final String? name;
  final int? age;
  final double? weight;
  final bool? isMale;
  final bool? isSick;
  final bool? isPregnant;
  final bool? isMedicated;
  final String? safeZoneId;

  UpdateCowFieldsEvent(
      {required this.username,
      required this.cowId,
      this.name,
      this.age,
      this.weight,
      this.isMale,
      this.isSick,
      this.isPregnant,
      this.isMedicated,
      this.safeZoneId});

  @override
  List<Object?> get props => [
        username,
        cowId,
        name,
        age,
        weight,
        isMale,
        isSick,
        isPregnant,
        isMedicated,
        safeZoneId
      ];
}

class CreateCowEvent extends CowEvent {
  final int? cow_addr;
  final String? name;
  final String? username;
  final int? age;
  final int? weight;
  final bool? isMale;
  final String? safeZoneId;
  CreateCowEvent(
      {this.cow_addr,
      this.name,
      this.username,
      this.age,
      this.weight,
      this.isMale,
      this.safeZoneId});

  @override
  List<Object?> get props =>
      [cow_addr, name, username, age, weight, isMale, safeZoneId];
}

class GetAllCowEvent extends CowEvent {
  GetAllCowEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCowByUsernameEvent extends CowEvent {
  final String username;

  GetAllCowByUsernameEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class GetCowByIdEvent extends CowEvent {
  final String cowId;

  GetCowByIdEvent(this.cowId);

  @override
  List<Object?> get props => [cowId];
}

class UpdatedCowLocationMQTTEvent extends CowEvent {
  final String cowId;
  final double latitude;
  final double longitude;

  UpdatedCowLocationMQTTEvent(this.cowId, this.latitude, this.longitude);
  @override
  List<Object?> get props => [cowId, latitude, longitude];
}
class UpdatedCowSatusMQTTEvent extends CowEvent {
  final String cowId;
  final String status;
  UpdatedCowSatusMQTTEvent(this.cowId, this.status);
  @override
  List<Object?> get props => [cowId, status];
}


class DeleteCowByIdEvent extends CowEvent {
  final String cowId;
  final String username;

  DeleteCowByIdEvent(this.cowId, this.username);

  @override
  List<Object?> get props => [cowId, username];
}