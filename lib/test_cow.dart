import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:flutter/material.dart';

void createCow(String name){
  cowBloc.eventController.add(
    CreateCowEvent(cowModel: CowModel(id: null, name: name, cowAddr: null, 
                                      username: username, latestLatitude: null, 
                                      latestLongitude: null, timestamp: null)));
}

void getAllCowByUsername(String username){
  cowBloc.eventController.add(GetAllCowByUsernameEvent(username: username));
}

void getCowById(String cowId){
  cowBloc.eventController.add(GetCowByIdEvent(cowId: cowId));
}

void deleteCowById(String cowId){
  cowBloc.eventController.add(DeleteCowById(cowId: cowId));
}

class TestCowPage extends StatelessWidget {
  const TestCowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              getAllCowByUsername("than");
            },
            child: const Text("getAllCowByUsername"),
          ),
          ElevatedButton(
            onPressed: () {
              createCow("bo ${DateTime.now().millisecondsSinceEpoch}");
            },
            child: const Text("createCow"),
          ),
          ElevatedButton(
            onPressed: () {
              getCowById("67248cd044e5fb61cf41ac5c");
            },
            child: const Text("getCowById"),
          ),
          ElevatedButton(
            onPressed: () {
              deleteCowById("67248cd044e5fb61cf41ac5c");
            },
            child: const Text("deleteCowById"),
          )
        ],
      ),
    );
  }
}
