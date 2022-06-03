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
  late HomeBloc1 homeBloc1;
  List<UserModel> users = [];

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc1 = BlocProvider.of<HomeBloc1>(context);
    homeBloc.add(fetchUserDetails());
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
                      users: users,
                      homeBloc1: BlocProvider.of<HomeBloc1>(context),
                    );
                  }

                  if (state is UserListFailureState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('${state.errorMessage}')));
                    });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
                BlocBuilder<HomeBloc1, HomeState1>(builder: (context, state) {
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
                          secondary:
                              Image.network('${state.user![index].avatarUrl}'),
                        );
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
  List<Map<int, bool>>? values;
  List<UserModel> users;
  HomeBloc1 homeBloc1;

  buildListTile(
      {Key? key,
      this.user,
      this.values,
      required this.users,
      required this.homeBloc1})
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
              value: widget.values![index][widget.user![index].id],
              onChanged: (bool? value) {
                setState(() {
                  widget.values![index][widget.user![index].id!] = value!;
                  if (value) {
                    widget.users.add(widget.user![index]);
                  }
                  if (value == false) {
                    widget.users.remove(widget.user![index]);
                  }
                  widget.homeBloc1.add(setSelectedUser(user: widget.users));
                });
              },
              secondary: Image.network('${widget.user![index].avatarUrl}'),
            ),
            SizedBox(height: 15)
          ],
        );
      },
    ));
  }
}
