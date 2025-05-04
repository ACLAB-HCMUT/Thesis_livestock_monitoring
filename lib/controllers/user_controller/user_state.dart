part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}
final class UserInitial extends UserState {}
final class UserLoading extends UserState {}
final class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
  @override
  List<Object> get props => [user];
}
final class UsersLoaded extends UserState {
  final List<UserModel> users;
  UsersLoaded(this.users);
  @override
  List<Object> get props => [users];
}

final class UserUpdating extends UserState {}
final class UserUpdated extends UserState {
  final UserModel user;

  UserUpdated(this.user);
  @override
  List<Object> get props => [user];
}

final class UserDeleting extends UserState {}
final class UserDeleted extends UserState {
  final String userId;
  UserDeleted(this.userId);
  @override
  List<Object> get props => [userId];
}
final class UserError extends UserState{
  final String message;

  UserError(this.message);
  @override
  List<Object> get props => [message];
}