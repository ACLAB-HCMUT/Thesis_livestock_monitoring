import 'package:do_an_app/models/device_model.dart';
import 'package:do_an_app/services/device_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_state.dart';
part 'device_event.dart';
class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial()) {
    on<GetAllDeviceEvent>(_onGetAllDevice);
    on<DeleteDeviceIdEvent>(_onDeleteDeviceById); 
  }
  Future<void> _onGetAllDevice(GetAllDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      List<DeviceModel>? Devices = await getAllDevice();
      print("Save zones : $Devices");
      emit(Devices != null ? DeviceLoaded(Devices) : DeviceError("No save zone found"));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
  Future<void> _onDeleteDeviceById(DeleteDeviceIdEvent event, Emitter<DeviceState> emit) async {
    emit((DeviceDeleting()));
    try {
      int? statusCode = await deleteDeviceById(event.DeviceId, event.username);
      emit(statusCode == 200 ? DeviceDeleted(event.DeviceId) : DeviceError("Failed to delete save zone"));
      if(state is DeviceDeleted){
        add(GetAllDeviceEvent());
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
