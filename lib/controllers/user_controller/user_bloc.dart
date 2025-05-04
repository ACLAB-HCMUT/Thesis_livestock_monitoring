import 'package:bloc/bloc.dart';
import 'package:do_an_app/models/user_model.dart';
import 'package:do_an_app/services/user_service.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<GetUserByUsernameEvent>(_onGetUserByUsername);
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutUserEvent>(_onLogoutUser);
    on<GetAllUserEvent>(_onGetAllUser);
    on<DeleteUserIdEvent>(_onDeleteUserById);
  }
  Future<void> _onDeleteUserById(DeleteUserIdEvent event, Emitter<UserState> emit) async {
    emit((UserDeleting()));
    try {
      int? statusCode = await deleteUserById(event.userId);
      emit(statusCode == 200 ? UserDeleted(event.userId) : UserError("Failed to delete user"));
      if(state is UserDeleted){
        add(GetAllUserEvent());
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  Future<void> _onGetAllUser(GetAllUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      List<UserModel>? users = await getAllUser();
      emit(users != null ? UsersLoaded(users) : UserError("No users found"));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? newUser = await postUser(
          event.username, event.password, event.fullname, event.global_address);
      emit(newUser != null
          ? UserLoaded(newUser)
          : UserError("Failed to register user"));
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
  Future<void> _onLoginUser(
    LoginUserEvent event,
    Emitter<UserState> emit
  )async{
    emit(UserLoading());
    try{
      UserModel? user = await LoginUser(event.username, event.password);
      emit(user!=null ? UserLoaded(user) : UserError("User not found"));
    }catch (e){
      emit(UserError(e.toString()));
    }
  }
}
Future<void> _onLogoutUser(
  LogoutUserEvent event,
  Emitter<UserState> emit
)async{
  emit(UserLoading());
}