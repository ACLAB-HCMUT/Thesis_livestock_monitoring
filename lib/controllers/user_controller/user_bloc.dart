import 'package:bloc/bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<GetUserByUsernameEvent>(_onGetUserByUsername);
  }
  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? newUser = await postUser(
          event.username, event.password, event.fullname, event.global_address);
      emit(newUser != null
          ? UserLoaded(newUser)
          : UserError("Failed to create user"));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  Future<void> _onUpdateUser(
    UpdateUserEvent event, Emitter<UserState> emit
  ) async{
    emit(UserUpdating());
    try {
      final updatedUser = await updateUserByUsername(
        event.userId,
        event.username,
        event.fullname,
        event.global_address
      );
      if(updatedUser != null){
        emit(UserUpdated(updatedUser));
      }else{
        emit(UserError("Failed to update user"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  Future<void> _onGetUserByUsername(
    GetUserByUsernameEvent event,
    Emitter<UserState> emit
  ) async{
    emit(UserLoading());
    try {
      UserModel? user = await getUserByUsername(event.username);
      emit(user!=null ? UserLoaded(user) : UserError("User not found"));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }


}
