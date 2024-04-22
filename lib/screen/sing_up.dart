import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/tool_app/input_from.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';

class Singup_page extends StatefulWidget {
  const Singup_page({super.key});

  @override
  State<Singup_page> createState() => _Singup_pageState();
}

class _Singup_pageState extends State<Singup_page> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/backgroud_manu.png"), // รูปภาพเป็น background ด้านหลัง
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 49,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: HexColor("#3CB189").withOpacity(0.4)),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: HexColor("#3CB189")),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoutes, (route) => false);
                          },
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN UP',
                              style:
                                  TextStyle(fontFamily: 'Outfit', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text("Please enter the information \nbelow to access.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                    )),
                const SizedBox(
                  height: 32,
                ),
                Image.asset(
                  "assets/images/icon_signup.png",
                  width: 98, // กำหนดความกว้างของภาพ
                  height: 98, // กำหนดความสูงของภาพ
                  fit: BoxFit.cover, // ปรับขนาดของภาพให้พอดีกับขนาดที่กำหนด
                ),
                const SizedBox(
                  height: 38,
                ),
                Input_from(
                    title: "First name",
                    data: _firstName,
                    type_text: TextInputType.name,
                    check: false,
                    textAction: TextInputAction.next),
                const SizedBox(
                  height: 17,
                ),
                Input_from(
                    title: "Last name",
                    data: _lastName,
                    type_text: TextInputType.name,
                    check: false,
                    textAction: TextInputAction.next),
                const SizedBox(
                  height: 17,
                ),
                Input_from(
                    title: "Email",
                    data: _email,
                    type_text: TextInputType.emailAddress,
                    check: false,
                    textAction: TextInputAction.next),
                const SizedBox(
                  height: 17,
                ),
                Input_from(
                    title: "Password",
                    data: _password,
                    type_text: TextInputType.visiblePassword,
                    check: true,
                    textAction: TextInputAction.done),
                const SizedBox(
                  height: 58,
                ),
                SizedBox(
                  width: 339,
                  height: 70,
                  child: GradientElevatedButton(
                    onPressed: () {
                      singup_users(
                          _firstName.text.toString(),
                          _lastName.text.toString(),
                          _email.text.toString(),
                          _password.text.toString());
                    },
                    style: GradientElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // ปรับความโค้งของเหลียม
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
    );
  }

  void singup_users(firstName, lastName, email, password) async {
    await MyApi().singup(firstName, lastName, email, password, context);
  }
}
