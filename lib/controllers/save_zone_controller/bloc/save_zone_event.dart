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
class DeleteSaveZoneyIdEvent extends SaveZoneEvent{
  final String saveZoneId;
  DeleteSaveZoneyIdEvent(this.saveZoneId);
  @override
  List<Object> get props => [saveZoneId];
}
