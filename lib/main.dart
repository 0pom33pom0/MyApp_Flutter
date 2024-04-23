import 'package:flutter/material.dart';
import 'package:flutter_gghup01/screen/newtodo_screen.dart';
import 'package:flutter_gghup01/screen/showtodo_screen.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/screen/sing_in_screen.dart';
import 'package:flutter_gghup01/screen/sing_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isFirsttimeuse = prefs.getBool('login_check') ?? false;
  runApp(MyApp(isFirsttimeuse: isFirsttimeuse));
}

class MyApp extends StatelessWidget {
  final bool isFirsttimeuse;

  const MyApp({super.key, required this.isFirsttimeuse});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: isFirsttimeuse ? const home_showtodo() : const Login_page(),
        routes: {
          loginRoutes: (context) => const Login_page(),
          singupRoutes: (context) => const Singup_page(),
          todoRoutes: (context) => const home_showtodo(),
          newTodoRoutes: (context) => const home_newTodo(),
        });
  }
}
