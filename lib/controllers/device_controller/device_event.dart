part of 'device_bloc.dart';

sealed class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}
class GetAllDeviceEvent extends DeviceEvent{
  GetAllDeviceEvent();
  @override
  List<Object> get props => [];
}
class DeleteDeviceIdEvent extends DeviceEvent{
  final String DeviceId;
  final String username;
  DeleteDeviceIdEvent(this.DeviceId , this.username);
  @override
  List<Object> get props => [DeviceId, username];
}
