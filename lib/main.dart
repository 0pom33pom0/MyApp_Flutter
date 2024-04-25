import 'package:flutter/material.dart';
import 'package:flutter_gghup01/screen/todo_screen/newtodo_screen.dart';
import 'package:flutter_gghup01/screen/todo_screen/showtodo_screen.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/screen/sign_in_screen.dart';
import 'package:flutter_gghup01/screen/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isFirsttimeuse = prefs.getBool('login_check') ??
      false; //หาข้อมูลที่ผู้ใช้เคยเข้า หากไม่เคยจะส่งค่าเป็นเท็จ
  runApp(MyApp(
      isFirsttimeuse: isFirsttimeuse)); //รันMyApp และส่งค่า isFirsttimeuse
}

class MyApp extends StatelessWidget {
  final bool isFirsttimeuse;

  const MyApp({super.key, required this.isFirsttimeuse});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3:
              false, //กำหนดให้แอปพลิเคชันไม่ใช้งานธีม Material Design รุ่น 3
        ),
        home: isFirsttimeuse
            ? const home_showtodo()
            : const Login_page(), //เช็คข้อมูลที่ได้
        routes: {
          //กำหนดเส้นทาง
          loginRoutes: (context) =>
              const Login_page(), //loginRoutes: กำหนดเส้นทางสำหรับหน้า Login_page()
          singupRoutes: (context) =>
              const Singup_page(), //singupRoutes: กำหนดเส้นทางสำหรับหน้า Singup_page()
          todoRoutes: (context) =>
              const home_showtodo(), //todoRoutes: กำหนดเส้นทางสำหรับหน้า home_showtodo()
          newTodoRoutes: (context) =>
              const home_newTodo(), //newTodoRoutes: กำหนดเส้นทางสำหรับหน้า home_newTodo()
        });
  }
}
