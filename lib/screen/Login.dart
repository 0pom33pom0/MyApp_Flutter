// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
// import 'package:flutter_gghup01/my_app/home_showtodo_page.dart';
import 'package:flutter_gghup01/router/router.dart';
// import 'package:flutter_gghup01/screen/sing_up.dart';
import 'package:flutter_gghup01/tool_app/input_from.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
// import 'package:http/http.dart' as http;

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pState();
}

class _Login_pState extends State<Login_page> {
  //final _navigatorKey = GlobalKey<NavigatorState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showSuackBar(String message) {
    final snackBar =
        SnackBar(content: Text(message), duration: const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Expanded(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/backgroud_manu.png"), // รูปภาพเป็น background ด้านหลัง
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 59,
                  ),
                  const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  const Text("Please enter the information\nbelow to access.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                      )),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/icon_sigin.png",
                    width: 98, // กำหนดความกว้างของภาพ
                    height: 98, // กำหนดความสูงของภาพ
                    fit: BoxFit.cover, // ปรับขนาดของภาพให้พอดีกับขนาดที่กำหนด
                  ),
                  const SizedBox(height: 34),
                  Input_from(
                      title: "Email",
                      data: _email,
                      type_text: TextInputType.emailAddress,
                      check: false),
                  const SizedBox(
                      height: 19), // เพิ่มระยะห่างระหว่างช่องใส่ข้อมูล
                  Input_from(
                      title: "Password",
                      data: _password,
                      type_text: TextInputType.visiblePassword,
                      check: true),
                  const SizedBox(height: 19),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  SizedBox(
                    width: 339,
                    height: 70,
                    child: GradientElevatedButton(
                      onPressed: () {
                        login(_email.text.toString(), _password.text.toString(),
                            context);
                      },
                      style: GradientElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // ปรับความโค้งของเหลียม
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 83, 205, 159),
                            Color.fromARGB(255, 13, 122, 92),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 339,
                    height: 70,
                    child: GradientElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            singupRoutes, (routes) => false);
                      },
                      style: GradientElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // ปรับความโค้งของเหลียม
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 13, 112, 92),
                            Color.fromARGB(255, 0, 80, 62),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void login(String email, password, context) async {
    await MyApi().login(email, password, context);
  }
}
