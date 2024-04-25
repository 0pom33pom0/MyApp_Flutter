import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/screen/todo_screen/appbar_new_screen.dart';
import 'package:flutter_gghup01/tool_app/fromtodo_tool.dart';
import 'package:flutter_gghup01/tool_app/showtodo_tool.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_newTodo extends StatefulWidget {
  final ShowTodo? todo;
  const home_newTodo({Key? key, this.todo});

  @override
  State<home_newTodo> createState() => _home_newTodoState();
}

class _home_newTodoState extends State<home_newTodo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  late bool _light = false;
  bool FindTodoId = false;
  int FindUserId = 0;

  @override
  void initState() {
    _title = TextEditingController();
    _content = TextEditingController();
    super.initState();
    _FindData();
  }

  Future _FindData() async {
    if (widget.todo != null) {
      FindTodoId = true;
      FindUserId = widget.todo!.userId;
      _title.text = widget.todo!.title;
      _content.text = widget.todo!.content;
      _light = widget.todo!.isCompleted;
    } else {
      final prefs = await SharedPreferences.getInstance();
      FindUserId = prefs.getInt('user_id') ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (route) => false);
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: app_Barnew(
              FindTodoId: FindTodoId,
            ),
          ),
          body: LayoutBuilder(builder: (context, contraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: contraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(21),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input_fromTodo(
                              title: "Title",
                              data: _title,
                              maxLines: 1,
                              textAction: TextInputAction.next,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Enter Your Title"),
                                PatternValidator(r'^\S',
                                    errorText:
                                        'First character cannot be a whitespace')
                              ]).call),
                          const SizedBox(height: 10),
                          Input_fromTodo(
                              title: "Decription",
                              data: _content,
                              maxLines: 7,
                              textAction: TextInputAction.newline,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Enter Your Decription"),
                                PatternValidator(r'^\S',
                                    errorText:
                                        'First character cannot be a whitespace')
                              ]).call),
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
                                      spreadRadius:
                                          0, // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 19),
                            child: SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: GradientElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (FindTodoId == false) {
                                      savetodo(
                                          _title.text.toString(),
                                          _content.text.toString(),
                                          _light.toString(),
                                          FindUserId,
                                          context);
                                    } else {
                                      edittodo(
                                          _title.text.toString(),
                                          _content.text.toString(),
                                          _light.toString(),
                                          FindUserId,
                                          FindTodoId,
                                          context);
                                    }
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
                                  "Save",
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
                ),
              ),
            );
          })),
    );
  }

  void savetodo(String title, desc, completed, UserId, context) async {
    await MyApi().SeveTodo(title, desc, completed, UserId, context);
  }

  void edittodo(String title, desc, completed, UserId, todoid, context) async {
    await MyApi()
        .EditTodo(title, desc, completed, UserId, todoid, false, context);
  }
}
