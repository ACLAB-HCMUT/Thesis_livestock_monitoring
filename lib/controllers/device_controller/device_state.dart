part of 'device_bloc.dart';

sealed class DeviceState extends Equatable {
  const DeviceState();
  
  @override
  List<Object> get props => [];
}

final class DeviceInitial extends DeviceState {}
class DeviceLoading extends DeviceState{}
class DeviceLoaded extends DeviceState{
  final List<DeviceModel> devices;

  DeviceLoaded(this.devices);
  @override
  List<Object> get props => [devices];
}
class DeviceDeleting extends DeviceState {}
class DeviceDeleted extends DeviceState{
  final String DeviceId;
  DeviceDeleted(this.DeviceId);
  @override
  List<Object> get props => [DeviceId] ;
}

class DeviceError extends DeviceState{
  final String message;

  DeviceError(this.message);
  @override
  List<Object> get props => [message];
}


