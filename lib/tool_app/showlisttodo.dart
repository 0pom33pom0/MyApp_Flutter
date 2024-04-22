import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:flutter_gghup01/router/router.dart';
// import 'package:flutter_gghup01/router/router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ShowTodo extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  late bool isCompleted;
  final int id;
  ShowTodo({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.isCompleted,
    required this.id,
  });

  @override
  State<ShowTodo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ShowTodo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 5, 21, 5),
      child: Center(
          child: Container(
        decoration: BoxDecoration(
          color: HexColor("#FFFFFF"),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              spreadRadius: 0, // changes position of shadow
            ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 23, 0, 0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: widget.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.isCompleted = value ?? false;
                    });
                  },
                  shape: const CircleBorder(),
                  checkColor: Colors.white,
                  activeColor: HexColor("#3CB189"),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 21, 0, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          fontFamily: 'outfit',
                          color: HexColor("#0D7A5C"),
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  Text(widget.date,
                      style: TextStyle(
                          fontFamily: 'outfit',
                          color: HexColor("#D9D9D9"),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  Text(widget.content,
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'outfit',
                          color: HexColor("#666161").withOpacity(0.68),
                          fontSize: 12,
                          fontWeight: FontWeight.w500))
                ],
              ),
            )),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.more_horiz,
                      color: HexColor("#666161").withOpacity(0.68)),
                  onPressed: () {
                    _displayBottomSheet(context, widget.id);
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future _displayBottomSheet(BuildContext context, int widget) async {
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
                  height: 75,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: GestureDetector(
                    onTap: () {
                      updetaTddo(widget);
                    },
                    child: Container(
                      height: 45,
                      color: HexColor("#000000").withOpacity(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  Image.asset("assets/images/icon_edit.png")),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: HexColor("#0D7A5C")),
                          ),
                          const Spacer(),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: Divider(
                    //height: 0.5,
                    color: HexColor("000000").withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: GestureDetector(
                    onTap: () async {
                      final kk = await deleteTodo(widget, context);
                      if (kk == true) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: "Success",
                          desc: "ลบสำเสร็จ",
                          dismissOnTouchOutside: false,
                          btnOkOnPress: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                todoRoutes, (routes) => false);
                          },
                        ).show();
                      } else {
                        print("GG");
                      }
                    },
                    child: Container(
                      height: 45,
                      color: HexColor("#000000").withOpacity(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  Image.asset("assets/images/icon_trash.png")),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: HexColor("#0D7A5C")),
                          ),
                          const Spacer(),
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

  Future<bool> deleteTodo(int id, context) async {
    final re = await MyApi().DeleteTodo(id);
    print(re.statusCode);
    if (re.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updetaTddo(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('todoid', id);
    await prefs.setString('title_todo', widget.title);
    await prefs.setString('desc_todo', widget.content);
    await prefs.setBool('completed_todo', widget.isCompleted);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(newTodoRoutes, (routes) => false);
  }
}
