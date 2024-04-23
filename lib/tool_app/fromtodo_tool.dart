import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Input_fromTodo extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextEditingController data;
  final TextInputAction textAction;
  Input_fromTodo({
    super.key,
    required this.title,
    required this.data,
    required this.maxLines,
    required this.textAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: TextFormField(
          textInputAction: textAction,
          maxLines: maxLines,
          controller: data,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                color: HexColor("#666161"),
                fontSize: 16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
