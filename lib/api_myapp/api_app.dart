import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gghup01/model/todo_model.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApi {
  String Url = 'http://192.168.26.16:6004';
  final header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676' //ออเทอเซชัน
  };

  Future<void> login(String email, password, BuildContext context) async {
    final Api = Uri.parse('$Url/api/login');
    final body = jsonEncode({'user_email': email, 'user_password': password});
    try {
      final response = await http.post(Api, headers: header, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('login_check', true);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('user_email', data['user_email']);
        await prefs.setString('user_fname', data['user_fname']);
        await prefs.setString('user_lname', data['user_lname']);

        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: 'success',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: 'Login successful',
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2000))
            .show()
            .then((value) => Navigator.of(context)
                .pushNamedAndRemoveUntil(todoRoutes, (routes) => false));
      } else {
        final errorcheck = jsonDecode(response.body);
        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'unsuccessful',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: errorcheck['message'],
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2500))
            .show();
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: 'No internet connection.',
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 2500))
          .show();
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
    try {
      final response = await http.post(Api, headers: header, body: body);
      if (response.statusCode == 200) {
        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: 'success',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: 'Login successful',
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2000))
            .show()
            .then((value) => Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoutes, (routes) => false));
      } else {
        final errorcheck = jsonDecode(response.body);
        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'unsuccessful',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: errorcheck['message'],
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2500))
            .show();
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: 'Internet Not Connect',
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 2500))
          .show();
    }
  }

  Future<void> logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('login_check', false);
    AwesomeDialog(
            context: context,
            width: 360,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'success',
            titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
            desc: 'Logout successful',
            descTextStyle: const TextStyle(fontFamily: 'Outfit'),
            autoHide: const Duration(milliseconds: 2000))
        .show()
        .then((value) => Navigator.of(context)
            .pushNamedAndRemoveUntil(loginRoutes, (routes) => false));
  }

  Future<List<Todo>> todo_list(String userId, context) async {
    try {
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
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: 'Internet Not Connect',
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 3000))
          .show();
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
    try {
      final response = await http.post(Api, headers: header, body: body);
      if (response.statusCode == 200) {
        if (response.body != "OK") {
          AwesomeDialog(
                  context: context,
                  width: 360,
                  dialogType: DialogType.error,
                  animType: AnimType.bottomSlide,
                  title: 'Unsuccessful',
                  titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  desc: jsonDecode(response.body)["sqlMessage"].toString(),
                  descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  autoHide: const Duration(milliseconds: 2500))
              .show();
        } else {
          AwesomeDialog(
                  context: context,
                  width: 360,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  title: 'success',
                  titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  desc: 'Save successful',
                  descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  autoHide: const Duration(milliseconds: 2000))
              .show()
              .then((value) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(todoRoutes, (routes) => false));
        }
      } else {
        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'Unsuccessful',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: jsonDecode(response.body)["message"],
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2500))
            .show();
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: e.toString(),
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 2500))
          .show();
    }
  }

  Future<void> EditTodo(
      title, desc, completed, userId, todoid, checkbox, context) async {
    final Api = Uri.parse('$Url/api/update_todo');
    final body = jsonEncode({
      "user_todo_list_id": todoid,
      "user_todo_list_title": title,
      "user_todo_list_desc": desc,
      "user_todo_list_completed": completed,
      "user_id": userId,
      "user_todo_type_id": 1,
    });
    try {
      final response = await http.post(Api, headers: header, body: body);
      if (response.statusCode == 200) {
        if (checkbox != true) {
          AwesomeDialog(
                  context: context,
                  width: 360,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  title: 'success',
                  titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  desc: 'Save successful',
                  descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                  autoHide: const Duration(milliseconds: 2000))
              .show()
              .then((value) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(todoRoutes, (routes) => false));
        } else {
          null;
        }
      } else {
        AwesomeDialog(
                context: context,
                width: 360,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'Unsuccessful',
                titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
                desc: 'Save Unsuccessful',
                descTextStyle: const TextStyle(fontFamily: 'Outfit'),
                autoHide: const Duration(milliseconds: 2500))
            .show();
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: 'Internet Not Connect',
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 2500))
          .show();
    }
  }

  Future<http.Response> DeleteTodo(int todoid, context) async {
    final api = Uri.parse('$Url/api/delete_todo/$todoid');
    try {
      var response = await http.delete(api, headers: header);
      return response;
    } catch (e) {
      AwesomeDialog(
              context: context,
              width: 360,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Internet',
              titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
              desc: 'Internet Not Connect',
              descTextStyle: const TextStyle(fontFamily: 'Outfit'),
              autoHide: const Duration(milliseconds: 2500))
          .show();
      throw Exception('Error deleting todo');
    }
  }
}
