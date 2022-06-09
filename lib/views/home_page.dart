import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_assignment/database.dart';
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
  late HomeBloc1 homeBloc1;

  late Future<List<UserModel>> users;

  late Future<List<Map<String, dynamic>>> values;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc1 = BlocProvider.of<HomeBloc1>(context);
    homeBloc.add(fetchUserDetails());
    users = DatabaseHelper.instance.users();
    values = DatabaseHelper.instance.values();
    super.initState();
  }

  @override
  void dispose() {
    homeBloc.close();
    HomeBloc1().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
                    return buildListTile(
                      user: state.user,
                      values: state.values,
                      homeBloc1: BlocProvider.of<HomeBloc1>(context),
                    );
                  }

                  if (state is UserListFailureState) {
                    return FutureBuilder(
                      future: Future.wait([users, values]),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<UserModel>? user = snapshot.data?[0];
                          List<Map<String, dynamic>> values = snapshot.data?[1];
                          return buildListTile(
                            user: user,
                            values: values,
                            homeBloc1: BlocProvider.of<HomeBloc1>(context),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );

                    //   WidgetsBinding.instance.addPostFrameCallback((_) {
                    //     Scaffold.of(context).showSnackBar(
                    //         SnackBar(content: Text('Something went wrong!!')));
                    //   });
                  }

                  return Center(child: CircularProgressIndicator());
                }),
                BlocBuilder<HomeBloc1, HomeState1>(builder: (context, state) {
                  if (state is selectedUsersLoadedState) {
                    return ListView(
                        children: List.generate(
                      state.user!.length,
                      (index) {
                        return Visibility(
                            visible: state.values![index]
                                [state.user![index].id.toString()],
                            child: Column(
                              children: [
                                CheckboxListTile(
                                    title: Text('${state.user![index].login}'),
                                    value: state.values![index]
                                        [state.user![index].id!.toString()],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        state.values![index][state.user![index].id!
                                            .toString()] = value!;
                                      });
                                    },
                                    secondary: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                            imageUrl:
                                                '${state.user![index].avatarUrl}'),
                                      ],
                                    )),
                                SizedBox(height: 15)    
                              ],
                            ));
                      },
                    ));
                  }
                  return Center(child: Text('NO SELECTED USER'));
                }),
              ],
            )));
  }
}

class buildListTile extends StatefulWidget {
  List<UserModel>? user;
  List<Map<String, dynamic>>? values;
  HomeBloc1 homeBloc1;

  buildListTile({Key? key, this.user, this.values, required this.homeBloc1})
      : super(key: key);

  @override
  State<buildListTile> createState() => _buildListTileState();
}

class _buildListTileState extends State<buildListTile> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(
      widget.user!.length,
      (index) {
        return Column(
          children: [
            CheckboxListTile(
                title: Text('${widget.user![index].login}'),
                value: widget.values![index][widget.user![index].id.toString()],
                onChanged: (bool? value) {
                  setState(() {
                    widget.values![index][widget.user![index].id!.toString()] =
                        value!;

                    widget.homeBloc1.add(setSelectedUser(
                        user: widget.user, values: widget.values));
                  });
                },
                secondary: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                        imageUrl: '${widget.user![index].avatarUrl}'),
                  ],
                )),
            SizedBox(height: 15)
          ],
        );
      },
    ));
  }
}
