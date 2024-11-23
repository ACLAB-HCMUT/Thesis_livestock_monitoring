part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}
class UpdateUserEvent extends UserEvent{
  final String userId;
  final String? username;
  final String? fullname;
  final int? global_address;
  UpdateUserEvent({
    required this.userId,
    this.username,
    this.fullname,
    this.global_address 
  });
  @override
  List<Object> get props => [userId, username ?? "", fullname ?? "", global_address?? ""];
}

class CreateUserEvent extends UserEvent {
  final String username;
  final String password;
  final String fullname;
  final int? global_address;
  CreateUserEvent({
    required this.username,
    required this.password,
    required this.fullname,
    this.global_address
  });
  @override
  List<Object> get props => [
    username, password, fullname, global_address??1
  ];
}
class GetUserByUsernameEvent extends UserEvent{
  final String username;
  GetUserByUsernameEvent(this.username);
  @override
  List<Object> get props => [username];
}
