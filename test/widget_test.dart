import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:technical_assignment/main.dart';
import 'package:technical_assignment/model/mock_user_data.dart';
import 'package:technical_assignment/model/user_model.dart';
import 'package:technical_assignment/view_model/home_bloc.dart';
import 'package:technical_assignment/view_model/home_event.dart';
import 'package:technical_assignment/view_model/home_repository.dart';
import 'package:technical_assignment/view_model/home_state.dart';
import 'package:technical_assignment/views/home_page.dart';

import 'widget_test.mocks.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockHomeBloc1 extends MockBloc<HomeEvent1, HomeState1>
    implements HomeBloc1 {}

@GenerateMocks([], customMocks: [
  MockSpec<HomeRepository>(as: #MockRepository, returnNullOnMissingStub: true)
])
void main() {
  group('Fetch and display users', () {
    final mockHomeBloc = MockHomeBloc();
    final mockHomeBloc1 = MockHomeBloc1();
    MockRepository mockRepository;
    mockRepository = MockRepository();

    testWidgets('display fetched data', (widgetTester) async {
      whenListen(mockHomeBloc1,
          Stream.fromIterable([selectedUsersLoadedState(user: mockUsers)]),
          initialState: selectedUsersLoadedState(user: mockUsers));
      final findListView = find.byType(ListView);
      final findCheckBoxListTile = find.byType(CheckboxListTile);

      await mockNetworkImagesFor(() async {
        await widgetTester.pumpWidget(BlocProvider<HomeBloc>(
            create: (context) => MockHomeBloc(),
            child: MaterialApp(
                home: Scaffold(
                    body: buildListTile(
              user: mockUsers,
              values: mockValues,
              homeBloc1: mockHomeBloc1,
            )))));
      });

      expect(findListView, findsOneWidget);
      expect(findCheckBoxListTile, findsWidgets);
      expect(find.textContaining('mojombo'), findsOneWidget);
    });

    testWidgets('on tapping checkbox should return SelectedUserListLoadedState',
        (widgetTester) async {
      whenListen(mockHomeBloc1,
          Stream.fromIterable([selectedUsersLoadedState(user: mockUsers)]),
          initialState: selectedUsersLoadedState(user: mockUsers));
      final findCheckBoxListTile = find.byType(CheckboxListTile);

      await mockNetworkImagesFor(() async {
        await widgetTester.pumpWidget(BlocProvider<HomeBloc>(
            create: (context) => MockHomeBloc(),
            child: MaterialApp(
                home: Scaffold(
                    body: buildListTile(
              user: mockUsers,
              values: mockValues,
              homeBloc1: mockHomeBloc1,
            )))));
      });

      await widgetTester.tap(find.byType(CheckboxListTile));
      await widgetTester.pump();
      expect(mockHomeBloc1.state, selectedUsersLoadedState(user: mockUsers));
    });
  });
}
