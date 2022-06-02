import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_assignment/view_model/home_bloc.dart';
import 'package:technical_assignment/view_model/home_event.dart';
import 'package:technical_assignment/view_model/home_repository.dart';

import '../model/user_model.dart';
import '../view_model/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  List<UserModel> users = [];

  @override
  void initState() {
    homeBloc = HomeBloc(homeRepository: HomeRepository());
    homeBloc.add(fetchUserDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => homeBloc),
                BlocProvider(create: (context) => HomeBloc1())
              ],
              child: Scaffold(
                  appBar: AppBar(
                    title: Text('List Of Users'),
                    centerTitle: true,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          text: 'Users',
                        ),
                        Tab(text: 'Selected Users')
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                        if (state is UserListLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is UserListLoadedState) {
                          return ListView(
                              children: List.generate(
                                state.user!.length,
                                    (index) {
                                  return Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Text('${state.user![index].login}'),
                                        value: state.values![index]
                                        [state.user![index].id],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            state.values![index]
                                            [state.user![index].id!] = value!;
                                            if (value) {
                                              users.add(state.user![index]);
                                            }
                                            if (value == false) {
                                              users.remove(state.user![index]);
                                            }
                                            context
                                                .read<HomeBloc1>()
                                                .add(setSelectedUser(user: users));
                                          });
                                        },
                                        secondary: Image.network(
                                            '${state.user![index].avatarUrl}'),
                                      ),
                                      SizedBox(height: 15)
                                    ],
                                  );
                                },
                              ));
                        }
                        if (state is selectedUsersLoadedState) {
                          homeBloc.add(fetchUserDetails());
                        }
                        if(state is UserListFailureState){
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                      BlocBuilder<HomeBloc1, HomeState1>(
                          builder: (context, state) {
                        if (state is selectedUsersLoadedState) {
                          return ListView(
                              children: List.generate(
                            state.user!.length,
                            (index) {
                              return CheckboxListTile(
                                title: Text('${state.user![index].login}'),
                                value: true,
                                onChanged: (bool? value) {
                                  setState(() {});
                                },
                                secondary: Image.network(
                                    '${state.user![index].avatarUrl}'),
                              );
                            },
                          ));
                        }
                        return Center(child: Text('NO SELECTED USER'));
                      }),
                    ],
                  )))),
    );
  }



  }


