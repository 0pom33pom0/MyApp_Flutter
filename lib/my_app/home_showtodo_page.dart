// import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/tool_app/showlisttodo.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_showtodo extends StatefulWidget {
  const home_showtodo({super.key});

  @override
  State<home_showtodo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<home_showtodo> {
  String? FindFirstname;
  String? FindLastname;
  String? isCompleted;
  int? FindUserId;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    _FindData();
  }

  Future _FindData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      FindFirstname = prefs.getString('user_fname');
      FindLastname = prefs.getString('user_lname');
      FindUserId = prefs.getInt('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(76, 197, 153, 1),
                  Color.fromRGBO(13, 122, 92, 1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
              child: Row(
                children: [
                  Container(
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      shadows: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                        onTap: () {
                          _logoutBottomSheet(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: HexColor("#FBFBFB"),
                          child: Text(
                            FindFirstname.toString()[0].toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'outfit',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: HexColor("#53CD9F")),
                          ),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello!",
                        style: TextStyle(
                            fontFamily: 'outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: HexColor("#FFFFFF")),
                      ),
                      Text(
                        "$FindFirstname $FindLastname",
                        style: const TextStyle(
                            fontFamily: 'outfit',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
      body: FutureBuilder(
        future: MyApi().todo_list(FindUserId.toString(), context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List _tododata = snapshot.data;
            //return //Text(_tododata.toList().toString());
            return ListView.builder(
              itemCount: _tododata.toList().length,
              itemBuilder: (context, index) {
                final tododata = _tododata.toList()[index];
                return ShowTodo(
                    title: tododata['user_todo_list_title'],
                    content: tododata['user_todo_list_desc'],
                    date: DateFormat('hh:mm a - dd/MM/yy').format(
                        DateTime.parse(tododata['user_todo_list_last_update'])
                            .toLocal()),
                    isCompleted: tododata['user_todo_list_completed'] == "true"
                        ? true
                        : false,
                    id: tododata['user_todo_list_id']);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#0D7A5C'),
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('todoid', 0);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(newTodoRoutes, (routes) => false);
        },
        shape: const CircleBorder(),
        tooltip: 'Increment',
        child: const ImageIcon(
          AssetImage(
            'assets/images/icon_newtodo.png',
          ),
          size: 40,
        ),
      ),
    );
  }

  void signOut(context) async {
    await MyApi().logout(context);
  }

  // ignore: non_constant_identifier_names
  Future _logoutBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) => SizedBox(
              height: 250,
              width: 428,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: 52,
                  height: 3,
                  decoration: BoxDecoration(
                    color: HexColor("#D9D9D9"),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
                Text("SIGN OUT",
                    style: TextStyle(
                      fontFamily: 'outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: HexColor("#473B1E"),
                    )),
                const SizedBox(
                  height: 19,
                ),
                Text("Do you want to log out?",
                    style: TextStyle(
                      fontFamily: 'outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#473B1E"),
                    )),
                const SizedBox(
                  height: 59,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () {
                      signOut(context);
                    },
                    child: Container(
                      color: HexColor("#000000").withOpacity(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  Image.asset("assets/images/icon_logut.png")),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Signout",
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: HexColor("#0D7A5C")),
                          ),
                          const SizedBox(
                            width: 236,
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.chevron_right,
                              color: HexColor("#0D7A5C"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ));
  }
}
