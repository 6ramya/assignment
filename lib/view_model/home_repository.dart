import 'dart:convert';

import '../model/user_model.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final Dio _dio=Dio();

  Future<List<UserModel>?> fetchUsers() async{
    final url='https://api.github.com/users';
    List<UserModel>? user=[];
    try{
      Response response=await _dio.get(url);
      if(response.statusCode==200){
        user=List.from(response.data).map((e) =>
            UserModel.fromJson(e)).toList();
    }else{
        print('error message ${response.statusMessage}');
      }
      }
    on DioError catch(e){
      print('error $e');
    }

    return user;

  }
}