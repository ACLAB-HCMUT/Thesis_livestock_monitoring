// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/services/cow_service.dart';
import 'cow_event.dart';
import 'cow_state.dart';

class CowBloc extends Bloc<CowEvent, CowState> {

  CowBloc() : super(CowInitial()) {
    on<CreateCowEvent>(_onCreateCow);
    on<GetAllCowByUsernameEvent>(_onGetAllCowsByUsername);
    on<GetCowByIdEvent>(_onGetCowById);
    on<UpdatedCowLocationMQTTEvent>(_onUpdatedCowLocationMQTT);
    on<UpdatedCowSatusMQTTEvent>(_onUpdatedCowSatusMQTT);
    on<DeleteCowByIdEvent>(_onDeleteCowById);
    on<GetAllCowEvent>(_onGetAllCow);
    on<UpdateCowFieldsEvent>(_onUpdateCowById);
  }
  Future<void> _onUpdateCowById(
      UpdateCowFieldsEvent event, Emitter<CowState> emit) async {
    emit(CowUpdating());

    try {
      final updatedCow = await updateCowById(
          event.username,
          event.cowId,
          event.name,
          event.age,
          event.weight,
          event.isMale,
          event.isSick,
          event.isPregnant,
          event.isMedicated,
          event.safeZoneId);
      if (updatedCow != null) {
        emit(CowUpdated());
      } else {
        emit(CowError("Update failed"));
      }

    } catch (error) {
      emit(CowError('Failed to update cow'));
    }
  }
  Future<void> _onGetAllCow(
      GetAllCowEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      List<CowModel>? cows = await getAllCow();
      print("Cows : $cows");
      emit(cows != null ? CowsLoaded(cows) : CowError("No cows found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onCreateCow(
      CreateCowEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      CowModel? newCow = await postCow(
          event.cow_addr,
          event.name,
          event.username,
          event.age,
          event.weight,
          event.isMale,
          event.safeZoneId);
      emit(newCow != null
          ? CowLoaded(newCow)
          : CowError("Failed to create cow"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onGetAllCowsByUsername(
      GetAllCowByUsernameEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      List<CowModel>? cows = await getAllCowByUsername(event.username);
      emit(cows != null ? CowsLoaded(cows) : CowError("No cows found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onGetCowById(
      GetCowByIdEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      CowModel? cow = await getCowById(event.cowId);
      print("Cow : $cow");
      emit(cow != null ? CowLoaded(cow) : CowError("Cow not found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onUpdatedCowLocationMQTT(
      UpdatedCowLocationMQTTEvent event, Emitter<CowState> emit) async {
    final currentState = state;
    if (currentState is CowLoaded) {
      emit(CowLoaded(currentState.cow.copyWith(
        latestLatitude: event.latitude,
        latestLongitude: event.longitude
      )));
    }else if(currentState is CowsLoaded){
      List<CowModel> updatedCows = currentState.cows.map((cow){
        if(cow.id == event.cowId){
          return cow.copyWith(
            latestLatitude: event.latitude,
            latestLongitude: event.longitude
          );
        } 
        return cow;
      }).cast<CowModel>().toList();
      emit(CowsLoaded(updatedCows));
    }
  }

  Future<void> _onUpdatedCowSatusMQTT(
      UpdatedCowSatusMQTTEvent event, Emitter<CowState> emit) async {
    final currentState = state;
    if (currentState is CowLoaded) {
      emit(CowLoaded(currentState.cow.copyWith(status: event.status)));
    }
    else if(currentState is CowsLoaded){
      List<CowModel> updatedCows = currentState.cows.map((cow){
        if(cow.id == event.cowId){
          return cow.copyWith(
            status: event.status,
          );
        }
        return cow;
      }).cast<CowModel>().toList();
      emit(CowsLoaded(updatedCows));
    }
  }
  Future<void> _onDeleteCowById(
      DeleteCowByIdEvent event, Emitter<CowState> emit) async {
    emit(CowDeleting());
    try {
      int? statusCode = await deleteCowById(event.cowId, event.username);
      emit(statusCode == 200
          ? CowDeleted(event.cowId)
          : CowError("Failed to delete cow"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
}
