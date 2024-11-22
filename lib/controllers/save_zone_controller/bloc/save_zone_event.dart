part of 'save_zone_bloc.dart';

sealed class SaveZoneEvent extends Equatable {
  const SaveZoneEvent();

  @override
  List<Object> get props => [];
}
class GetAllSaveZoneEvent extends SaveZoneEvent{
  GetAllSaveZoneEvent();
  @override
  List<Object> get props => [];
}
class DeleteSaveZoneIdEvent extends SaveZoneEvent{
  final String saveZoneId;
  final String username;
  DeleteSaveZoneIdEvent(this.saveZoneId , this.username);
  @override
  List<Object> get props => [saveZoneId, username];
}
