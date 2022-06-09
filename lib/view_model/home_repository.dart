import 'dart:convert';

import '../database.dart';
import '../model/user_model.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final Dio _dio = Dio();

  Future<List<UserModel>?> fetchUsers() async {
    final url = 'https://api.github.com/users';
    List<UserModel>? user = [];
    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        List.from(response.data).forEach((element) async {
          await DatabaseHelper.instance.insertUser(element);
        });
        user =
            List.from(response.data).map((e) => UserModel.fromJson(e)).toList();
        Future<List<UserModel>> users = DatabaseHelper.instance.users();
      } else {
        throw Exception('${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw Exception(e);
    }
    return user;
  }
}
