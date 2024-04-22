import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gghup01/model/todo_model.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApi {
  String Url = 'http://10.0.2.2:6004';
  final header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676'
  };

  Future<void> login(String email, password, BuildContext context) async {
    final Api = Uri.parse('$Url/api/login');
    final body = jsonEncode({'user_email': email, 'user_password': password});
    final response = await http.post(Api, headers: header, body: body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool('login_check', true);
      await prefs.setInt('user_id', data['user_id']);
      await prefs.setString('user_email', data['user_email']);
      await prefs.setString('user_fname', data['user_fname']);
      await prefs.setString('user_lname', data['user_lname']);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
    } else {
      print("ไม่ผ่าน");
    }
  }

  Future<void> singup(firstName, lastName, email, password, context) async {
    final Api = Uri.parse('$Url/api/create_user');
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
      "user_fname": firstName,
      "user_lname": lastName,
    });
    final response = await http.post(Api, headers: header, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed(loginRoutes);
    } else {
      print('failed');
    }
  }

  Future<void> logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginRoutes, (routes) => false);
    await prefs.setBool('login_check', false);
  }

  Future<List<Todo>> todo_list(String userId, context) async {
    final response = await http.get(Uri.parse('$Url/api/todo_list/$userId'),
        headers: header);
    if (response.statusCode == 200) {
      final todoData = jsonDecode(response.body) as List<dynamic>;
      return todoData.map((item) {
        DateTime dateTime =
            DateTime.parse(item['user_todo_list_last_update']).toLocal();
        String formattedDate =
            DateFormat('hh:mm a - dd/MM/yy').format(dateTime);
        return Todo(
          title: item['user_todo_list_title'],
          content: item['user_todo_list_desc'],
          date: formattedDate,
          id: item['user_todo_list_id'],
          isCompleted: item['user_todo_list_completed'],
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  Future<void> SeveTodo(title, desc, completed, userId, context) async {
    final Api = Uri.parse('$Url/api/create_todo');
    final body = jsonEncode({
      "user_todo_type_id": 1,
      "user_todo_list_title": title,
      "user_todo_list_desc": desc,
      "user_todo_list_completed": completed,
      "user_id": userId,
    });
    final response = await http.post(Api, headers: header, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
    } else {
      print('failed');
    }
  }

  Future<void> EditTodo(title, desc, completed, userId, todoid, context) async {
    final Api = Uri.parse('$Url/api/update_todo');
    final body = jsonEncode({
      "user_todo_list_id": todoid,
      "user_todo_list_title": title,
      "user_todo_list_desc": desc,
      "user_todo_list_completed": completed,
      "user_id": userId,
      "user_todo_type_id": 1,
    });
    final response = await http.post(Api, headers: header, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
    } else {
      print('failed');
    }
  }

  Future<http.Response> DeleteTodo(int todoid) async {
    final api = Uri.parse('$Url/api/delete_todo/$todoid');
    try {
      var response = await http.delete(api, headers: header);
      return response;
    } catch (e) {
      throw Exception('Error deleting todo');
    }
  }
}
