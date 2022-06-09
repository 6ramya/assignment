import 'package:equatable/equatable.dart';

import '../model/user_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class UserListInitialState extends HomeState {
  const UserListInitialState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserListLoadingState extends HomeState {
  const UserListLoadingState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserListLoadedState extends HomeState {
  List<UserModel>? user;
  List<Map<String,dynamic>>? values;

  UserListLoadedState(this.user, this.values);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UserListFailureState extends HomeState {
  final String errorMessage;

  const UserListFailureState(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

abstract class HomeState1 extends Equatable {
  const HomeState1();
}

class SelectedUserListInitialState extends HomeState1 {
  const SelectedUserListInitialState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class selectedUsersLoadingState extends HomeState1 {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class selectedUsersLoadedState extends HomeState1 {
  List<UserModel>? user = [];
  List<Map<String,dynamic>>? values;

  selectedUsersLoadedState({this.user,this.values});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
