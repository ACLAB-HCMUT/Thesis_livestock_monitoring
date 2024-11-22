import 'package:bloc/bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:do_an_app/services/save_zone_service.dart';
import 'package:equatable/equatable.dart';

part 'save_zone_event.dart';
part 'save_zone_state.dart';

class SaveZoneBloc extends Bloc<SaveZoneEvent, SaveZoneState> {
  SaveZoneBloc() : super(SaveZoneInitial()) {
    on<GetAllSaveZoneEvent>(_onGetAllSaveZone);
    on<DeleteSaveZoneIdEvent>(_onDeleteSaveZoneById); 
  }
  Future<void> _onGetAllSaveZone(GetAllSaveZoneEvent event, Emitter<SaveZoneState> emit) async {
    emit(SaveZoneLoading());
    try {
      List<SaveZoneModel>? saveZones = await getAllSaveZone();
      print("Save zones : $saveZones");
      emit(saveZones != null ? SaveZoneLoaded(saveZones) : SaveZoneError("No save zone found"));
    } catch (e) {
      emit(SaveZoneError(e.toString()));
    }
  }
  Future<void> _onDeleteSaveZoneById(DeleteSaveZoneIdEvent event, Emitter<SaveZoneState> emit) async {
    emit((SaveZoneDeleting()));
    try {
      int? statusCode = await deleteSaveZoneById(event.saveZoneId, event.username);
      emit(statusCode == 200 ? SaveZoneDeleted(event.saveZoneId) : SaveZoneError("Failed to delete save zone"));
      if(state is SaveZoneDeleted){
        add(GetAllSaveZoneEvent());
      }
    } catch (e) {
      emit(SaveZoneError(e.toString()));
    }
  }
}
