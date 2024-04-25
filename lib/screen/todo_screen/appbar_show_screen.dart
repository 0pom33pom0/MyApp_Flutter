import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gghup01/api_myapp/api_app.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable, camel_case_types
class app_Barshow extends StatelessWidget {
  String Firstname;
  String Lastname;
  app_Barshow({super.key, required this.Firstname, required this.Lastname});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        // toolbarHeight: 100,
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
                      Firstname.toString()[0].toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor("#53CD9F")),
                    ),
                  )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
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
                    "$Firstname $Lastname",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: 'outfit',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

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
              width: double.infinity,
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
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: GestureDetector(
                    onTap: () {
                      signOut(context);
                    },
                    child: Container(
                      color: HexColor("#000000").withOpacity(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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

  void signOut(context) {
    AwesomeDialog(
        context: context,
        width: 360,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Logout?',
        titleTextStyle: const TextStyle(fontFamily: 'Outfit'),
        desc: 'Do you want to Logout?',
        descTextStyle: const TextStyle(fontFamily: 'Outfit'),
        btnCancelOnPress: () {
          Navigator.pop(context);
        },
        btnOkOnPress: () async {
          await MyApi().logout(context);
        }).show();
  }
}
