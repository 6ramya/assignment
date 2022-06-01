import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_assignment/view_model/home_bloc.dart';
import 'package:technical_assignment/view_model/home_repository.dart';
import 'package:technical_assignment/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context)=>HomeRepository(),
        // child:BlocProvider(create: (_)=>HomeBloc(homeRepository: context.read<HomeRepository>()),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            // primaryColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        ));

  }
}
