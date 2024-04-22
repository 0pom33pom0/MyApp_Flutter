import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/tool_app/input_fromtodo.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_newTodo extends StatefulWidget {
  const home_newTodo({Key? key});

  @override
  State<home_newTodo> createState() => _home_newTodoState();
}

class _home_newTodoState extends State<home_newTodo> {
  int FindUserId = 0;
  int FindTodoId = 0;
  String FindTitel_Todo = " ";
  String FindDesc_todo = " ";
  bool FindCompleted_todo = false;
  late final TextEditingController _title;
  late final TextEditingController _content;
  late bool _light = false;

  @override
  void initState() {
    _title = TextEditingController();
    _content = TextEditingController();
    super.initState();
    _FindData();
  }

  Future _FindData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      FindUserId = prefs.getInt('user_id') ?? 0;
      FindTodoId = prefs.getInt('todoid') ?? 0;
      FindTitel_Todo = prefs.getString('title_todo')!;
      FindDesc_todo = prefs.getString('desc_todo')!;
      FindCompleted_todo = prefs.getBool('completed_todo') ?? false;
      if (FindTodoId > 0) {
        _title.text = FindTitel_Todo;
        _content.text = FindDesc_todo;
        _light = FindCompleted_todo;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  HexColor('#4CC599'),
                  HexColor('#0D7A5C'),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 21,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#FFFFFF').withOpacity(0.4)),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: HexColor("#FFFFFF"),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          todoRoutes,
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 9),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        FindTodoId > 0 ? 'Your Todo' : 'Add Your Todo',
                        style: TextStyle(
                          fontFamily: 'outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#FFFFFF"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            children: [
              Input_fromTodo(
                  title: "Title",
                  data: _title,
                  maxLines: 1,
                  textAction: TextInputAction.next),
              const SizedBox(height: 10),
              Input_fromTodo(
                  title: "Decription",
                  data: _content,
                  maxLines: 7,
                  textAction: TextInputAction.done),
              const SizedBox(height: 10),
              SizedBox(
                child: Container(
                  height: 59,
                  decoration: BoxDecoration(
                      color: HexColor("#FFFFFF"),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                          spreadRadius: 0, // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Row(children: [
                        Text(
                          'Success',
                          style: TextStyle(
                              color: HexColor('#0D7A5C'),
                              fontFamily: 'outfit',
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: _light,
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              setState(() {
                                _light = value;
                              });
                            },
                          ),
                        ),
                      ])),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 339,
                height: 70,
                child: GradientElevatedButton(
                  onPressed: () {
                    if (FindTodoId > 0) {
                      edittodo(_title.text.toString(), _content.text.toString(),
                          _light.toString(), FindUserId, FindTodoId, context);
                    } else {
                      savetodo(_title.text.toString(), _content.text.toString(),
                          _light.toString(), FindUserId, context);
                    }
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
                    "Save",
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
        ));
  }

  void savetodo(String title, desc, completed, UserId, context) async {
    await MyApi().SeveTodo(title, desc, completed, UserId, context);
  }

  void edittodo(String title, desc, completed, UserId, todoid, context) async {
    await MyApi().EditTodo(title, desc, completed, UserId, todoid, context);
  }
}
