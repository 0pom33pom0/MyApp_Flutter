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
import 'package:flutter_gghup01/screen/todo_screen/appbar_show_screen.dart';
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
  bool nodatacheck = true;

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
      nodatacheck = true;
      searchTodos = todos;
    } else {
      nodatacheck = false;
    }
    setState(() {
      todos = _getTodos(FindUserId!);
    });
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: app_Barshow(
            Firstname: FindFirstname!,
            Lastname: FindLastname!,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
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
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
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
                          if (searchTodos.isEmpty) {
                            return ListView(
                              children: [
                                Center(
                                  child: Text(
                                    nodatacheck
                                        ? "add your todo"
                                        : "Todo not found.",
                                    style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: HexColor("#473B1E")),
                                  ),
                                ),
                              ],
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
                                  todoId: tododata.id,
                                  userId: FindUserId ?? 0);
                            },
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          children: const [
                            Center(
                                child: Text("No internet!",
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ))),
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#0D7A5C'),
          onPressed: () {
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

  void _showBackDialog(context) {
    AwesomeDialog(
        context: context,
        width: 360,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        headerAnimationLoop: true,
        title: 'Close?',
        titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
        desc: 'Do you want to close the app?',
        descTextStyle: const TextStyle(fontFamily: 'Outfit'),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          SystemNavigator.pop();
        }).show();
  }

  Future<void> _refresh() async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
  }
}
