import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_assignment/model/mock_user_data.dart';
import 'package:technical_assignment/view_model/home_state.dart';

import '../model/user_model.dart';
import 'home_event.dart';
import 'home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(UserListInitialState()) {
    on<fetchUserDetails>((event, emit) async {
      emit(UserListLoadingState());
      try {
        List<UserModel>? response = await homeRepository.fetchUsers();
        var len = response!.length;
        List<Map<int, bool>>? values =
            List.generate(len, (index) => {response[index].id!: false});
        emit(UserListLoadedState(response, values));
      } on Exception catch (e) {
        emit(UserListFailureState(e.toString()));
      }
    });
  }
}

class HomeBloc1 extends Bloc<HomeEvent1, HomeState1> {
  HomeRepository? homeRepository;

  HomeBloc1({this.homeRepository}) : super(SelectedUserListInitialState()) {
    on<setSelectedUser>((event, emit) async {
      emit(selectedUsersLoadedState(user: event.user));
    });
    on<fetchSelectedUser>((event, emit) async {
      emit(selectedUsersLoadedState());
    });
  }
}
