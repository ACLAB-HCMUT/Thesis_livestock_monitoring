// import 'dart:async';

// import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
// import 'package:do_an_app/models/cow_model.dart';
// import 'package:do_an_app/services/cow_service.dart';

// class CowBloc {
//   var eventController = StreamController<CowEvent>();

//   var createCowStateController = StreamController<CowModel?>();
//   var getAllCowByUsernameStateController = StreamController<List<CowModel>?>();
//   var getCowByIdStateController = StreamController<CowModel?>();
//   var deleteCowByIdStateController = StreamController<int?>();
//   var deleteCowByUsernameStateController = StreamController<int?>();

//   CowBloc() {
//     eventController.stream.listen((event) async {
//       if(event is CreateCowEvent){
//         /* Call service to create new cow */
//         CowModel? newCow = await postCow(event.cowModel);
//         createCowStateController.sink.add(newCow);
//         return;
//       }

//       if(event is GetAllCowByUsernameEvent){
//         /* Call service to get all cow by username */
//         List<CowModel>? cowModels = await getAllCowByUsername(event.username);
//         if(cowModels != null){
//           for(final cowModel in cowModels){
//             print("-----------------------");
//             cowModel.showCowModel();
//             print("-----------------------");
//           }
//         }
//         getAllCowByUsernameStateController.sink.add(cowModels);
//         return;
//       }

//       if(event is GetCowByIdEvent){
//         /* Call service to get cow by cowId */
//         CowModel? cowModel = await getCowById(event.cowId);
//         if(cowModel != null){
//           cowModel.showCowModel();
//         }
//         getCowByIdStateController.sink.add(cowModel);
//         return;
//       }

//       if(event is DeleteCowById){
//         /* Call service to delete cow by cowId */
//         int? statusCode = await deleteCowById(event.cowId);
//         deleteCowByIdStateController.sink.add(statusCode);
//         return;
//       }

//     });
//   }


// }

// final cowBloc = CowBloc();


import 'package:do_an_app/services/cowService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/services/cow_service.dart';
import 'cow_event.dart';
import 'cow_state.dart';



class CowBloc extends Bloc<CowEvent, CowState> {
  final CowService cowService;

  CowBloc(this.cowService) : super(CowInitial()) {
    on<CreateCowEvent>(_onCreateCow);
    on<GetAllCowByUsernameEvent>(_onGetAllCowsByUsername);
    on<GetCowByIdEvent>(_onGetCowById);
    on<DeleteCowByIdEvent>(_onDeleteCowById);
    on<GetAllCowEvent>(_onGetAllCow);
    on<UpdateCowFieldsEvent>(_onUpdateCowById);
    on<CowDataChangedEvent>((event, emit) {
      if (state is CowsLoaded) {
        // Update cows list with the new data
        final updatedCows = List.from((state as CowsLoaded).cows);
        updatedCows.add(event.updatedCow);
        emit(CowsLoaded(updatedCows as List<CowModel>));
      }
    });

    // Listen to real-time updates from cowService

    cowService.cowUpdates.listen((updatedCow) {
      print("Database changed; triggering GetAllCowEvent. Id : " + updatedCow['documentKey']['_id']);
      if(state is CowLoaded && (state as CowLoaded).cow.id == updatedCow['documentKey']['_id']){
        print("daubuoi");
        add(GetCowByIdEvent(updatedCow['documentKey']['_id']));
      }
      else if(state is CowsLoaded && (state as CowsLoaded).cows.any((cow) => cow.id == updatedCow['documentKey']['_id'])){
        add(GetAllCowEvent());
      }
    });

  }
  Future<void> _onUpdateCowById(UpdateCowFieldsEvent event, Emitter<CowState> emit) async {
    emit(CowUpdating());

    try {
      final updatedCow = await updateCowById(
        event.cowId,
        event.name,
        event.age,
        event.weight,
        event.isMale,
        event.isSick,
        event.isPregnant,
        event.isMedicated
      );
      if (updatedCow != null) {
        emit(CowUpdated());
      } else {
        emit(CowError("Update failed"));
      }

      emit(CowUpdated()); 
    } catch (error) {
      emit(CowError('Failed to update cow'));
    }
  }


  Future<void> _onGetAllCow(GetAllCowEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      List<CowModel>? cows = await getAllCow();
      print("Cows : $cows");
      emit(cows != null ? CowsLoaded(cows) : CowError("No cows found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onCreateCow(CreateCowEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      CowModel? newCow = await postCow(
        event.cow_addr,
        event.name,
        event.age,
        event.weight,
        event.isMale
      );
      emit(newCow != null ? CowLoaded(newCow) : CowError("Failed to create cow"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onGetAllCowsByUsername(GetAllCowByUsernameEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      List<CowModel>? cows = await getAllCowByUsername(event.username);
      emit(cows != null ? CowsLoaded(cows) : CowError("No cows found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }
  Future<void> _onGetCowById(GetCowByIdEvent event, Emitter<CowState> emit) async {
    emit(CowLoading());
    try {
      CowModel? cow = await getCowById(event.cowId);
      print("Cow : $cow");
      emit(cow != null ? CowLoaded(cow) : CowError("Cow not found"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }

  Future<void> _onDeleteCowById(DeleteCowByIdEvent event, Emitter<CowState> emit) async {
    emit(CowDeleting());
    try {
      int? statusCode = await deleteCowById(event.cowId);
      emit(statusCode == 200 ? CowDeleted(event.cowId) : CowError("Failed to delete cow"));
    } catch (e) {
      emit(CowError(e.toString()));
    }
  }





}