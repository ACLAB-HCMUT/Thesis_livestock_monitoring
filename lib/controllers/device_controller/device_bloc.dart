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
    on<CreateDeviceEvent>(_onCreateDevice);
  }
  Future<void> _onGetAllDevice(GetAllDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      List<DeviceModel>? Devices = await getAllDevice();
      print("Save zones : $Devices");
      emit(Devices != null ? DeviceLoaded(Devices) : DeviceError("No device found"));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
  Future<void> _onDeleteDeviceById(DeleteDeviceIdEvent event, Emitter<DeviceState> emit) async {
    emit((DeviceDeleting()));
    try {
      int? statusCode = await deleteDeviceById(event.DeviceId);
      emit(statusCode == 200 ? DeviceDeleted(event.DeviceId) : DeviceError("Failed to delete device"));
      if(state is DeviceDeleted){
        add(GetAllDeviceEvent());
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
  Future<void> _onCreateDevice(CreateDeviceEvent event, Emitter<DeviceState> emit) async {
    emit((DeviceLoading()));
    try {
      int? statusCode = await addNewDeviceById(event.username);
      if(statusCode == 200){
        add(GetAllDeviceEvent());
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

}
