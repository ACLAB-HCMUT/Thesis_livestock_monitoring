import 'package:do_an_app/models/cow_model.dart';

class CowEvent {}

class CreateCowEvent extends CowEvent {
  final CowModel cowModel;
  CreateCowEvent({required this.cowModel});
}

class GetAllCowByUsernameEvent extends CowEvent {
  final String username;
  GetAllCowByUsernameEvent({required this.username});
}

class GetCowByIdEvent extends CowEvent{
  final String cowId;
  GetCowByIdEvent({required this.cowId});
}

class DeleteCowById extends CowEvent{
  final String cowId;
  DeleteCowById({required this.cowId});
}