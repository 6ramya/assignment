import 'package:equatable/equatable.dart';

import '../model/user_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class UserListInitialState extends HomeState {
  const UserListInitialState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UserListLoadingState extends HomeState {
  const UserListLoadingState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UserListLoadedState extends HomeState {
  List<UserModel>? user;
  List<Map<int, bool>>? values;

  UserListLoadedState(this.user, this.values);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
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

  selectedUsersLoadedState({this.user});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
