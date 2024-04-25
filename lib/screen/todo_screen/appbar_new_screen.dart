import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gghup01/router/router.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable, camel_case_types
class app_Barnew extends StatelessWidget {
  bool FindTodoId;
  app_Barnew({super.key, required this.FindTodoId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                    FindTodoId ? 'Your Todo' : 'Add Your Todo',
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
    );
  }
}
