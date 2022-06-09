import 'package:equatable/equatable.dart';

import '../model/user_model.dart';

abstract class HomeEvent extends Equatable {}

class fetchUserDetails extends HomeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

abstract class HomeEvent1 extends Equatable {}

class setSelectedUser extends HomeEvent1 {
  List<UserModel>? user;
  List<Map<String,dynamic>>? values;

  setSelectedUser({this.user,this.values});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class fetchSelectedUser extends HomeEvent1 {
  List<UserModel>? user;
  List<Map<int,bool>>? values;

  fetchSelectedUser({this.values, this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
