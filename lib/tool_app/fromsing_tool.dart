import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//ฟอร์มต้นแบบ
class Input_from extends StatefulWidget {
  final String title;
  final TextEditingController data;
  final TextInputType type_text;
  final bool checkpass;
  final TextInputAction textAction;
  final FormFieldValidator<String> validator;
  Input_from(
      {super.key,
      required this.title,
      required this.data,
      required this.type_text,
      required this.checkpass,
      required this.textAction,
      required this.validator});

  @override
  State<Input_from> createState() => _Input_fromState();
}

class _Input_fromState extends State<Input_from> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.checkpass;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(45, 0, 45, 19),
      child: Container(
          height: 59,
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 208, 208, 208), // กำหนดสีพื้นหลังด้วยรหัสสี HEX
            borderRadius: BorderRadius.circular(15), // กำหนดขอบโค้ง
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3), // กำหนดสีพื้นหลังด้วยรหัสสี HEX
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                textInputAction: widget.textAction,
                controller: widget.data,
                validator: widget.validator,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                obscureText: obscureText,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                ),
                keyboardType: widget.type_text,
                decoration: InputDecoration(
                  hintText: widget.title,
                  border: InputBorder.none, // เอาเส้นขอบออก
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  suffixIcon: widget.checkpass
                      ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          )),
    );
  }
}
