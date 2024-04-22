import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//ฟอร์มต้นแบบ
class Input_from extends StatelessWidget {
  final String title;
  final TextEditingController data;
  final TextInputType type_text;
  final bool check;
  Input_from(
      {super.key,
      required this.title,
      required this.data,
      required this.type_text,
      required this.check});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 339,
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
              controller: data,
              obscureText: check,
              style: const TextStyle(
                fontFamily: 'Outfit',
              ),
              keyboardType: type_text,
              decoration: InputDecoration(
                hintText: title,
                border: InputBorder.none, // เอาเส้นขอบออก
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal:
                        20), // ปรับขนาดแนวราบและตั้งค่าความสูงของช่องใส่ข้อมูล
              ),
            ),
          ),
        ));
  }
}
