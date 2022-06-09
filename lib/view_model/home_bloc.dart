import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_assignment/database.dart';
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
        DatabaseHelper.instance.delete();
        List<UserModel>? response = await homeRepository.fetchUsers();

        var len = response!.length;
        List<Map<String, dynamic>>? values =
            List.generate(len, (index) => {
              response[index].id!.toString(): false});

        List.from(values).forEach((element)async {
          await DatabaseHelper.instance.insertValues(element);

        });
        emit(UserListLoadedState(response, values));
      } on Exception catch (e) {
        print('exception');
        emit(UserListFailureState(e.toString()));
      }
    });
  }
}

class HomeBloc1 extends Bloc<HomeEvent1, HomeState1> {
  HomeRepository? homeRepository;

  HomeBloc1({this.homeRepository}) : super(SelectedUserListInitialState()) {
    on<setSelectedUser>((event, emit) async {
      emit(selectedUsersLoadedState(user: event.user,values: event.values));
    });
    on<fetchSelectedUser>((event, emit) async {
      // emit(UserListLoadedState(response, values));
    });
  }
}
