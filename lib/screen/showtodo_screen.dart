// import 'dart:html';

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/model/todo_model.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:flutter_gghup01/tool_app/showtodo_tool.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_showtodo extends StatefulWidget {
  const home_showtodo({super.key});

  @override
  State<home_showtodo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<home_showtodo> {
  late final TextEditingController _search;
  late Future<List<Todo>> todos = Future.value([]);
  late Future<List<Todo>> searchTodos = Future.value([]);
  String? FindFirstname;
  String? FindLastname;
  String? isCompleted;
  int? FindUserId;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _FindData();
  }

  Future _FindData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      FindFirstname = prefs.getString('user_fname');
      FindLastname = prefs.getString('user_lname');
      FindUserId = prefs.getInt('user_id');
    });
    if (FindUserId != null) {
      setState(() {
        todos = _getTodos(FindUserId!);
        searchTodos = todos;
      });
    }
  }

  Future<void> search(enteredKeyword) async {
    if (enteredKeyword.isEmpty) {
      searchTodos = todos;
    }
    final filteredRes = (await todos)
        .where((todo) =>
            todo.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    setState(() {
      searchTodos = Future.value(filteredRes);
    });
  }

  Future<List<Todo>> _getTodos(userId) async {
    return await MyApi().todo_list(userId.toString(), context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog(context);
      },
      child: Scaffold(
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 21, 20, 16),
              child: Container(
                height: 59,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColor("#FFFFFF"),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 4,
                      spreadRadius: 0, // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        onChanged: search,
                        maxLines: 1,
                        controller: _search,
                        decoration: InputDecoration(
                          prefixIcon: ImageIcon(
                            const AssetImage(
                                'assets/images/icon_search.png'), // ระบุ path ของไอคอน
                            size: 20, // กำหนดขนาดของไอคอน
                            color: HexColor('#AEAEB2'), // กำหนดสีของไอคอน
                          ),
                          hintText: 'Search.......',
                          hintStyle: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              color: HexColor("#AEAEB2"),
                              fontSize: 15),
                          border: InputBorder.none, // เอาเส้นขอบออก
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Todo>>(
                  future: searchTodos,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      List<Todo>? searchTodos = snapshot.data;
                      if (searchTodos != null) {
                        if (searchTodos.length == 0) {
                          return Text(
                            "add your todo",
                            style: TextStyle(
                                fontFamily: 'outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: HexColor("#473B1E")),
                          );
                        }
                        return ListView.builder(
                          itemCount: searchTodos.length,
                          itemBuilder: (context, index) {
                            Todo tododata = searchTodos[index];
                            return ShowTodo(
                                title: tododata.title,
                                content: tododata.content,
                                date: tododata.date,
                                isCompleted: tododata.isCompleted == 'true'
                                    ? true
                                    : false,
                                id: tododata.id);
                          },
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#0D7A5C'),
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
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
      ),
    );
  }

  void signOut(context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Logout?',
        desc: 'Do you want to Logout?',
        btnCancelOnPress: () {
          Navigator.pop(context);
        },
        btnOkOnPress: () async {
          await MyApi().logout(context);
        }).show();
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

  void _showBackDialog(context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        headerAnimationLoop: true,
        title: 'Close?',
        desc: 'Do you want to close the app?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          SystemNavigator.pop();
        }).show();
  }
}
