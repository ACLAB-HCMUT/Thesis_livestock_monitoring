// import 'package:do_an_app/models/cow_model.dart';

// class CowEvent {}

// class CreateCowEvent extends CowEvent {
//   final CowModel cowModel;
//   CreateCowEvent({required this.cowModel});
// }

// class GetAllCowByUsernameEvent extends CowEvent {
//   final String username;
//   GetAllCowByUsernameEvent({required this.username});
// }

// class GetCowByIdEvent extends CowEvent{
//   final String cowId;
//   GetCowByIdEvent({required this.cowId});
// }

// class DeleteCowById extends CowEvent{
//   final String cowId;
//   DeleteCowById({required this.cowId});
// }

import 'package:equatable/equatable.dart';
import 'package:do_an_app/models/cow_model.dart';

abstract class CowEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateCowFieldsEvent extends CowEvent {
  final String cowId;
  final String? name;
  final int? age;
  final double? weight;
  final bool? isMale;
  final bool? isSick;
  final bool? isPregnant;
  final bool? isMedicated;

  UpdateCowFieldsEvent({
    required this.cowId,
    this.name,
    this.age,
    this.weight,
    this.isMale,
    this.isSick,
    this.isPregnant,
    this.isMedicated
  });

  @override
  List<Object?> get props => [cowId, name, age, weight, isMale, isSick, isPregnant, isMedicated];
}
class CreateCowEvent extends CowEvent {
  final int? cow_addr;
  final String? name;
  final int? age;
  final int? weight;
  final bool? isMale;
  CreateCowEvent({
    this.cow_addr,
    this.name,
    this.age,
    this.weight,
    this.isMale
  });

  @override
  List<Object?> get props => [cow_addr, name, age, weight, isMale];
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
class DeleteCowByIdEvent extends CowEvent {
  final String cowId;

  DeleteCowByIdEvent(this.cowId);

  @override
  List<Object?> get props => [cowId];
}


class CowDataChangedEvent extends CowEvent {
  final CowModel updatedCow;

  CowDataChangedEvent(this.updatedCow);

  @override
  List<Object> get props => [updatedCow];
}

