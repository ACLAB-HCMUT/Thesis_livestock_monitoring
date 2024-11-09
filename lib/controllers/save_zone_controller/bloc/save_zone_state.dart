part of 'save_zone_bloc.dart';

sealed class SaveZoneState extends Equatable {
  const SaveZoneState();
  
  @override
  List<Object> get props => [];
}

final class SaveZoneInitial extends SaveZoneState {}
class SaveZoneLoading extends SaveZoneState{}
class SaveZoneLoaded extends SaveZoneState{
  final List<SaveZoneModel> safeZones;

  SaveZoneLoaded(this.safeZones);
  @override
  List<Object> get props => [safeZones];
}
class SaveZoneDeleting extends SaveZoneState {}
class SaveZoneDeleted extends SaveZoneState{
  final String saveZoneId;
  SaveZoneDeleted(this.saveZoneId);
  @override
  List<Object> get props => [saveZoneId] ;
}

class SaveZoneError extends SaveZoneState{
  final String message;

  SaveZoneError(this.message);
  @override
  List<Object> get props => [message];
}


