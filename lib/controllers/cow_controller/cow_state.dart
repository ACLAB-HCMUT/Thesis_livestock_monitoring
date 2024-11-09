import 'package:equatable/equatable.dart';
import 'package:do_an_app/models/cow_model.dart';
abstract class CowState extends Equatable {
  @override
  List<Object?> get props => [];
}
class CowInitial extends CowState {}
class CowLoading extends CowState {}
class CowLoaded extends CowState {
  final CowModel cow;

  CowLoaded(this.cow);

  @override
  List<Object?> get props => [cow];
}

class CowsLoaded extends CowState {
  final List<CowModel> cows;

  CowsLoaded(this.cows);

  @override
  List<Object?> get props => [cows];
}


class CowUpdating extends CowState {}
class CowUpdated extends CowState {}

class CowDeleting extends CowState {}
class CowDeleted extends CowState {
  final String cowId;

  CowDeleted(this.cowId);

  @override
  List<Object?> get props => [cowId];
}


class CowError extends CowState {
  final String message;

  CowError(this.message);

  @override
  List<Object?> get props => [message];
}

