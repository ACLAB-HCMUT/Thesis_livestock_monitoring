import 'dart:async';

import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/services/cow_service.dart';

class CowBloc {
  var eventController = StreamController<CowEvent>();

  var createCowStateController = StreamController<CowModel?>();
  var getAllCowByUsernameStateController = StreamController<List<CowModel>?>();
  var getCowByIdStateController = StreamController<CowModel?>();
  var deleteCowByIdStateController = StreamController<int?>();
  var deleteCowByUsernameStateController = StreamController<int?>();

  CowBloc() {
    eventController.stream.listen((event) async {
      if(event is CreateCowEvent){
        /* Call service to create new cow */
        CowModel? newCow = await postCow(event.cowModel);
        createCowStateController.sink.add(newCow);
        return;
      }

      if(event is GetAllCowByUsernameEvent){
        /* Call service to get all cow by username */
        List<CowModel>? cowModels = await getAllCowByUsername(event.username);
        if(cowModels != null){
          for(final cowModel in cowModels){
            print("-----------------------");
            cowModel.showCowModel();
            print("-----------------------");
          }
        }
        getAllCowByUsernameStateController.sink.add(cowModels);
        return;
      }

      if(event is GetCowByIdEvent){
        /* Call service to get cow by cowId */
        CowModel? cowModel = await getCowById(event.cowId);
        if(cowModel != null){
          cowModel.showCowModel();
        }
        getCowByIdStateController.sink.add(cowModel);
        return;
      }

      if(event is DeleteCowById){
        /* Call service to delete cow by cowId */
        int? statusCode = await deleteCowById(event.cowId);
        deleteCowByIdStateController.sink.add(statusCode);
        return;
      }

    });
  }


}

final cowBloc = CowBloc();