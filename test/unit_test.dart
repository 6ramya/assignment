import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:technical_assignment/model/mock_user_data.dart';
import 'package:technical_assignment/model/user_model.dart';
import 'package:technical_assignment/view_model/home_bloc.dart';
import 'package:technical_assignment/view_model/home_event.dart';
import 'package:technical_assignment/view_model/home_repository.dart';
import 'package:technical_assignment/view_model/home_state.dart';
import 'package:dio/dio.dart' as dio;

import 'unit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<HomeRepository>(
      as: #MockHomeRepository, returnNullOnMissingStub: true)
])
void main() {
  group('HomeBloc test', () {
    MockHomeRepository mockHomeRepository;
    mockHomeRepository = MockHomeRepository();

    blocTest<HomeBloc, HomeState>(
        'emits [UserListLoadingState,UserListLoadedState] states for successful task loads',
        build: () {
          when(mockHomeRepository.fetchUsers())
              .thenAnswer((_) async => mockUsers);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(fetchUserDetails()),

        expect: () => [
              UserListLoadingState(),
              UserListLoadedState(mockUsers, mockValues),
            ]);

    blocTest<HomeBloc, HomeState>(
        'emits [UserListLoadingState,UserListFailureState] states for unsuccessful task loads',
        build: () {
          when(mockHomeRepository.fetchUsers()).thenThrow(Exception('error'));
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(fetchUserDetails()),
        wait: const Duration(seconds: 2),
        expect: () => [
              UserListLoadingState(),
              UserListFailureState('error occured'),
            ]
    );

  });
}
