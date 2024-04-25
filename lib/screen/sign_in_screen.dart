import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/tool_app/fromsing_tool.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pState();
}

class _Login_pState extends State<Login_page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/backgroud_manu.png"), // รูปภาพเป็น background ด้านหลัง
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(builder: (context, contraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: contraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Input_from(
                          title: "Email",
                          data: _email,
                          type_text: TextInputType.emailAddress,
                          checkpass: false,
                          textAction: TextInputAction.next,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Enter Your Email"),
                            EmailValidator(
                                errorText: "Enter Correct Email Address")
                          ]).call,
                        ),
                        Input_from(
                            title: "Password",
                            data: _password,
                            type_text: TextInputType.visiblePassword,
                            checkpass: true,
                            textAction: TextInputAction.done,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'password is required'),
                              // MinLengthValidator(8,
                              //     errorText:
                              //         'password must be at least 8 digits long'),
                            ]).call)
                      ],
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 43),
                    child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: GradientElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // ถ้าข้อมูลผ่านการตรวจสอบ validator
                            // คุณสามารถดำเนินการต่อไปตามต้องการได้ที่นี่
                            login(_email.text.toString(),
                                _password.text.toString(), context);
                          }
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(43, 20, 43, 0),
                    child: SizedBox(
                      width: double.infinity,
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
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ));
  }

  void login(String email, password, context) async {
    await MyApi().login(email, password, context);
  }
}
